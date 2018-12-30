# Linux-based Router Firmware

Notes for DD-WRT and OpenWRT router firmware.

DD-WRT
- [Hosts](dd-wrt.md) - Network-based ad and malware filtering, without additional hardware
- [Wifi VLAN setup](dd-wrt-vlan.md) - Guest wifi network setup

OpenWRT
- [Wired switchport VLAN](openwrt-switchport-vlan.md) - Isolate untrusted wired devices
- [Wifi VLAN](openwrt-wifi-vlan.md) - Isolate untrusted wifi devices / guest network

Post Installation
- [Additional Security](additional-security.md) - Even with previous hardening, some stuff slips through the cracks
- [Troubleshooting](openwrt-troubleshooting,md) - OpenWRT troubleshooting
- [Site Blocking](openwrt-site-blocking.md) - Ad and tracker filtering on OpenWRT

***
OpenWRT 18.06 is bugged out on my router; DHCP refuses to issue new IPs (even after a wipe of settings/'factory reset'), so these instructions are valid for 17.01 branch releases (17.01.6 at the time of writing).
***
DD-WRT latest utilized Oct 19, 2018 beta; r37442 (never had a single issue with DD-WRT throughout all of my upgrades, always stable and awesome despite being labled a beta release).
