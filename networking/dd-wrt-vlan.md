# Setting up a VLAN Using DD-WRT GUI

VLANs are useful for segmenting guests or untrustworthy devices (like smart TVs/IoT devices) from the rest of your network.

If you have a Broadcom-based router, you may want to SSH into the router to make the changes, opposed to using the graphical user interface; apparently Broadcom routers have bugs when using the user interface for setting up VLANs.

Worth noting: If your router is low on initial memory, you may want to forgo VLANs. (Check under **Status > Memory**)

I had about 29MB of router memory *free* before adding my first VLAN; after, I had about 8MB free.  Your mileage may vary depending on average usage and number of devices/overall VLANs on your network.

**Wireless > Basic Settings** - Click Add to initialize the VLAN.

Enable the following:

- Set an SSID (if you want to broadcast)
- [x] Advanced Settings
- [x] WMM Support (when disabled, can revert to legacy speeds in some routers)
- [x] AP Isolation (keeps users from peeping at other users on the network)
- Network Configuration - Unbridged
- [x] Masquerade / NAT (allows net access)
- [x] Net Isolation (creates a Firewall rule to keep them from peeping at the parent network)
- [x] Forced DNS Redirection (should prevent them from using custom DNS to bypass any filters you may have set at DNS-level)

**Set a WIFI Password** - Wireless > Wireless Security
Under the virtual interface, find the SSID you just added and set a secure password.

**Optional DNS Target** - Use [OpenNIC](https://www.opennic.org/) or OpenDNS to bypass your ISP's ad-ridden DNS resolvers; set to a different DNS server than what your main access point uses, as an easy way to test whether or not the connections are segmented.

Set the IP Address and Subnet Mask (ie. 172.16.1.1 / 255.255.255.0

Hit Save and Apply Settings.

**Setup > Networking** - Enable DHCPd
- Click "Add" under the *DHCPD* menu
- Select the interface (ie. ath0.1 if this is your first guest network)
- Specify starting and maximum number of IPs, as well as lease time.  (Default is usually Start: 100, Max: 50 and Leasetime: 3600)

Hit Save and Apply Settings.

Try to login to your network via another computer or phone (if your device has custom DNS set, disable it to test!) and head to [DNS Leak Test](https://www.dnsleaktest.com/) to survey both your default network and new VLAN connection -- if each are using the different DNS servers you set at the beginning, you're good to go!

### Optional - Set QOS / Quality of Service
Bandwidth limit - prevents users on your new VLAN guest connection from gobbling your bandwidth and thereby slowing your *own* connection down.

**NAT / QOS > QOS**

Under **Interface Priority**, add the access points you want to do traffic shaping on (ie. your default ath0 and the VLAN ath0.1)

You can specify custom values for WAN Max Down, WAN Max Up and LAN Max; as well as target specific services like Bittorent.

For your primary network (the one you'll be using), set the priority to Maximum.  The guest VLAN can use a lower tier, or even Bulk, if you want to limit to idle bandwidth - bulk is 1% of allotted bandwidth.
