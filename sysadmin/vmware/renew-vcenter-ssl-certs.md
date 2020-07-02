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

3. Check the validity of the certs (run one at a time, so the output is legible):
```bash
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store MACHINE_SSL_CERT --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store machine --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vpxd-extension --text | less
/usr/lib/vmware-vmafd/bin/vecs-cli entry list --store vsphere-webclient --text | less
```

Note that ESXI uses different self-signed certs, independent of vCenter and thus likely have different expiry dates.  Ensure the hosts are being monitored via SNMP so your monitoring tool can alert you to their expiry.
