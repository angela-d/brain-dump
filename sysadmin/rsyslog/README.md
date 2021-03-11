# Custom rsyslog rules

Syslog tends to fill up with useless junk on desktop versions of Linux distros.

To combat this, custom configuration in `/etc/rsyslog.d/` can redirect or discard stuff you don't care about.

Keeping the logs clear of useless junk makes it easier to spot potential problems before they mushroom into bigger issues.  Syslog customization works identically on server editions of Linux distros, though the location and naming of rsyslog may vary from distro to distro.

`/etc/rsyslog.conf` is the parent configuration for the rsyslog daemon; to adjust the severity of logs it pays attention to globally, remove info or warn (which currently go to `/var/log/messages` in Debian systems):

From:
```aconf
*.=info;*.=notice;*.=warn;\
        auth,authpriv.none;\
        cron,daemon.none;\
        mail,news.none          -/var/log/messages
```

To:
```aconf
#*.=info;*.=notice;*.=warn;\
#       auth,authpriv.none;\
#       cron,daemon.none;\
#       mail,news.none          -/var/log/messages
```

This will disable logging of info, notice or warn-level messages to `/var/log/messages`

Restart the daemon for changes to take effect:
```bash
service rsyslog restart
```

## Custom rules

You can add custom .conf files to `/etc/rsyslog.d` that will be automatically picked up on the next launch of rsyslog.

I've added some of my custom rules in the identical file structure, for reference.

Each conf you modify or add, requires a restart of rsyslog.

### Determine Blockage Filters
You need to know the application name, as rsyslog sees it.
- View `/var/log/syslog` and look for the app name to the left of [pid]: like so: `firefox-esr[17145]:` -- `firefox-esr` is the application name.

- gtk warnings tend to trigger with the binary app name, not .desktop shortcut (but also depends on how you're launching the application on the desktop); so you may need to do both (see firefox-esr.conf for an example)

### Delete Logs and Gzips by Age with logrotate
I had a ton of logs (and compressed backups) from years ago left in /var/log; because they didn't meet a threshold for rotation, so they just stick around.

To clean up this kind of stuff, I added the following to [/etc/logrotate.d/rsyslog](etc/logrotate.d/rsyslog):
```bash
find /var/log/ -mtime +14 -delete
```
which runs anytime `/etc/logrotate.d/rsyslog` is run and will delete anything older than 14 days, irregardless of log type.

If you want to *test* this implementation before running it, remove `-delete` and run it with `-print` to see what will go (although it will list folders, this command leaves directories behind, but will go into them and clear nested matches).

Run via commandline:
```bash
find /var/log/ -mtime +14 -print
```

You can force a log rotation (even if a threshold is unmet), like so:
```bash
logrotate -f /etc/logrotate.d/rsyslog
```
