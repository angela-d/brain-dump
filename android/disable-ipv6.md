# Disable IPv6 on Android / LineageOS
Easily doable via AFWall settings and for mobile data by selecting IPv4 only, but it doesn't prevent the phone from obtaining an IPv6 address when connected to wifi offering IPv6.

From [CanMan1's](https://forum.xda-developers.com/general/networking/guide-disable-ipv6-android-t3298659) brief tutorial:

Required:
- rooted device
- 2 paths must exist:

1. `ls -l /proc/sys/net/ipv6/conf/wlan0/accept_ra`
2. `ls -l /proc/sys/net/ipv6/conf/all/disable_ipv6`

Launch ADB as root after connecting the device to a PC via USB:
```bash
adb root
```

Now launch the shell to log into the phone:
```bash
adb shell
```

**DO NOT** run the following command unless you are logged into your device, you'll see a prompt like so, if you are:
> deviceName:/

Remount the filesystem as read-write (otherwise you'll get readonly errors):
```bash
mount -o remount,rw /system
```

Create the disable script:
```bash
cd /etc/init.d && nano 00disable_ipv6
```

Paste the script from CanMan1:
```bash
#!/system/bin/sh
# Disable IPv6
echo 0 > /proc/sys/net/ipv6/conf/wlan0/accept_ra
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
```
CNTRL + W to save > Y to accept

Create the re-enable script, if you decide to enable IPv6:
```bash
nano 00disable_ipv6_reset
```

Paste the script from CanMan1:
```bash
#!/system/bin/sh
# Enable. IPv6
echo 1 > /proc/sys/net/ipv6/conf/wlan0/accept_ra
echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
```

Make them executable:
```bash
chmod +x 00disable_ipv6 && chmod +x 00disable_ipv6_reset
```

Run to make it active:
```bash
./00disable_ipv6
```

Done.

This patch will not survive reboots or ROM flashes.  Repeat steps above to re-enable.

To confirm its operative, navigate to network settings where you previously obtained an IPv6 address.
