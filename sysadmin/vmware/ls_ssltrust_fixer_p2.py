#!/usr/bin/env python
'''
Program: ls_ssltrust_fixer
    Attempt to automate https://kb.vmware.com/s/article/2121701
    with intentions to scan against certificate mismatch on service registrations and fixing the mismatch

    
        Scope: Scan for mismatch, fix the mismatch based on scan result as second step
        Authors: Jishnu Surendran Thankamani (jishnut@vmware.com), Ramprasad K.S. (ramprasad@vmware.com)
        Copyright: 2017 Vmware Inc


'''


import lstoolutil
import ssl
import socket
import re
import hashlib
import base64
import logging
import os,errno
import argparse
import getpass
import sys
import subprocess

ConnectFailure_ct=0
ConnectFailure_nodes=[]
certcache = {}
logger = None 
logdir=os.environ["VMWARE_LOG_DIR"]+ os.path.sep +"ls_ssltrust_fixer" + os.path.sep
    
#Move lstool_communicate function here to control logging
def lstoolcommunicate(argv, stdout=subprocess.PIPE):
    """
    Lookup service client tool
    """
    log4jcfile = logdir + 'log4j.conf'
    with open(log4jcfile, "w") as log4jcfile_fh:
        log4jcfile_fh.write("log4j.rootLogger=OFF")
    java = lstoolutil._get_java()
    javacpath = lstoolutil._get_classpath()
    javasec = lstoolutil._get_java_security_properties()
    cmd = [java,
          "-Djava.security.properties=%s" % javasec,
          "-cp",
          javacpath,
          "-Dlog4j.configuration=file:%s" % log4jcfile]
    cmd.append("com.vmware.vim.lookup.client.tool.LsTool")
    cmd += argv
    process = subprocess.Popen(cmd, stdout=stdout)
    stdout, _ = process.communicate(None)
    return process.returncode, stdout

def right_psc(id,psctosite,idtosite, psc_blacklist):
    thesite = None
    for site in psctosite:
        if ((psctosite[site] == idtosite.get(id)) and (site not in psc_blacklist)):
            thesite = site
            break
    return thesite

def read_topology(lsout):
    psctosite={}
    idtosite={}
    id = site = ""
    for line in lsout.splitlines():
        if "Service ID" in line:
            (dummy, id) = line.split(': ', 1)
        elif "Site ID" in line:
            (dummy, site) = line.split(': ', 1)
            idtosite[id] = site
        elif (("URL" in line) and ("sso-adminserver" in line)):
            (dummy, url) = line.split(': ', 1)
            url = url.split('//', 2)[1].split('/')[0].split(':')[0]
            psctosite[url] = site
    return(psctosite,idtosite)

def _findFirstMatch(lines, pat):
   idx = 0
   for line in lines:
      if re.match(pat, line):
         return (line, idx)
         break
      idx = idx + 1
   return (None, -1)
   
def _modify_ep_certs(oldspec, newspec, newCert):
    update_ct = 0
    ssltrust_ct = 0
    oldlines = []
    newlines = []
    with open(oldspec,"r") as oldspec_fh:
        lines = oldspec_fh.read().splitlines()
    for line in lines:
        if (line.find('ssltrust') == -1):
            newlines.append(line)
        else:
            (key,oldcert) = line.split('=', 1)
            newlines.append('{0}={1}'.format(key, newCert.replace('\\', '\\\\')))
            update_ct = update_ct + 1
    with open(newspec,"w") as newspec_fh:
        newspec_fh.write("\n".join(newlines))
    return update_ct

def parseopts(args):
    '''Parse the command line options'''
    parser = argparse.ArgumentParser()
    required_set = parser.add_argument_group('required')
    required_set.add_argument('-f', '--function', dest='function', help='scan or fix', default = '', required=True)
    return parser.parse_args(args)

def get_cur_cert(spec):
    global ConnectFailure_ct
    global ConnectFailure_nodes
    newcert = None
    with open(spec, "r") as spec_fh:
        for line in spec_fh.read().splitlines():
            if "endpoint0.url" in line:
                url = line.split('=', 1)[1].split('//', 2)[1].split('/')[0].split(':')[0]
                if (url=="localhost"):
                   endpointurl="endpoint1.url"
                else:
                   endpointurl="endpoint0.url"
    with open(spec, "r") as spec_fh:
        for line in spec_fh.read().splitlines():
            if endpointurl in line:
                url = line.split('=', 1)[1].split('//', 2)[1].split('/')[0].split(':')[0]
                print("FQDN used to retrieve current certificate:"+url)
                if (url=="localhost"):
                    print("First and second end points found to be using localhost as fqdn - manually  new cert and update .NewCert file before fix")
                    break
                port = 443
                endpoint = "{0}:{1}".format(url, port)
                if (endpoint in certcache):
                    logger.debug("Using cached certificate for %s", endpoint)
                    newcert = certcache[endpoint]
                else:
                    logger.debug("Retreiving certificate for %s", endpoint)
                    conn = None
                    newcert = None
                    try:
                        conn = socket.create_connection((url, port), timeout=5)
                        sock = ssl.wrap_socket(conn)
                        current_cert = sock.getpeercert(True)
                        newcert = (ssl.DER_cert_to_PEM_cert(current_cert))
                        certcache[endpoint] = newcert
                    except Exception:
                        logger.error("**Failed to get in use certificate from node %s:%s**", url,port)
                        ConnectFailure_ct = ConnectFailure_ct + 1
                        if url not in ConnectFailure_nodes: ConnectFailure_nodes.append(url)
                    finally:
                        if conn is not None:
                            conn.shutdown(socket.SHUT_RDWR)
                            conn.close()                
                break
    return newcert

