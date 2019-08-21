# Updating the Hosts File on Android
Using a rooted Android device.

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
