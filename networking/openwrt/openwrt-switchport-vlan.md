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
- Name the interface, something like `eth3`
- Protocol: Static IP Address (enter a network that differs from your main one.  ie. if your main is 192.168.1.x, use `192.168.3.1` here)
- Select 'Custom Interface' radio and enter a vacant eth ID, like **eth0.3**

Note: If your LAN is presently **eth1**, then you'd use `eth1.3`, instead (match the VLAN ID).  If you have existing VLANs, increment the eth0.x to the highest unused number.

**Select DHCP server setup (same page)**

- Enter the starting octet (ex. 100)
- Enter the preferred total of IPs you'll be handing out; if you only have 1 device, set it low.  If multiple devices will connect, set higher.

Back up toward the top of the interface settings > 'Firewall Settings' tab

- Select the unspecified; create radio, fill `eth3`
- Save and Apply (bottom of the page)

### Switch configuration
The interface creation should have automatically generated a new VLAN ID for VLAN 3.  VLAN 1 is the "trusted" / default VLAN.  Depending on your setup, it may have added a different number, you can adjust it to what you want it to be.

For me, the port ordering was backwards to the port numbers on back of the router; I unplugged the connections and set the one I wanted to isolate so I was sure to get the right port.  (OpenWRT will auto load/reload the active switchports with the baseT reading)

![OpenWRT VLAN Ports](../img/openwrt-vlan-ports.png)

### Configure Forwarding and Isolation via Firewall Rules
In this area we'll make it so the ethernet VLAN has web access.

**Network > Firewall from the main pulldown** >
**Under Zones > Zone Forwardings:**
- lan:
  - Click Edit > For *Allow forward to destination zones:*, hit the pull-down, select `eth3` > Save & Apply at the bottom of page
- wan:
  - Click Edit > For *Allow forward from source zones:*, hit the pull-down, select `eth3` > Save & Apply at the bottom of page
- eth2:
  - Edit > Under *Covered networks*, tick `eth3` > Save & Apply at the bottom of page


**Back on the Firewall main page** >
**Under Custom Rules tab**

- Paste the [firewall rules](custom-firewall-rules.md)


Done!
