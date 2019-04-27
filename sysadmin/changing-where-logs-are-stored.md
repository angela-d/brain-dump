# Changing Where Logs are Stored

I have an SSD that houses my Debian desktop environment.  I don't want things like logs chewing through it's life, so I moved the logs to a mounted drive.

**The following assumes you already have the harddrive you want to utilize mounted via `/etc/fstab` as the `/storage` directory.**

Switch to super user
```bash
su -
```

Stop the rsyslog daemon, so no logs are written (and subsequently interrupt the switch)
```bash
service rsyslog stop
```

Make a new directory for the logs, on the mounted `/storage` drive
```bash
mkdir -p /storage/log
```

Move the original log directory into its new home on the 2nd harddrive
```bash
mv /var/log /storage/log
```

Symlink it, so you don't have to edit a bunch of system config that expects /var/log to exist
```bash
ln -s /storage/log /var/log
```

That's it.

***

### I also moved ~/Downloads from the SSD to the 2nd hard drive
```bash
mkdir /storage/Downloads
```

Symlink Downloads, too
```bash
ln -s /storage/Downloads /home/angela/Downloads
```

Easy.
