# DD-WRT Ad-blocking Hosts File
Pulls hosts file from [StevenBlack's](https://github.com/StevenBlack/hosts) host file and sets it as a cron on a DD-WRT router.

Under `Services > Services > DNSMasq` set *Additional DNSMasq Options* after ticking *DNSMasq* to Enable
```bash
addn-hosts=/tmp/blkhosts
```
Hit Apply Settings

Under `Administration > Management`
Add the following startup cron:
```bash
wget -qO /tmp/blkhosts http://raw.githubusercontent.com/StevenBlack/hosts/master/hosts && stopservice dnsmasq && startservice dnsmasq
```

Hit Apply Settings

Restart router for changes to take effect.

If ads still show after router restart, the router either doesn't have network activity upon startup, DNS is undetected or the cron is set incorrectly.