def read_pem_cert(cert):
    pat = "-----BEGIN CERTIFICATE-----([a-zA-Z0-9/+=\r\n]+)-----END CERTIFICATE-----"
    m = re.match(pat, cert)
    if not m:
        raise Exception("Failed to parse cert")
    return m.group(1).replace("\n", "").replace("\r", "")
    
def _setupLogging():
    try:
        os.makedirs(logdir)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise
    loghandle = logging.getLogger('ls_ssltrus_fixer')
    fileformatter = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
    consoleformatter = logging.Formatter('%(message)s')
    loghandle.setLevel(logging.DEBUG)
    fh = logging.FileHandler(logdir+os.path.sep+'ls_ssltrust_fixer.log')
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(fileformatter)
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    ch.setFormatter(consoleformatter)
    loghandle.addHandler(fh)
    loghandle.addHandler(ch)
    return loghandle

def get_filename_from_id(id):
    specfile = "{0}{1}".format(logdir, id.replace(":","%"))
    certfile = "{0}.newcert".format(specfile)
    return(specfile, certfile)
    
def _doScan():
    mismatchedIDs=[]
    matchedIDs=[]
    lsUrl="https://localhost/lookupservice/sdk"
    mismatchlistinput = "{0}mismatchIDs".format(logdir)
    logger.info("Scan Phase1: Getting service IDs")
    rc, ids = lstoolcommunicate(["list","--no-check-cert","--url",lsUrl,"--id-only"])
    if (rc != 0):
        raise Exception("'lstool get' failed: %d" % rc)
    ids = ids.splitlines()
    logger.info("Found %d service IDs", len(ids) - 1)
    logger.info("Scan Phase2: Getting spec and verifying certicate/trust")
    for id in ids:
        if not id:
            continue
        if "_com" in id:
            print("skipping validation as external solution on:"+id)
            continue

        logger.info("Processing ID: %s", id)
        logger.debug("Calling get for ID: %s", id)
        rc, oldSpec = lstoolcommunicate(["get","--no-check-cert","--url",lsUrl,"--id",id,"--as-spec",])
        if (rc != 0):
            logger.error("'lstool get' failed for ID: %s", id)
            continue
        (specfile, certfile) = get_filename_from_id(id)
        logger.debug("Creating spec file %s", specfile)
        with open(specfile,"w") as specfile_fh:
            specfile_fh.write(oldSpec)
        logger.debug("Created spec file %s", specfile)
        logger.debug("Creating cert file %s", certfile)
        logger.debug("Getting certificate for ID: %s", id)
        cert=get_cur_cert(specfile)
        if(cert):
            with open(certfile, "w") as certfile_fh:
                certfile_fh.write(cert)
            logger.debug("Created cert file %s", certfile)
            newcert_parsed=read_pem_cert(cert)
            oldcert = ""
            for line in oldSpec.splitlines():
                if "ssltrust0" in line:
                    (key, oldcert) = line.split("=", 1)
                    break
            o = hashlib.sha1()
            o.update(base64.decodestring(oldcert))
            n = hashlib.sha1()
            n.update(base64.decodestring(newcert_parsed))
            othumb = o.hexdigest().lower()
            nthumb = n.hexdigest().lower()
            logger.debug("ID: %s Old thumbprint: %s new thumbprint %s", id, othumb, nthumb)
            if (othumb == nthumb):
                matchedIDs.append(id)
                logger.debug("Trust matches the current certificate. Added %s to matchedIDs", id)
            else:
                mismatchedIDs.append(id)
                logger.debug("***Trust DOES NOT match the current certificate***. Added %s to mismatchedIDs", id)
    logger.info("")
    if len(matchedIDs) !=0:
        for id in matchedIDs:
            (specfile, certfile) = get_filename_from_id(id)
            logger.debug("Matched: id: %s spec: %s cert in use: %s", id, specfile, certfile)
    if len(mismatchedIDs) !=0:
        logger.warn("***WARNING*** %d Mismatched ID(s) found", len(mismatchedIDs))
        with open(mismatchlistinput,"w") as mismatchIDstoFile:
            mismatchIDstoFile.write("\n".join(mismatchedIDs))
        logger.info("Written mismatched IDs to %s",mismatchlistinput )
        logger.info("List of registrations with cert mismatch")
        logger.info("****************************************")
        for id in mismatchedIDs:
            (specfile, certfile) = get_filename_from_id(id)
            logger.info("ID: %s\n  spec: %s\n  cert in use: %s\n", id, specfile, certfile)
        logger.warn("Please DOUBLE CHECK the detection before running 'fix'")
        logger.warn("NOTE: Partial upgrade state of 5.5 to 6.x is unsupported for this tool- 5.5 web client registration might change")
        logger.info("")
    else:
        mismatchIDstoFile = open(mismatchlistinput,"w")
        mismatchIDstoFile.close()
    if ConnectFailure_ct!=0:
        logger.info("")
        logger.info("***WARNING*** %s ID(s) skipped comparison due to connect failure, ignore if node is dead, use KB:2121701 for manual update procedure. Note: Port 443 is hardcoded", str(ConnectFailure_ct))
        logger.info("List of node(s) with connect failure")
        logger.info("************************************")
        for entry in ConnectFailure_nodes:
            logger.info(entry)

