# Useful VMware/vCenter Log Locations
vCenter has a ton of logs in `/var/log` on vCenter Server Server Appliance, these are the ones I find the most useful.

In order to search the logs directly, turn SSH on from VCSA:
- You must log in to `https://vcenter.example.com:5480/` as administrator@vsphere.local and not your Active Directory user.

- Access > Edit > tick both Enable BASH Shell & Enable SSH Login
- Login: `ssh root@vcenter.example.com`
- Go into the shell by typing `shell`

Now you can parse the logs.

## Authentication and Warning Logs
- /var/log/vmware/vpxd/vpxd.log
 - Find authentication logs: `grep "username" /var/log/vmware/vpxd/vpxd.log`
 - Locate errors or warnings: `grep "error" /var/log/vmware/vpxd/vpxd.log`

## vCenter Server-related Issues
- /var/log/vmware/messages
 - Find warnings or errors `grep "warning" /var/log/vmware/messages`
 - Certificate issues: `grep "cert" /var/log/vmware/messages`


Turn off shell & SSH access when finished.
