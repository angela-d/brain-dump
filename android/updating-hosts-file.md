# Updating the Hosts File on Android

:warning: [Magisk has a warning](https://topjohnwu.github.io/Magisk/ota.html) for A/B slot devices not to modify `/system` with regards to OTA; if you don't want to re-flash Magisk after every update, check out these alternatives for hosts files:
- Built-in toggle for systemless hosts in Magisk app
- [DNS66](https://f-droid.org/en/packages/org.jak_linux.dns66/)



## Using a rooted Android device with non-A/B slots

Pre-requisites:
- Rooted phone
- ADB
- Updated hosts file

1. Plug a USB in and mount the phone to a computer running ADB.

2. In a terminal, run:
```bash
adb root
```
to access the device with root permissions.

3. Copy the local hosts file from your desktop (for example) onto the device:
```bash
adb push /home/angela/Desktop/hosts /system/etc/hosts
```
> [100%] /system/etc/hosts


Check your `/system/etc/` or `/etc` directory and you should see the hosts file modified time with today's date.


### Troubleshooting
> Unable to mount read-only filesystem.

Simply run:
```bash
adb remount
adb root
```
Usually fixes the read-write issue.