def _doFix():
    update_idct=0
    updated_endpoint = 0
    psc_Blacklist = []
    lstooloutfile = logdir + 'lstooloutput'
    lsUrl="https://localhost/lookupservice/sdk"
    mismatchlistfile = "{0}mismatchIDs".format(logdir)
    logger.info("Fix phase 1: Reading IDs with incorrect certificate from scan results")
    logger.info("Using mismatch ID list from: %s", mismatchlistfile)
    try:
        mismatchlist_fh=open(mismatchlistfile,"r")
        mismatchlist=mismatchlist_fh.read().splitlines()
        mismatchlist_fh.close()
    except:
        logger.error("Mismatch ID list file does not exist, Please run tool with 'scan' function")
        return
    if not mismatchlist:
        logger.info("Mismatch ID list file is empty, no registrations to fix")
        return
    user=raw_input("SSO administrator user (Default:Administrator@vsphere.local):") or "Administrator@vsphere.local"
    passwd=getpass.getpass("Password for "+ user + ":")
    logger.info("Fix phase 2: Collecting site topology information")
    rc, lsoutput = lstoolcommunicate(["list","--no-check-cert","--url",lsUrl])
    if (rc != 0):
        raise Exception("'lstool get' failed: %d" % rc)
    with open(lstooloutfile, "w") as lstool_fh:
        lstool_fh.write(lsoutput)
    psctosite,idtosite = read_topology(lsoutput)
    logger.info("Fix Phase 3: creating new spec file with new ssltrust values and register")
    for id in mismatchlist:
        logger.info("\nFixing ID: %s",id)
        (specfile, certfile) = get_filename_from_id(id)
        newspecfile = specfile + ".newspec"
        newcert_parsed = cert = None
        #cert=get_cur_cert(specfile) #Use this for production
        with open(certfile, "r") as certfile_fh:    #Debug only
            cert = certfile_fh.read()
        newcert_parsed=read_pem_cert(cert)
        if(cert):
            updated=_modify_ep_certs(specfile, newspecfile, newcert_parsed)
            logger.info("Updated %d End points with new cert for ID: %s", updated, id)
        if updated != 0:
            site = right_psc(id, psctosite, idtosite, psc_Blacklist)
            rc = -1
            while (site):
                lsUrl="https://"+site+"/lookupservice/sdk"
                logger.info("Re-registering ID: %s using lsURL: %s", id, lsUrl)
                try:
                    rc, _ = lstoolcommunicate(["reregister", "--no-check-cert",
                                    "--url", lsUrl,
                                    "--id", id,
                                    "--spec",  newspecfile,
                                    "--user",  user,
                                    "--password", passwd,
                                    ])
                    if rc==0:
                        update_idct = update_idct + 1
                        site = None
                except:
                    pass
                if (rc != 0): 
                    psc_Blacklist.append(site)
                    logger.info("Blacklisted PSC at %s as connecting failed", site)
                    site = right_psc(id, psctosite, idtosite, psc_Blacklist)
            if (rc != 0):
                logger.error("'lstool reregister' failed for ID: %s with error %d", id, rc)
            else:
                updated_endpoint = updated_endpoint + updated
                logger.info("Fixing ID: %s completed\n",id)
    logger.info("*** %d endpoints for %d service IDs updated with current cetificates and trust ***", updated_endpoint, update_idct)

def main():
    global ConnectFailure_ct
    global ConnectFailure_nodes
    opts = parseopts(sys.argv[1:])
    if opts.function=="scan":
        logger.info("Running function 'scan'")
        _doScan()
        logger.info("Completed running function 'scan'")
    elif opts.function=="fix":
        logger.info("Running function 'fix'")
        _doFix()
        logger.info("Completed running function 'fix'")
    else:
        logger.error("Unknown Function '%s'. Choose scan/fix", opts.function)
        sys.exit()

if __name__ == '__main__':
    logger = _setupLogging()
    main()