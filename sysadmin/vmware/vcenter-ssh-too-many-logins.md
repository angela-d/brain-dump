# vCenter SSH - Too Many Login Attempts Troubleshooting
> ssh root@vcenter
>
> VMware vCenter Server Appliance 6.5.0.31100
>
> Type: vCenter Server with an embedded Platform Services Controller
>
> Received disconnect from vcenter port 22:2: Too many authentication failures
> Authentication failed.

I had this occur despite ensuring NTP was synced and even restarted vCenter incase I hit some sort of limit - even after vCenter came back up (and SSH was enabled) this error still plagued me.

## Enabling SSH in vCenter
Enable SSH in the vCenter Appliance Manager (this is not the normal vCenter dashboard); typically `https://vcenter.example.com:5480` - login using `root` and not your Active Directory user.
 - Access > SSH Login and Bash Shell both need to be **Enabled**

## Actual Problem
Working from home, using a VPN to access the network.

- My VPN is 10.x.x.x
- vCenter is on 172.x.x.x

***
Interestingly, this only occurs on vCenter; ESXI hosts can be accessed directly.
***

## Solution
Login using a *remote server* on the same subnet (not my home machine).

This is not something controlled at the firewall level, but within vCenter (else you wouldn't see that terminal banner before you get kicked.)

```bash
ssh root@vcenter
```

When you're done using the bash shell and SSH, be sure to turn them off.
