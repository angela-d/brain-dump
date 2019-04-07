# Copying Android Apps (APKs) from One Phone to Another
Pre-requisites:
- Android Debug Bridge / ADB ()`apt install adb` on Debian)
- Developer mode on both phones (Tap the build info/about in settings 4 times)
- Rooted phone (Flash [su](https://download.lineageos.org/extras) in recovery mode)
- ADB must have root permissions (Set in Settings)
- Debug over ADB must be enabled (Developer Settings) - you will get a prompt to approve the connection on first run

There are ways to do this without root, but I've never done it as I always root my phones.

In my example I copy the Waterfox apk.

### Hook up the source phone to your computer via USB.

Start the adb daemon:
```bash
adb devices
```

**Fire up a CLI / terminal and run:**

List all installed apk's:
```bash
adb shell pm list packages | sort
```

Once you see the one you want, get the path (**omit** package:):
```bash
adb shell pm path org.waterfoxproject.waterfox
```

Pull it into your pc (it will load to whatever folder you're currently in, so if on Linux and you want it on your desktop: `cd ~/Desktop` first:
```bash
adb pull /data/app/org.waterfoxproject.waterfox-1/base.apk
```

You should now see **base.apk** on your desktop.

- Drag base.apk into the new phone, using the PC's file manager over USB.
- On the new phone > File Manager > go to the folder you dropped base.apk in > click to install.

***

## Copying browser data / settings

Plug in the source phone via USB.

You could use these commands to snag any kind of app data, my example is using Waterfox's preferences.  App data is stored in **/data/data/**

Get root privileges over ADB:
```bash
adb root && adb shell
```

Navigate to the app listing and figure out the path for the desired data:
```bash
cd /data/data && ls -l
```

If you want to see the contents you're about to grab, go into the directory:
```bash
cd cd org.waterfoxproject.waterfox/ && ls -l
```

Print the full path of the directory and copy it to notepad:
```bash
pwd
```

> /data/data/org.waterfoxproject.waterfox

Exit the terminal session with this phone:
```bash
exit
```

Now you should be back in your PC's terminal, so cd into the directory you want to send the files to; I made a **wf-phone** directory on my desktop and cd'd into it.

Grab the data:
```bash
adb pull /data/data/org.waterfoxproject.waterfox
```

It returned an error about a lock file, which I ignored because I don't care about it.
> adb: error: failed to copy '/data/data/org.waterfoxproject.waterfox/files/mozilla/m9gy7yqx.default/lock' to './org.waterfoxproject.waterfox/files/mozilla/z3eg2uua.default/lock': open failed: No such file or directory

Files are now in **wf-phone**

Plugin the new phone you want to send this data to, over USB.

Start the adb daemon:
```bash
adb devices
```

```bash
adb push /home/angela/Desktop/wf-phone/org.waterfoxproject.waterfox/ /data/data/
```

Bookmarks are now in place.

The extensions database didn't make it in unscathed, so I had to reinstall those.
