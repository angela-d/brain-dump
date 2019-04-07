# Sideloading

Much like sideloading during the initial install process, sideloading firmware upgrades or XDA apps can be done the same way.

**Pre-requisites:**
- Assumes TWRP Recovery is already installed and functional
- Fastboot (`apt install fastboot` on Debian)

First, connect the phone via USB

Make sure ADB is on:
```bash
adb devices
```

Now reboot, to recovery:
```bash
adb reboot bootloader
```

Once on the menu, navigate to **Recovery**

TWRP should load > Advanced > ADB Sideload

In your PC's CLI/terminal, reference the path where your .apk or *flashable* firmware zip is stored:
```bash
adb sideload /home/angela/Desktop/firmware.zip
```

Check the TWRP output to ensure it was a successful flash.  If there are errors, they're typically pretty descriptive and will tell you if a dependency is not met.

If all is good, reboot back into the system.
