# SNMP Monitoring on Debian/Debian downstream Linux distros

Install SNMP, nmap and snmp-mibs-downloader
```bash
apt update && apt install snmpd nmap snmp-mibs-downloader
```


## SNMP Configuration
Adjust the SNMP config to listen on all interfaces
```bash
pico /etc/snmp/snmpd.conf
```

Change:
```bash
agentAddress udp:127.0.0.1:161
```

To:
```bash
agentAddress udp:161
```

Whitelist the monitoring IP(s)
```bash
rocommunity public [ip of the monitoring server]
```
- If a custom community string is used in place of `public`, you must notify the monitoring server, else probes will fail.

Restart the SNMP daemon for the changes to take effect
```bash
service snmpd restart
```

## Testing
From the monitoring server, trigger a probe and watch the local logs for activity
```bash
tail -f /var/log/syslog
```

Also do a UDP port scan of 161 to ensure it's responding (IP of the prober must be whitelisted as well, else you'll get a timeout)
```bash
nmap -sU -p 161 [ip of the target server]
```

From the whitelisted machine, you can also poll the SNMP directly
```bash
snmpwalk -c public -v1 [ip of the target server] | less
```
`-c public` may differ if you specified a custom community string for `rocommunity` in `/etc/snmp/snmpd.conf`
