# Custom Cursor (Without Restart) on Gnome-based Linux Desktops

There's a lot of custom cursors for Linux-based distros on sites like [Opendesktop / "pling"](https://www.pling.com/browse/cat/107/order/latest/) or [Deviantart](https://www.deviantart.com/search/collections?page=3&q=linux%20cursor).

The following instructions are for distros using Gnome desktop.

1. First, make sure you've extracted the theme and inside the theme-name folder, a **cursor.theme** file exists, in the following format:
```text
[Icon Theme]
Name=nameoftheme
```

2. Then, put the theme somewhere, I added `themename` to `~/.local/share/icons`

3. As sudo or root, run the following (adjust path/filename of **themename** to suit):
```bash
update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /home/angela/.local/share/icons/themename/cursor.theme 10
```

4. Run update-alternatives again, to show a list of available cursor themes:
```bash
update-alternatives --config x-cursor-theme
```

5. You'll be shown a list of themes you can pick from, type the corresponding number of the theme you want to use:

> There are 2 choices for the alternative x-cursor-theme (providing /usr/share/icons/default/index.theme).

```
  Selection    Path                                                     Priority   Status
------------------------------------------------------------
  0            /usr/share/icons/Adwaita/cursor.theme                     90        auto mode
* 1            /home/angela/.local/share/icons/themename/cursor.theme   10        manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

6. To set it without requiring a logout, hit `ALT + F2` and in the prompt, type `r` to restart Gnome shell (if using a laptop keyboard, try CNTRL + ALT + F2)
