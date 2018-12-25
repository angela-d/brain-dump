# Wifi VLAN for OpenWRT
Useful to segment untrustworthy devices like "smart" TVs and prevent bad behavior, snooping and surveillance of network traffic.

## Backup, first
System > Backup / Flash Firmware
- Generate archive
- Test the integrity of the backup by making a copy of it in another directory and extracting the content.  If you see the /etc directory, you're good to go.

**Network > Interfaces**
- Click 'Add New Interface' button
- Name 'vlan3'
- Protocol: Static address
- Click the radio for *Custom Interface* and fill **eth0.3** (Piggyback off the **lan**, so whatever eth ID the lan is, +1 to the last available VLAN ID.  If you have no other VLANs, this would be eth0.2) > Submit
- IPv4 address: 192.168.3.1
- IPv4 netmask 255.255.255.0
- Leave the rest blank

**Select DHCP server setup (same page)**

- Enter the starting octet (ex. 100)
- Enter the preferred total of IPs you'll be handing out; if you only have 1 device, set it low.  If multiple devices will connect, set higher.
- Save & Apply

**Network > Wifi**
- Click 'Add'
- Select the mode, channel, channel width and transmit power (shorter if your device is close, higher if farhter away)
- ESSID: "415bzp" (something uninteresting to bored people with scanners)
- Mode: Access Point
- Network: vlan3
- WMM Mode (leave ticked; when disabled, can revert to legacy speeds in some routers)

Wireless Security Tab
- Encryption: WPA2-PSK
- Cipher: Force CCMP (AES)
- Save & Apply


### Configure isolation via Firewall rules
**Network > Firewall from the main pulldown**

In this area we'll make it so the VLAN has web access.

LAN
- Edit > For *Allow forward to destination zones:*, tick 'vlan3' > Save & Apply at the bottom of page

**Enabling Isolation**

My router's GUI did not have a checkbox for isolation, so I SSH'd into the router and modified `vi /etc/config/wireless
` and found the block with the SSID (wifi broadcast name) and changed:
```bash
config wifi-iface                     
        option device 'radio0'
        option mode 'ap'      
        option ssid 'boring ssid name'
        option network 'vlan3'
        option encryption 'psk2+ccmp'
        option key 'thispasswordisnotencryptedbyopenwrt..'
```
to:
```bash
config wifi-iface                     
        option device 'radio0'
        option mode 'ap'      
        option ssid 'boring ssid name'
        option network 'vlan3'
        option encryption 'psk2+ccmp'
        option key 'thispasswordisnotencryptedbyopenwrt..'
        option isolate '1'
```

Note that if you try to send data to the "smart" TV from another wifi network, you'll break that capability with isolation.  Your device will need to login to this VLAN/SSID to communicate.

**Back on the Firewall main page > Under Custom Rules tab**

**Note:** This page is a continuation of my [OpenWRT Switchport VLAN notes](openwrt-switchport-vlan.md), if you're utilizing both of these.. the firewall rules there might make more sense, as the version below was redone to fit vlan3 into the mix.

Append the following:

```bash
# bridged connections are not automatically thumped from the web gui w/ later rules, so do a hard filter on ssh & http
iptables -I INPUT -p tcp -m multiport --dports 80,443,22 -j DROP
# whitelist the trusted vlan to ssh & http
iptables -I INPUT -p tcp -s 192.168.1.0/24 -m multiport --dports 80,443,22 -j ACCEPT

# allow trusted vlan devices to see eachother
iptables -I FORWARD 1 -m state --state RELATED,ESTABLISHED -j ACCEPT

# global block for untrusted vlans (this does not block access to the router gateway! just inter-vlan chatter)
# iprange would be ideal right here, but the version of iptables used in openwrt does not like it, its usage triggers: Bad argument `iprange', fyi
iptables -I FORWARD 2 -s 192.168.2.0/24 -d 192.168.1.0/24 -j DROP
iptables -I FORWARD 3 -s 192.168.2.0/24 -d 192.168.3.0/24 -j DROP
iptables -I FORWARD 4 -s 192.168.3.0/24 -d 192.168.1.0/24 -j DROP
iptables -I FORWARD 5 -s 192.168.3.0/24 -d 192.168.2.0/24 -j DROP

# block vlan2 (wired switchport vlan) from internal network pages
iptables -I INPUT -i eth0.2 -m state --state NEW -j DROP
iptables -I INPUT -i eth0.2 -p udp -m multiport --dports 53,67 -j ACCEPT
```

If you want to tweak or extend the firewall filtering, you can make changes in the GUI, but they won't be loaded until next reboot of the router.
- SSH into the router
- Run `/etc/init.d/firewall restart`
- The rules are now in effect!

Reboot the firewall by SSHing into the router and running `/etc/init.d/firewall restart` and try to access a device/IP on the forbidden VLAN.

Done!
