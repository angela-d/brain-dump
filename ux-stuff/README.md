# Linux UX Stuff
Notes unrelated to networking & system administration, but will not be remembered the next time I need them, without writing them down!

## Backlit Keyboard
When I got a backlit gaming keyboard, the 'Scroll Lock' toggle didn't work (out of the box) in Debian 9 / Gnome 3.22.3.

### Enable it, without needing any drivers / firmware

As root/sudo, create the .desktop file for autostart:
```bash
pico /etc/xdg/autostart/keyboard-backlight.desktop
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

Automatically switches on scroll lock as soon as the system is logged on.
