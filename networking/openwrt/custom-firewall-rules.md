# Custom Firewall Rules for OpenWRT
If you want to tweak or extend the firewall filtering, you can make changes in the GUI, but they won't be loaded until next reboot of the router.


If you use these, be sure to modify the interfaces, like: `-i eth0.2` and the IP ranges to match your topology.

- You can base your rules on:
  - VLAN IP: `-s 192.168.2.0/24`
or
  - Interface: `-i eth0.1`

```bash
# bridged connections are not automatically thumped from the web gui w/ later rules, so do a hard filter on ssh & http
iptables -I INPUT -p tcp -m multiport --dports 443,2383,80 -j DROP

# whitelist the trusted vlan to ssh & http
iptables -I INPUT -p tcp -s 192.168.1.0/24 -m multiport --dports 443,2383,80 -j ACCEPT

# allow trusted vlan devices to see eachother
iptables -I FORWARD 1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


# global block for untrusted vlans (this does not block access to the router gateway! just inter-vlan chatter)
iptables -I FORWARD 2 -s 192.168.2.0/24 -d 192.168.1.0/24 -j DROP
iptables -I FORWARD 3 -s 192.168.2.0/24 -d 192.168.3.0/24 -j DROP
iptables -I FORWARD 4 -s 192.168.3.0/24 -d 192.168.1.0/24 -j DROP
iptables -I FORWARD 5 -s 192.168.3.0/24 -d 192.168.2.0/24 -j DROP


# the following 2 rules reject all traffic, short of dns (port 53), dhcp (port 67)
# also prevents untrusted vlan from seeing the web gui
iptables -I INPUT -s 192.168.2.0/24,192.168.3.0/24 -m conntrack --ctstate NEW -j DROP
iptables -I INPUT -s 192.168.2.0/24,192.168.3.0/24 -p udp -m multiport --dports 53,67 -j ACCEPT


# allow torrenting from wired vlan1 - also restrict networking ports in deluge/qbittorent (untick random ports, since no range is set here)
iptables -A INPUT -i eth0.1 -m conntrack --ctstate RELATED,ESTABLISHED -p udp --dport 51413 -j ACCEPT
iptables -A OUTPUT -p udp --sport 51413 -j ACCEPT

iptables -A INPUT -i eth0.1 -m conntrack --ctstate RELATED,ESTABLISHED -p tcp --dport 51413 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 51413 -j ACCEPT
```

Reboot the firewall by SSHing into the router and running `/etc/init.d/firewall restart` and try to access a device/IP on the forbidden VLAN.

**Why you want to SSH in to reboot:**

When I set these rules through the GUI, the page refreshed without any message.  Restarting through SSH will throw explicit error messages if something isn't set correctly.

- SSH into the router
- Run `/etc/init.d/firewall restart`
- The rules are now in effect!

Try to access a device/IP on the forbidden VLAN.

Now, move onto [additional security](additional-security.md)
