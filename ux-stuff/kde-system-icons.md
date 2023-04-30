# Replacing Monochrome Icons in the KDE Plasma System Tray
Although more flexibile than Gnome with regards to customization, I found Plasma as equally as frustrating with regards to tray icons.

This seems to be with regards to how the Plasma theme is allowed to bundle its own icons.

***
**Scenario:**

- Plasma theme: [Dracula](https://store.kde.org/p/1378924)
- Icon theme: [Cyberpunk Technotronic](https://www.pling.com/p/1999292)

Although Cyberpunk Technotronic has a similar directory structure to the default Breeze theme, I found the symbolic / monochrome icons continuously overridden.

***

**Cause:**
Presence of **network.svgz** in `~/.local/share/plasma/desktoptheme/Dracula/icons`

**Fix:**
- Remove **network.svgz** (and any other monochrome icons you'd like to be ignored and use your icon theme, instead)

***

## Helpful Tools
[Plasma Theme Explorer](https://notmart.org/blog/2015/04/plasma-theme-explorer/) is a cheat sheet to show what overriding icon themes your Plasma theme choice is offering, along with quick jumps to it's location on your hard drive.  Also a very simplistic GUI app to allow further customization to your Plasma theme (changing colors, etc.)

1. Open KDE Discover
2. Search for: `plasma theme explorer`
3. Install


### Worth Noting
Each time you switch to a new Plasma theme, you'll have to pull out any of the themes icons you don't want overriding your icon theme.