# Linux-based Router Firmware

Notes for DD-WRT and OpenWRT router firmware.

DD-WRT
- [Troubleshooting](ddwrt/ddwrt-troubleshooting.md) - Initial install failures
- [Hosts](ddwrt/dd-wrt.md) - Network-based ad and malware filtering, without additional hardware
- [Wifi VLAN setup](ddwrt/dd-wrt-vlan.md) - Guest wifi network setup

OpenWRT
- [Wired switchport VLAN](openwrt/openwrt-switchport-vlan.md) - Isolate untrusted wired devices
- [Wifi VLAN](openwrt/openwrt-wifi-vlan.md) - Isolate untrusted wifi devices / guest network
- [SSL Setup](openwrt/openwrt-enable-ssl-gui.md) - Enabling SSL connections on the Luci gui
- [Freeing Space](openwrt/openwrt-freeing-space.md) Freeing up storage space

Post Installation
- [Custom DNS](openwrt/custom-dns.md) - DNSCrypt setup/upgrade warning
- [Additional Security](openwrt/additional-security.md) - Even with previous hardening, some stuff slips through the cracks
- [Troubleshooting](openwrt/openwrt-troubleshooting.md) - OpenWRT troubleshooting
- [Site Blocking](openwrt/openwrt-site-blocking.md) - Ad and tracker filtering on OpenWRT

***

Most of these instructions were written for OpenWRT 17.01.6; for 18.06+, they are largely still valid - with the exception of iptables -state (which is deprecated in later versions.)

### OpenWRT Fix
If you try to use the obsolete shared library, you'll see:
> iptables v1.6.1: Couldn’t load match `state’:No such file or directory

Instead of (works in 17.01.6 - breaks in 18.06):
```bash
iptables -I FORWARD 1 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

Use this, instead:
```bash
iptables -I FORWARD 1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

**conntrack** has superseded **state**


***
DD-WRT latest utilized Oct 19, 2018 beta; r37442 (never had a single issue with DD-WRT throughout all of my upgrades, always stable and awesome despite being labled a beta release) -- the primary issue I take with DD-WRT is [limited support](https://wiki.dd-wrt.com/wiki/index.php/VLAN_Support) for VLAN switchports.

> Only Broadcom based devices support port-based VLAN's, no Atheros or Ralink devices.

While DD-WRT limits VLAN port capability, OpenWRT fully supports Atheros; based on the routers I've configured.
