# VLAN Switchport Setup on OpenWRT

Traffic isolation for wired devices on routers running OpenWRT.

## Backup, first
System > Backup / Flash Firmware
- Generate archive
- Test the integrity of the backup by making a copy of it in another directory and extracting the content.  If you see the /etc directory, you're good to go.

Web GUI modifications:

### Setup the VLAN interface
**Network > Interfaces**
- Click 'Add New Interface' button
- Name the interface, something like 'vlan2'
- Protocol: Static IP Address (enter a network that differs from your main one.  ie. if your main is 192.168.1.x, use 192.168.2.1 here)
- Select 'Custom Interface' radio and enter a vacant eth ID, like **eth0.2**

Note: If your LAN is presently **eth1**, then you'd use *eth1.2*, instead.  If you have existing VLANs, increment the eth0.x to the highest unused number.

**Select DHCP server setup (same page)**

- Enter the starting octet (ex. 100)
- Enter the preferred total of IPs you'll be handing out; if you only have 1 device, set it low.  If multiple devices will connect, set higher.

Back up toward the top of the interface settings > 'Firewall Settings' tab

- Select the unspecified -or- create radio, fill 'vlan2'
- Save and Apply (bottom of the page)

### Switch configuration
The interface creation should have automatically generated a new VLAN ID for VLAN 2

For me, the port ordering was backwards to the port numbers on back of the router; I unplugged the connections and set the one I wanted to isolate so I was sure to get the right port.

- CPU: tagged for all VLANs
- For the trusted VLAN, I left everything untagged.

VLAN 2 settings:
- Port 1 (the port the untrusted device will be going into) > untagged
- All other ports set to 'off'
- For *all other* VLANs, set **Port 1** to 'off'

The 'proper' way to do this would be to *tag* the untrusted VLAN, but for whatever reason, doing so caused a dead port.  Possibly a bug in the firmware for my specific router.  Try both ways and see what works, for different models.

Since this VLAN is going to be firewalled off from the others, it doesn't really matter in this particular case.

### Configure isolation via Firewall rules
**Network > Firewall from the main pulldown**

In this area we'll make it so the VLAN has web access.

LAN
- Edit > For *Allow forward to destination zones:*, tick 'vlan2' > Save & Apply at the bottom of page


wan
- Edit > For *Allow forward from source zones:*, tick 'vlan2' > Save & Apply at the bottom of page

vlan2
- Edit > Under *Covered networks*, tick *vlan2*
- For *Allow forward to destination zones:*, tick 'wan'
- For *Allow forward from source zones:*, tick *lan* > Save & Apply at the bottom of page

**Back on the Firewall main page**

Manually setting the firewall rules to segment the traffic; the GUI vlan setup does not automatically do this (as DD-WRT does if you tick 'Isolate')

**Under Custom Rules tab**

I set the rule numbers to 96 and 97 to ensure they load last to ensure no prior rule overrides.

Paste the following:
```bash
# allow trusted vlan devices to see eachother
iptables -I FORWARD 96 -m state --state RELATED,ESTABLISHED -j ACCEPT

# don't allow untrusted vlan (192.168.2.x) to see trusted (192.168.1.x)
iptables -I FORWARD 97 -s 192.168.2.1/24 -d 192.168.1.0/24 -j DROP

# eth0.2 = vlan2 switchport; the following 2 rules reject all traffic, short of dns (port 53), dhcp (port 67)
# also prevents untrusted vlan from seeing the web gui
iptables -I INPUT -i eth0.2 -m state --state NEW -j DROP
iptables -I INPUT -i eth0.2 -p udp -m multiport --dports 53,67 -j ACCEPT
```

Reboot the firewall by SSHing into the router and running `/etc/init.d/firewall restart` and try to access a device/IP on the forbidden VLAN.

Done!
