# Disabling NTLM Authentication on Domain Controllers
Reject authentications to domain controllers sent over NTLM.

## What was Affected (in my environment)
- Synology shared drives
- RDP via Linux clients (not joined to the domain)

## GPO to Disable NTLM
- Domain Controllers / Computer Configuration / Windows Settings / Security Settings  / Local Policies / Security Options / Network security:  Restrict NTLM: Incoming NTLM traffic = `Deny All Accounts`

### Fix for Shared Drives
GPO to allow NTLM connections, but only for the specified clients:
- Domain Controllers / Computer Configuration / Windows Settings / Security Settings  / Local Policies / Security Options / Network security: Restrict NTLM: Add server exceptions in this domain =
```text
shareddrives
shareddrives.example.com
```

  - Does this reopen the PetitPotnam or other replay attack vulnerabilities?
    - No.  [SMB signing](https://kb.synology.com/en-global/DSM/tutorial/enable_smb_signing) is enabled (this should prevent NTLM relay attacks, based on my understanding of the exploits)
      - In the Synology GUI:
        - Control Panel > Domain/LDAP > Domain Options > Enable server signing: `force`
    - Worth noting, [there's a performance degradation](https://docs.microsoft.com/en-us/archive/blogs/josebda/the-basics-of-smb-signing-covering-both-smb1-and-smb2) tradeoff, though
      - SMB1 should be disabled; SMB2 & SMB3 should be enabled on Synology servers


> Digitally signing the packets enables the recipient of the packets to  confirm their point of origination and their authenticity. This security  mechanism in the SMB protocol helps avoid issues like tampering of  packets and “man in the middle” attacks. [source](https://docs.microsoft.com/en-us/archive/blogs/josebda/the-basics-of-smb-signing-covering-both-smb1-and-smb2)


## Fix for RDP from Linux clients
Use Kerberos ticket pre-auth.

- [Setting up Kerberos auth on Debian desktops](https://github.com/angela-d/brain-dump/blob/master/sysadmin/ansible/windows-hosts-setup.md#kerberos-setup-on-the-debianlocal-machine)

### Generate a Kerberos Ticket on Debian
Case-sensitive
```bash
kinit mydomainuser@EXAMPLE.COM
```

### Using RDP
After getting the Kerberos ticket, I still had to make some changes in [Remmina](https://remmina.org/) (my choice of RDP client on Linux):

**What changed between NTLM auth and Kerberos auth?**

 - Under Basic:
  - **Domain** must be specified
  - FQDN under **server** must be used; using IP addresses fails


  - Under Advanced:
    - **Security protocol negotiation** must be set to TLS protocol security

### Auto-renewing Kerberos tickets
Optional: [kstart](https://packages.debian.org/sid/kstart)
