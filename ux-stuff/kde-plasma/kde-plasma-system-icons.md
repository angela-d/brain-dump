# Replacing Monochrome Icons in the KDE Plasma System Tray
Although more flexibile than Gnome with regards to customization, I found Plasma as equally as frustrating with regards to tray icons.

This seems to be with regards to how the Plasma theme is allowed to bundle its own icons.

While this is one (arguably faster) approach, you can also modify the [.svgz icon packs](kde-svgz-icons.md) if your theme uses them.

***
**Scenario:**

- Plasma theme: [Dracula](https://store.kde.org/p/1378924)
- Icon theme: [Cyberpunk Technotronic](https://www.pling.com/p/1999292)

Although Cyberpunk Technotronic has a similar directory structure to the default Breeze theme, I found the symbolic / monochrome icons continuously overrode the Cyberpunk Technotronic I was using.

***

**Cause:**

Presence of **network.svgz** in `~/.local/share/plasma/desktoptheme/Dracula/icons`
    - Referenced in the [KDE docs](https://develop.kde.org/docs/plasma/theme/theme-details/#use-icons-from-icon-theme)

**Fix:**

- Remove **network.svgz** (and any other monochrome icons you'd like to be ignored and use your icon theme, instead)
- Replace with a dummy text file, named `network.svgz` and with the content `<svg></svg>`
    - [This script](plasma-icon-override.sh) will automate that for you!
        - Open **plasma-icon-override.sh** and modify the `MY_THEME` variable to suit your environment
***

## Helpful Tools
[Plasma Theme Explorer](https://notmart.org/blog/2015/04/plasma-theme-explorer/) is a cheat sheet to show what overriding icon themes your Plasma theme choice is offering, along with quick jumps to it's location on your hard drive.  Also a very simplistic GUI app to allow further customization to your Plasma theme (changing colors, etc.)

1. Open KDE Discover
2. Search for: `plasma theme explorer`
3. Install


### Worth Noting
Each time you switch to a new Plasma theme, you'll have to pull out any of the themes icons you don't want overriding your icon theme.

I also found (for this particular icon theme) I also had to modify `~/.local/share/icons/cyberpunk-technotronic-icon-theme/index.theme` and set `Inherits=` to empty, otherwise some of the icons in the system config and Dolphin were using Breeze icons, instead of from the theme.