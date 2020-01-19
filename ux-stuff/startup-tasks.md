# Startup Tasks
`rc.local` is for the sysadmin/root/sudo user to execute tasks or services after normal system services have started.

***

## Disable Bluetooth on Startup
Everytime Debian boots, I see Bluetooth is 'on,' on my laptop.  I sparingly use it, so I'd prefer to disable it, by default.

First, make sure you have the [rfkill](https://packages.debian.org/stretch/rfkill) package installed.

> rfkill is a simple tool for accessing the Linux rfkill device interface, which is used to enable and disable wireless networking devices, typically WLAN, Bluetooth and mobile broadband.

To check:
```bash
apt list --installed | grep rfkill
```

If you see something like:

> rfkill/oldstable,now 0.5-1+b1 amd64 [installed,automatic]

You are good to go.  If not, install it:
```bash
apt install rfkill
```
## Disable Bluetooth by Default
In `/etc/rc.local`, append the following:
```bash
rfkill block bluetooth
```

The next time the system starts, Bluetooth is **off** by default.  To turn it on, you can toggle it in Network Manager, or run:
```bash
rfkill unblock bluetooth
```

***

## Disable Wifi Power Management
I had a lot of wifi issues when I first switched to Debian as my desktop operating system full-time, one of the problems seemed to be **wifi power management** constantly switching off the wifi.

(What good does saving power do, if it turns off wifi *while it's being used*?)

To stop this nonsense, I turned off the power management *completely* for my wifi interface.

**First, determine what your wifi interface name is.**  Some distros rename it from wlan0 to something like wlp3s0 and so on - and also different in virtualized machines.

Install the **iw** tool, if you don't already have it:
```bash
apt install iw
````

Then, display your wireless interfaces and figure out the naming convention (run as root/sudo):
```bash
iwconfig
```

> wlp3s0    IEEE 802.11  ESSID:"no"

As a general rule of thumb, you're going to have **lo**, **eth0** (or *en2..*), **wlan0**, **wlp3s0**, etc:
- **w** = wifi
- **e** = ethernet
- **lo** = localhost/loopback

If your interface is showing as **wlp3s0**, append this to `/etc/rc.local`:
```bash
iwconfig wlp3s0 power off
```

Next system boot, powersave for wifi is disabled.
