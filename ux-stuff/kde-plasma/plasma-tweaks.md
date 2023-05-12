# Plasma Tweaks 
Some weird quirks and fixes I probably won't remember unless I write them down.


## Desktop Wallpaper Loss
After every shell restart or login, my main monitor's wallpaper would disappear.

This appears to be a well-documented bug and is fixed in a later version of KDE.

I narrowed it down to the awesome [Sweet theme](https://www.opendesktop.org/p/1294174/) - [fix posted in Github issues](https://github.com/EliverLara/Sweet-kde/issues/17)

[This Reddit user](https://old.reddit.com/r/kde/comments/65pmhj/change_wallpaper_from_terminal/dgc5qzy/) had an interesting 'fix' that works as a band-aid by setting the wallpaper via terminal/script:
```bash
# https://old.reddit.com/r/kde/comments/65pmhj/change_wallpaper_from_terminal/dgc5qzy/
function wallpaperplz {
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
    var Desktops = desktops();
    for (i=0;i<Desktops.length;i++) {
            d = Desktops[i];
            d.wallpaperPlugin = "org.kde.image";
            d.currentConfigGroup = Array("Wallpaper",
                                        "org.kde.image",
                                        "General");
            d.writeConfig("Image", "file:///storage/mydrive/Pictures/mywallpaper.png");
    }'
}
# export the function so we can call it outside of the profile
export -f wallpaperplz

# call it
wallpaperplz
```
- Adjust `/storage/mydrive/Pictures/mywallpaper.png` accordingly.