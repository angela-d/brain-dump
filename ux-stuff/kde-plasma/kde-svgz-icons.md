# KDE .svgz Icons and Custom Icon Themes
After experimenting with Plasma more, my [initial approach](https://github.com/angela-d/brain-dump/blob/master/ux-stuff/kde-plasma/kde-plasma-system-icons.md) to customize my Plasma theme still didn't fully theme some of the system icons, notably the wifi and battery icons.

While the wifi icon had the color scheme, it didn't adjust to the signal strength.

There were also better looking icons in the icon pack than were being used in the system tray.

The system tray wasn't calling upon my icon theme; as the global Plasma theme is taking precedence and/or falling back to the KDE default theme.


[KDE has excellent documentation](https://techbase.kde.org/Development/Tutorials/Plasma4/ThemeDetails#%22icons%22_folder) that allowed me to figure out how to create my own network.svgz and battery.svgz icons to match my chosen theme.

**How do you edit a .svgz file to use your theme's icons, instead?**

## Tools Used
- Icon theme: I use [Cyberpunk Tektronic](https://store.kde.org/p/1999292) by [dreifacherspass](https://github.com/dreifacherspass)
   - Theme path: `/home/angela/.local/share/icons/cyberpunk-technotronic/`
- Plasma theme: I use [Dracula](https://store.kde.org/p/1370871) by [EliverLara](https://github.com/EliverLara/)

  - This theme has a few default .svgz icons in `/home/angela/.local/share/plasma/desktoptheme/Dracula/icons/`
- Inkscape
    ```bash
    apt install inkscape
    ```
- Dolphin File Manager - Some shortcuts referenced in my notes are from Dolphin's context menu

## Using the default Icon Theme
The default (fallback) icon theme is located at `/usr/share/plasma/desktoptheme/default/icons/`

## Customizing the default Icon Theme
Changing the system tray icons in your Plasma theme
1. Go to `/usr/share/plasma/desktoptheme/default/icons/`
2. Locate the icon set you want to modify; in my example I will target **battery.svgz**
3. Open **battery.svgz** in Inkskcape
   - You should see all of the battery icons laid out on one vector image
4. If you don't see the *Object Properties* pane, hit Shift + Ctrl + O to expose it - or in the top menu: Object > Object Properties (shows up in the right side, for me)
 - If you don't see the *XML editor*, hit Shift + Ctrl + x (shows up in the right side, for me)
   - Select one of the existing images
   - In the Object Properties pane, you'll see something like:
      - ID: `Fill100`
        - This is what the system widget is using to decipher whether or not to display the full battery icon or not
    - Copy the existing ID to your clipboard (highlight + Ctrl + C)
    - Delete the object (**select it, first** > right-click > delete or select it > DEL key)
5. In your icon theme, locate the full battery icon you want to use, instead
   - If it's got a little arrow icon in the corner, it's a symbolic link; don't drag those, but right-click > Show Target and grab the original that doesn't have the little arrow icon on it
   - Drag it to the Inkscape vector space; placement doesn't seem to matter
   - You should get a prompt from Inkscape's SVG Input inquiring about DPI and rendering mode - set your preferences and hit OK
 6. In the Object Properties pane, you'll see something like **path315** -- change it to:
    - `Fill100`
7. In the XML editor, the **id** field is still *path315*, so change that too, to:
   - `Fill100`
      - If you're finding you can't edit the svg id, toggle **Show Attributes** and click on the `id` attribute to add `Fill100`

      - Repeat all of the above for any other icon you want to change
      - Not every icon needs to be changed; only the ones you want to match your theme
8. File > Save As:
   - Name: `battery.svgz` or `battery`
   - Path: `/home/angela/.local/share/plasma/desktoptheme/Dracula/icons` or path to your theme
      - Hit Ctrl + H if .local is not visible
    - Type: Compressed Inkscape SVG (*.svgz)


To see your changes, reload Plasma:
```bash
kquitapp5 plasmashell || killall plasmashell && kstart5 plasmashell
```

Still not seeing changes?
   - Clear the icon cache by removing: `/home/angela/.cache/icon-cache.kcache` like so:
   ```bash
   rm ~/.cache/icon-cache.kcache
   ```

Note that unless you already themed the icon in question, you won't see it triggered until that condition is hit.

***

Pretty simple, but difficult to come across concise how-to instructions as a Plasma newbie, with all of the QML options and advanced coding tweaks available, unless you already know what you're looking for!