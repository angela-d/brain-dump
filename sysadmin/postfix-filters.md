# Postfix Filters
When using Postfix as a relayer, sometimes applications don't have the capability to filter out useless messages from their notifications.  If there are *some* notifications you want, you can regex and discard the useless ones.

1. First, create `/etc/postfix/body_checks` as a root/sudo user

2. Edit `/etc/postfix/body_checks` and append the phrase and preferred action as follows (inbetween the / should be the phrase to match - then the action to take if matched):
```bash
/angela test111/ WARN
/Received ESP packet with unknown SPI/ DISCARD
/anomaly: icmp_sweep/ DISCARD
```
Until you know the rules behave as expected, you can use the WARN action, which should write a message to your mail log - but takes no further action on the message.

3. Now, modify `/etc/postfix/main.cf` and append the following:
```bash
body_checks = regexp:/etc/postfix/body_checks
```

4. Restart postfix:
```bash
service postfix restart
```

5. Test your policy:
```bash
postmap -q 'this is a test. angela test111' regexp:/etc/postfix/body_checks
```
If you see the following, it's working as expected:
> WARN
