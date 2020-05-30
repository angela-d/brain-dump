# Postfix Message Body Content Filters
When using Postfix as a relayer, sometimes applications don't have the capability to filter out useless messages from their notifications.  If there are *some* notifications you want, you can regex and discard the useless ones.

1. First, create `/etc/postfix/body_checks` as a root/sudo user

2. Edit `/etc/postfix/body_checks` and append the phrase and preferred action as follows:
- /`phrase to match`/ (can regex to alphanumeric matches, also)
- `DISCARD` | `WARN` | `REJECT` = action to take if matched
- `optional log message`:
```bash
/angela test111/ WARN
/Received ESP packet with unknown SPI/ DISCARD
/anomaly: icmp_sweep/ DISCARD Useless ICMP scan notification
```
Until you know the rules behave as expected, you can use the WARN action, which should write a message to your mail log - but takes no further action on the message.

3. Now, modify `/etc/postfix/main.cf` and append the following:
```bash
body_checks = regexp:/etc/postfix/body_checks
```

4. Create a body_checks database:
```bash
postmap /etc/postfix/body_checks
```

5. Restart postfix:
```bash
service postfix restart
```

6. Test your policy:
```bash
postmap -q 'this is a test. angela test111' regexp:/etc/postfix/body_checks
```
If you see the following, it's working as expected:
> WARN

7. Do a discard test (assuming mailx is installed to your server already):
```bash
[root@server postfix]# mailx you@example.com you@example.com
Subject: regex
ghfgh anomaly: icmp_sweep rterte
< CNTRL + D >
EOT
[root@server postfix]# mailx you@example.com you@example.com
Subject: testing
this one should get delivered
< CNTRL + D >
EOT
```


If you trigger a filter, you'll see the following in the logs:
```text
May 29 12:57:23 server postfix/cleanup[21915]: 2E8541019: discard: body ghfgh anomaly: icmp_sweep rterte from local; from=<root@server> to=<you@example.com>: Useless ICMP scan notification
```
