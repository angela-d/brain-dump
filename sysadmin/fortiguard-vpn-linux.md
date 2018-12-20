# Fortiguard SSL VPN on Linux

Fortinet's proprietary Linux client doesn't work well on Debian 9.

- Compile from source for a non-proprietary [CLI version](https://github.com/adrienverge/openfortivpn)
- Non-proprietary [GUI version](https://github.com/theinvisible/openfortigui) or [apt installation](https://apt.iteas.at/)

## GUI Installation
These instructions are for Debian 9.  For Ubuntu, check the [author's blog](https://hadler.me/linux/openfortigui/).

Add the developer's signing key
```bash
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2FAB19E7CCB7F415
```

Add the developer's repo to apt's sources list
```bash
echo "deb https://apt.iteas.at/iteas stretch main" > /etc/apt/sources.list.d/iteas.list
```

### Has to be ran as root or sudo

```bash
sudo openfortigui
```

Or be lazy and set a desktop shortcut via the Menu Editor
- Super user key (windows key)
- Search 'Menu Editor' (go to the software center & install one if its not currently installed)
- Mine installed under 'Internet' > click it > Properties
- Under 'Command' > change from `/usr/bin/openfortigui` to: `sudo /usr/bin/openfortigui`

When you go to use the application, you'll be prompt for a password.

### Get rid of the password prompt

As root, run:
```bash
visudo
```

Find:
```bash
root    ALL=(ALL:ALL) ALL
```

Add *beneath* (replace angela for your username):
```bash
angela    ALL=(ALL) NOPASSWD: /usr/bin/openfortigui
```

Now Find OpenFortiGui in your application menu and click it, auto launch as sudo with zero additional steps.

### Worth noting
If you have a chattr lock on /etc/resolv.conf, this application will not load the VPN's DNS resolvers.
```bash
chattr -i /etc/resolv.conf
```
to unlock it.  (Which also gives Network Manager the ability to fiddle with it, again.)
