# Plank Window Grouping
I like to have separate Firefox profiles depending on what I will be using the browser for.

To achieve this, I create custom .desktop launchers and easily add them to Plank dock after they've been created.  This also allows for overrides or customization of icons.

Before grouping (2 Firefox; different icons):

  ![Before grouping](img/plank-before.png)

  After grouping (1 firefox; custom icon lit, standard icon no longer used):

  ![Before grouping](img/plank-after.png)


## Create the .desktop File
Create **~/.local/share/applications/** if it doesn't exit:
```bash
mkdir -p ~/.local/share/applications/
```

If you don't have it already, create a new profile in Firefox (via the address bar):
```
about:config
```
The name under **Profile:** is what you'll need.

Create the .desktop launcher:
```bash
touch ~/.local/share/applications/profilename.desktop && pico ~/.local/share/applications/profilename.desktop
```

## Place the following in profilename.desktop
- Adjust the `-P` flag to be whatever you created in `about:profiles`
- Modify `--class` to the same
- Also modify `StartupWMClass` to the same
```bash
[Desktop Entry]
Version=1.1
Type=Application
Name=Custom Profile Name Here
GenericName=Firefox Custom Profile
Comment=Browse the World Wide Web
Icon=firefox
Exec=/usr/bin/firefox %u -P profilename --class firefox-profilename
Actions=
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
Categories=Network;WebBrowser;
StartupNotify=true
StartupWMClass=firefox-profilename
```
  - `-P` tells Firefox what profile to launch
  - `--class` overrides the builtin `xprop WM_CLASS` value (run `prop WM_CLASS` via terminal and click on a window to see its current value; this is what docks use for window grouping)
  - To customize the icon, place the *icon filename* (without the extension) in the `Icon=` field
  - Other [desktop launchers](../dock-shortcuts)

The .desktop launcher setup can be done for virtually any application, including file manager shortcuts to specific folders (Nemo, Nautilus, Dolphin, etc)

## Add it to Plank
After you hit save, the new launcher should appear in your applications:
- Open it
- Once it appears in Plank, right-click > Keep in Dock
