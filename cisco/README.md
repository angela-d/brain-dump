# Cisco IOS Commands

Commands frequently used in Cisco IOS, so I don't forget them.

- [Minicom](minicom.md) - Initial setup of up Minicom (or Putty) on Debian
- [Reconfigure a Switchport](reconfigure-switchport.md) - Change the VLAN or label of a switchport
- [Reconfigure a Trunk Port](reconfigure-trunk-port.md) - Basic switchport to a trunk port
- [Remove a Trunk Port](remove-trunk-port.md) - Reset a trunk port to a basic switchport

## Global Info
Return all IPs registered to the switch
```bash
show ip interface brief
```

If the ports are only VLAN carriers, exclude unneeded stuff:
```bash
show ip interface brief | exclude unassigned
```

Most IOS commands can be abbreviated like `int` for **interface** or `brie` for **brief**.. what I use in my notes is dependent on how lazy I was at the time I saved the command.
