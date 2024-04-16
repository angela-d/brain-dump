# SNMP Monitoring on Debian/Debian downstream Linux distros

Updated for Debian 12 / bookworm

First, check if you have **non-free** added to your apt sources list.
```bash
grep "non-free" /etc/apt/sources.list
```

If no results, simply append **non-free** to your `/etc/apt/sources.list` repo list, like so:
- Before:
```bash
deb http://ftp.us.debian.org/debian/ bookworm main contrib
deb-src http://ftp.us.debian.org/debian/ bookworm main contrib
deb http://deb.debian.org/debian/ bookworm-updates main contrib
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib
```

- After:
```bash
deb http://ftp.us.debian.org/debian/ bookworm main contrib non-free
deb-src http://ftp.us.debian.org/debian/ bookworm main contrib non-free
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bookworm-updates main contrib non-free
```

Install SNMP
```bash
apt update && apt install snmpd snmp libsnmp-dev
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
agentAddress udp:127.0.0.1:161,udp:[public/dmz ip]:161
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
From the monitoring server, trigger a probe and watch the local logs for activity (assuming you have rsyslog setup; if not, check journald for your logs)
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
