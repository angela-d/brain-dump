# Linux UX Stuff
Notes unrelated to networking & system administration, but will not be remembered the next time I need them, without writing them down!

## Backlit Keyboard
When I got a backlit gaming keyboard, the 'Scroll Lock' toggle didn't work (out of the box) in Debian 9.

Enable it, without needing drivers / firmware (run as your normal user, not sudo or root):
```bash
echo "xmodmap -e 'add mod3 = Scroll_Lock'" >> ~/.bashrc && . ~/.bashrc
```

This will append to the user's ~/.bashrc profile so it will auto-set on login.
