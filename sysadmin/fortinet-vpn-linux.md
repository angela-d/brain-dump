# Fortinet SSL VPN on Linux

Fortinet's proprietary Linux client didn't work well on Debian 9. (I started using OpenFortiGUI through Debian 9, 10 and now 11 -- it has worked quite well)

> Transition from Debian 10 to 11: Absolutely no change whatsoever (10 > 11 March 2021)

> Debian 9 to 10 (some effort was involved)

- Compile from source for a non-proprietary [CLI version](https://github.com/adrienverge/openfortivpn)
- Non-proprietary [GUI version](https://github.com/theinvisible/openfortigui) or [apt installation](https://apt.iteas.at/)

## GUI Installation
These instructions are for Debian 10.  For Ubuntu, check the [developer's blog](https://hadler.me/linux/openfortigui/).

Add the developer's signing key (old notes; confirm with [Hadler's site](https://hadler.me/linux/openfortigui/) to ensure nothing has changed.)
```bash
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2FAB19E7CCB7F415
```

Add the developer's repo to apt's sources list
```bash
echo "deb https://apt.iteas.at/iteas buster main" > /etc/apt/sources.list.d/iteas.list
```

That's it.

***
***

### Fix Previous Installation Setups, After In-Place OS Upgrade
If you've recently done an in-place upgrade from stretch to buster and the VPN won't connect:
- File > Settings > check **SUDO -E Option**

Also **Modify your desktop shortcut:**
- Super user key (windows key)
- Search 'Menu Editor' (go to the software center & install one if its not currently installed)
- Mine installed under 'Internet' > click it > Properties
- Under 'Command' > change from `sudo /usr/bin/openfortigui` to: `/usr/bin/openfortigui`


### Fix sudo environment issues
In `~/.openfortigui/logs/vpn/[connection].log` or `~/.openfortigui/logs/openfortigui.log` you may see:

> sudo: sorry, you are not allowed to preserve the environment

or

> No protocol specified


## Cause
OpenFortiGUI sets a sudoers permission, in `/etc/sudoers.d/openfortigui`

There are two optional approaches to fixing this:

1)

- Are you in **sudo** group? Check: `groups angela`
- Do you have the following line in `visudo` (Run as `su`):
```bash
#includedir /etc/sudoers.d
```
If so, uncomment it - as this indicates it's not being processed (or copy its contents to `/etc/sudoers.d/openforticustom` or `visudo` to customize; as an apt upgrade of OpenFortiGUI may override your changes):
```bash
includedir /etc/sudoers.d
```


2)

**Allow a User that's Not in the Sudo Group**

No need to add your user to sudo group, just to access 1 application.

- As root, run:
```bash
visudo
```

- Find:
```bash
root    ALL=(ALL:ALL) ALL
```

- Add *beneath* (replace angela for your username):
```bash
angela    ALL=(ALL) NOPASSWD:SETENV: /usr/bin/openfortigui
```
*If you have other NOPASSWD entries, this does not need to be concatenated to existing entries to append SETENV; you can have multiples with varying options, like so:*
```text
angela  ALL=(ALL) NOPASSWD: /usr/bin/apt
angela  ALL=(ALL) NOPASSWD:SETENV: /usr/bin/openfortigui
```

Explanation of options:
- **NOPASSWD** allows the last argument (openfortigui app) to invoke sudo controls when necessary, without prompting for your sudo password -- without this argument, if I ran OpenFortiGUI it would not connect and with no warning prompt signaling anything was wrong.. so I ran via CLI and noticed it requesting my sudo password. (If there is a flag to better fix this to avoid setting NOPASSWD to the application, I am not yet aware of it.)
- **SETENV** preserves the user environment to the last argument; without this, sudo cannot invoke display controls to run a GUI application on Wayland.

Find OpenFortiGui in your application menu and click it, it'll auto launch with zero additional steps.

### Worth noting

- If you have a chattr lock on /etc/resolv.conf, this application will not load the VPN's DNS resolvers.
```bash
chattr -i /etc/resolv.conf
```
to unlock it.  (Which also gives Network Manager the ability to fiddle with it, again.)

No internet after using OpenFortiGUI:
- Open `/etc/resolv.conf` and ensure your default DNS servers came back after exiting the OpenFortiGUI application.  If they're still there, simply remove the DNS added by your VPN (usually 172.xx.xx.xx or 10.xx.xx.xx)
- In many cases, *your* DNS is coming from your home router, so you would want your router's gateway there, instead: most commonly that's `192.168.1.1`
- As a last-ditch attempt, you can always append a public DNS resolver here, like `9.9.9.9`.  


### (Optional) CLI Logon
```bash
sudo /usr/bin/openfortigui --start-vpn --vpn-name NameOfMyConnection --main-config '/home/angela/.openfortigui/main.conf'
```

### Segfaults
I had an issue where I was getting a segfault:
```text
debian kernel: [  573.164599] traps: openfortigui[30174] general protection ip:558fd01e9ed4 sp:7fff8bd2c658 error:0
```

- Logs were empty
- Debug enabled

Turns out, I had changed my password days before and had forgotten -- OpenFortiGUI had my old password saved in the keyring.  I simply updated it via OpenFortiGUI and was able to connect.
