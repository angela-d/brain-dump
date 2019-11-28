# Install Debian GNU/Linux to a Surface  Tablet
This is for a later model Surface, not the early release that requires jailbreaking.

The 'nonfree' drivers will be necessary for functionality like wifi, so it would be wise to use the "unofficial" iso: https://cdimage.debian.org/images/unofficial/non-free/images-including-firmware/

- Make a bootable USB with an ISO burning application (I use Etcher 1.4.4 or below; the later versions have ads)

## Dual Boot Debian and Windows
Free up some space by using Windows' built-in partition tool.
- In Windows, search "partition" - the Disk Manager application should show
- Right-click a volume (the main disk/largest volume) in either pane and select the "Shrink Volume" option
- Enter how many MB you’ll need. For a *non-gui* Debian install, you can probably do 10-12 GB if you don't intend to keep a lot of files.

## Disable Secure Boot
In Windows:
- Settings > Change PC Settings > General > Advanced Startup

After reboot:
- Troubleshoot > Advanced Options > UEFI Firmware Settings
- Select *Secure Boot Control* [Enabled] > change to **[Disabled]** > Exit Setup

## Caveats
Assuming your Surface has 1 USB port, if you're also running this install off of a USB, you're going to have to install a lot of dependencies post-install.  If you have a dual-USB adapter (so you can run 2 USBs at once), you can skip a lot of post-install steps.

## Boot the ISO and Begin Installation
- If the USB doesn't auto-boot, go into the BIOS and re-order the boot order, with USB loading first
Proceed with an install. Caveat if using the GUI installer (not the same as installing a desktop environment/GUI – just a visually easier' way to install), the mouse doesn't work out of the box (use tab key to move around)

If you've installed via USB + kept the ethernet adapter plugged in, your setup should work as-expected, out of the box (except for wifi)

## After Installation
The new install should have installed Grub and will boot straight into Debian.
- Login as your user

Check for network interfaces:
```bash
ip a
```

If you only see:
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
>
> link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>
> inet 127.0.0.1/8 scope host lo
>
> valid_lft forever preferred_lft forever

**lo** is the loopback/localhost interface. If its the sole interface, grab a Microsoft ethernet adapter and stick it in the USB port (the Mac USB adapters did not work). Re-running the command should then show the presence of eth0 (but renamed, to something like: enxf01dbcf51610) – general rule of thumb: ‘e' = ethernet, 'w’ = wifi

**If you see the wifi interface, skip all of the below!**

Now that the ethernet is present:
- Configure the ethernet networking
```bash
pico /etc/network/interfaces
```

Add the following:
```bash
auto enxf01dbcf51610
allow-hotplug enxf01dbcf51610
iface enxf01dbcf51610 inet static
address 172.16.1.21
netmask 255.255.255.0
gateway 172.16.5.1
```
*If you want to have dhcp rather than static, on line 3 change static to dhcp and omit lines 4-6.*

Test it:
```bash
ping 1.1.1.1
```

> user@debian# ping 1.1.1.1
>
> PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
>
> 64 bytes from 1.1.1.1: icmp_seq=1 ttl=56 time=9.47 ms
>
> 64 bytes from 1.1.1.1: icmp_seq=2 ttl=56 time=9.89 ms

.. network connectivity is active; but no DNS (try pinging a ‘friendly’ name)

Add DNS capability:
```bash
pico /etc/resolv.conf
```

Append the following:
```bash
nameserver [your dns ip here]
nameserver [your failover dns ip here]
search [your dns domain]
```

Test it:
> ping [your dns domain]
>
> PING [your dns domain] (x.x.x.x) 56(84) bytes of data.

Total network capabilities are now active (except wifi).
... if you had a dual adapter, you could have installed them during setup!

To fix that, we needed the network connectivity so we can use apt. But first, we need to figure out *what* drivers were needed:
- Check the kernel logs
- `su -` and switch to root user (assuming the sudo package isn’t installed, of course. Either/or will work)

```bash
dmesg | grep wifi
```

You'll see logs referencing missing firmware, the important component is the piece referencing the firmware binary the kernel is looking for:
mrvl/xxx_uapsta.bin (Changed as I don't know if all models use the same firmware, so do your own legwork on this part)

With that info, plop it into a search engine: xxx uapsta debian and you'll encounter this page: https://packages.debian.org/buster/firmware-libertas - CNTRL +F the page for the above filename and when found, you’ll know this is the missing
package you need.

## Adding the Proper APT Repo
For whatever reason, the initial install only had the security repos in /etc/apt/sources.list which would prevent us from ever downloading the drivers (the nonfree repos aren't there).

Simple fix:
```bash
pico /etc/apt/sources.list
```

Append the following:
```bash
deb http://ftp.us.debian.org/debian/ buster main non-free contrib
deb-src http://ftp.us.debian.org/debian/ buster main non-free contrib
```

**Check your Debian version!** If you are *not* running buster (10.x), then you need to adjust the codename from buster to whatever OS version you have (stretch is 9.x, for example).

*Do not ever mix OS repos unless you want a broken system!*

Don't add Ubuntu repos, either. Ubuntu and Debian are not the same, despite Ubuntu being based on Debian.

After the apt list is saved, update the apt cache:
```bash
apt update
```
You’ll see the repo’s now being pulled in.
- Install the missing wifi firmware

The *firmware-libertas* package located earlier is now ready to be installed via apt:
```bash
apt install firmware-libertas
```

The firmware is loaded at boot time, so do a simple `reboot` of the OS.

When it loads back up:
```bash
ip a
```
> 3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000

Wifi interface is now active!
