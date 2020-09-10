# Post-Install / Upgrade Checklist
I find myself doing more frequent installs of Linux-based operating systems on various types of hardware, as of late and often forget one or two things I like to configure.  Writing them down, so I don't forget, going forward.

- Use the `-i` flag for case-insensitive searches

## Check dmesg
dmesg prints message buffers of the kernel and drivers running on the OS, so this is a good spot to check to ensure you aren't missing anything (like wifi drivers)
```bash
dmesg | grep -i wifi
```

Check for vulnerabilities that aren't mitigated by default settings
```bash
dmesg | grep -i vuln
```

Check for general errors
```bash
dmesg | grep -i error
```

Warnings are often important, too
```bash
dmesg | grep -i warn
```

## Disable IPv6
I don't care to use it at this time and it causes my VPN to leak
```bash
pico /etc/default/grub
```

Find:
```bash
GRUB_CMDLINE_LINUX_DEFAULT=""
```

Change to:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 quiet"
```
(`quiet` to turn off kernel output messages)

Update grub:
```bash
update-grub
```

## Check Syslogs for Similar things
```bash
grep -i 'error\|warn\|fatal' /var/log/syslog
```

## Disable Wifi Scanning
When network roaming isn't needed
- Go to WIFI settings
- Select your network
- Identity > BSSID > Select your router's MAC > Apply

## For Laptops
Battery saving:
```bash
apt install tlp powertop
```
Run powertop and check the **tunables** tab
```bash
sudo powertop
```
- Don't recommend enabling auto-suspend for network card, USB mice or keyboards

TLP should auto-configure for best settings.

[Remove irqbalance](http://konkor.github.io/cpufreq/faq/#irqbalance-detected)
```bash
apt remove irqbalance --purge
```

- [CPUFREQ extension](https://extensions.gnome.org/extension/1082/cpufreq/) if using Gnome

## Disk Space Control
Use `localepurge` to rid manuals for languages/locales you don't use on your system

> This tool is a hack which is *not* integrated with the system's package management system and therefore is not for the faint of heart. Its interference can provoke strange, but usually harmless, behavior in programs related to apt/dpkg, such as dpkg-repack, reportbug, etc. Responsibility for its usage and possible breakage of the system therefore lies in the system administrator's hands.

```bash
apt install localepurge
```
