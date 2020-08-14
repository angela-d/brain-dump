# Backlit Keyboard
When I got a backlit gaming keyboard, the 'Scroll Lock' toggle didn't work (out of the box) in Debian 9 / Gnome 3.22.3.
Fixing that was simply running the `xset led 3` command, or modifying `~/.config/autostart/` or `/etc/xdg/autostart/` entries.

Since Debian 10 (Gnome 3.30.2) uses Wayland instead of X (if you keep defaults, of course), this functionality no longer works!

### What display manager are you running?
Run:
```bash
echo $XDG_SESSION_TYPE
```
For me:

> wayland


## For Systems Running Wayland
### Enable autostart LED, without needing any drivers / firmware:
Here's a workaround:
- I threw together a bash script to gather scrolllock led inputs and activate them: [keyboard-led-wayland.sh](keyboard-led-wayland.sh) -- put this in `~/.config`
- As root/sudo, open the sudo config: `visudo`
- Append the following line, under *# User privilege specification* (beneath any existing entries):
```bash
angela  ALL=(ALL) NOPASSWD: /home/angela/.config/keyboard-led-wayland.sh
```
(replace **angela** with your username in both the user and /home path) -- this allows the specified user abilities to elevate sudo permissions, (but **only** to this script path) to write the */sys/class/leds* options, without affecting any other sudo options or giving the user *too much* power, since all we want to do is simply activate this config change.)

If you're security consious and don't give your everyday user unfitted sudo permissions, you can lock down permissions even further and only give read and execute permissions (should your user be exploited, a rogue service shouldn't be able to modify *keyboard-led-wayland.sh* to gain super-user access):
```bash
chmod 550 /home/angela/.config/keyboard-led-wayland.sh
```
If you need to modify this file in the future, invoke `su -` or `su - othersudouser`

As the user you previously granted restricted sudo executions to, create the .desktop file for autostart:
```bash
pico ~/.config/autostart/keyboard-backlight.desktop
```

And populate with the following:
```bash
[Desktop Entry]
Type=Application
Name=Keyboard Backlight
Exec=sudo /home/angela/.config/keyboard-led-wayland.sh
Icon=input-keyboard
X-GNOME-Autostart-enabled=true
```
That is it!

The keyboard LED setup will now persist through reboots.


***
***
# For Systems Running X (not Debian 10 or Ubuntu 17):

### Enable it, without needing any drivers / firmware:

### System-wide
As root/sudo, create the .desktop file for autostart:
```bash
pico /etc/xdg/autostart/keyboard-backlight.desktop
```
or
### Single-user
As that user, create the .desktop file for autostart:
```bash
pico ~/.config/autostart/keyboard-backlight.desktop
```

And populate with the following:
```bash
[Desktop Entry]
Type=Application
Name=Keyboard Backlight
Exec=xset led 3
Icon=input-keyboard
X-GNOME-Autostart-enabled=true
```

Note that system-wide options can be overridden by a user with the same filename in ~/.config

***
Automatically switches on scroll lock as soon as the system is logged on.

### Windows Note
Simply hitting the Scroll Lock key / SL key lit up the keyboard and persists through reboots.
