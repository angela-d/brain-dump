# error on subcontainer 'ia_addr' insert (-1)
Change the loglevel parameter to quell this message.

If the `-LS6d` option is not already set, in `/etc/default/snmpd` - set it:
```bash
# snmpd options (use syslog, close stdin/out/err).
SNMPDOPTS='-LS6d -Lf /dev/null -u Debian-snmp -g Debian-snmp -I -smux,mteTrigger,mteTriggerConf -p /run/snmpd.pid'
```

## Also modify the SNMPD service
Modifying `pico /lib/systemd/system/snmpd.service`:
- Change `ExecStart=/usr/sbin/snmpd -Lsd -Lf /dev/null -u Debian-snmp -g Debian-snmp -I -smux,mteTrigger,mteTriggerConf -f`
- To `ExecStart=/usr/sbin/snmpd -LS6d -Lf /dev/null -u Debian-snmp -g Debian-snmp -I -smux,mteTrigger,mteTriggerConf -f`

Reload the daemons to take effect:
```bash
systemctl daemon-reload
```

Restart snmpd, for good measure:
```bash
service snmpd restart
```

tail the logs to confirm the error is no longer being logged:
```bash
tail -f /var/log/syslog
```
