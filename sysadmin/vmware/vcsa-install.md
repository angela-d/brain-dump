# VCSA Install Pre-Check

Homelab install pre-check for vCenter Server Appliance (no TLD for SSO)


- Obtain the evaluation ISO from [VMware](https://my.vmware.com/en/group/vmware/evalcenter?p=vsphere-6)
- In DD-WRT > Services > Services > DNSMASQ > *Additional DNSMasq Options* Box, add:
```bash
address=/vcenter.local/192.168.1.11
```
- Apply and Save

For good measure, on the PC that the image will be mounted to, for install (via root terminal):
```bash
echo "192.168.1.11 vcenter.local" >> /etc/hosts
```

That should circumvent the failure on step 2 with VMware trying to do DNS verification (identity management).

- Double-click the ISO downloaded from VMware's website
- Go to the mounted folder (in Debian, carat dropdown in the navigation panel) > VMware VCSA > vcsa-ui-installer > lin64 > right click **installer** > Run

Default username is **administrator@vcenter.local**
