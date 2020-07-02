# Enabling SNMP Monitoring on vCenter VCSA
Enable network monitoring on the vCenter server appliance for monitors like PRTG.

First, enable SSH in the vCenter Appliance Manager (this is not the normal vCenter dashboard); typically `https://vcenter.example.com:5480` - login using `root` and not your Active Directory user.
- Access > SSH Login and Bash Shell both need to be **Enabled**

Then, open a terminal and login using **root**:
```bash
ssh root@vcenter.example.com
```
***

*Stay inside the `> Command` prompt*

***

Check the current SNMP status:
```bash
snmp.get
```

You'll see:
```text
Enable: False
Users:
Notraps: ''
Privacy: none
Loglevel: warning
V3targets:
Pid: n/a
Syslocation: ''
Targets:
Communities: ''
Remoteusers:
Authentication: none
Processlist: False
Engineid: ''
Port: 161
Syscontact: ''
```

## Setup
Set your community string (I used `public` for mine):
```bash
snmp.set --communities public
```

Enter your monitoring host (who will probe for the SNMP stuff), followed by the SNMP port they'll listen on (mine is 161; the default SNMP port) and SNMP string they're allowed to probe - my host is `172.16.0.2`:
```bash
snmp.set --targets 172.16.0.2@161/public
```
You can optionally separate multiple hosts by a comma: `snmp.set --targets 172.16.0.2@161/public,10.0.0.1@161/public`

Set your desired log level (lowercase); options: <DEBUG|INFO|WARNING|ERROR>:
```bash
snmp.set --loglevel warning
```

Check your setup:
```bash
snmp.get
```

If all looks well, enable it:
```bash
snmp.enable
```
