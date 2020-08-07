# Renew SSL Certificates for vCenter via the GUI
There is an option to do this over command-line as well, but I used the GUI.

You must log in to vCenter as `administrator@vsphere.local` and not your Active Directory user.

1. Menu > Administration > Certificates > Certificate Manager
2. If you are prompt to login, use `administrator@vsphere.local`
3. Actions > Renew (do for all shown, except the Trusted Root Certificate)

That's it.

## Troubleshooting
If you originally did this under your AD user (as I did) you probably got a few failures and the machine cert refused to update and the webclient cert never changed in your browser, even after logging out.

To fix:
- Restart vCenter
- Follow the above steps (the webclient cert should update after the restart of vCenter)

To ensure vCenter isn't reporting a false-positive, you can confirm via CLI the validity and expiry of the certificates:
1. Enable SSH: in the vCenter Appliance Manager (this is not the normal vCenter dashboard); typically `https://vcenter.example.com:5480` - login using `root` and not your Active Directory user.
 - Access > SSH Login and Bash Shell both need to be **Enabled**

2. Then, open a terminal and login using **root**:
```bash
ssh root@vcenter.example.com
```

3a. Check the validity of the certs with only the expiry date:
```bash
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store MACHINE_SSL_CERT --text | less|  grep "Not After"
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store machine --text | less | grep "Not After"
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd --text | less | grep "Not After"
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd-extension --text | less | grep "Not After"
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vsphere-webclient --text | less | grep "Not After"
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store SMS --text | less | grep "Not After"
```

3b. Check the validity of the certs with detail (run one at a time, so the output is legible):
```bash
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store MACHINE_SSL_CERT --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store machine --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd-extension --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vsphere-webclient --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store SMS --text | less
```

Note that ESXI uses different self-signed certs, independent of vCenter and thus likely have different expiry dates.  Ensure the hosts are being monitored via SNMP so your monitoring tool can alert you to their expiry.

### Certificate Alarm in vCenter *AFTER* Properly Renewing Certificates
> Depending on vCenter version, some systems will have BACKUP_STORE, others will have BACKUP_STORE_H5C


Log location: `/var/log/vmware/vpxd/vpxd.log`

Find the culprit:
```bash
grep "will expire on" /var/log/vmware/vpxd/vpxd.log
```

Output:
```text
...
2020-08-01T12:18:47.012-05:00 warning vpxd[7F021C0GJ325] [Originator@5894 sub=Main] Certificate [Subject: C=US,CN=vcenter.example.com] from store BACKUP_STORE_H5C will expire on 2020-08-16 09:09:19.000
...
```

It's seeing the "backup" certificates as expiring.  VMware docs suggest to remove them:
- [Relevant KB article](https://kb.vmware.com/s/article/68171)

Confirm the aliases:
```bash
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store BACKUP_STORE_H5C --text | less | grep -i "Alias"
```

Run against all found aliases (as the backup store is a 'backup' - and if expiring, isn't entirely useful:
```bash
/usr/lib/vmware-vmafd/bin/vecs-cli entry delete --store BACKUP_STORE_H5C -y --alias bkp___MACHINE_CERT
```
- Replace **bkp___MACHINE_CERT** for other aliases matching your criteria. (bkpvpxd-extension, bkpvpxd and so on)

Worth noting:
- When I initially ran VMware's suggested delete command (`/usr/lib/vmware-vmafd/bin/vecs-cli entry delete --store BACKUP_STORE_H5C --alias bkp___MACHINE_CERT -y`) I received a "success" message for deletion, yet when I re-ran the informational grep command, the certificates were still present.  The ordering of arguments appears to be important.
- The Certificates alarm does not appear to clear itself, it needs to be acknowledged after deletion.
- Disable SSH & bash shell on vCenter when you're done troubleshooting
