# Cisco IOS Commands

Commands frequently used in Cisco IOS, so I don't forget them.

- [Minicom](minicom.md) - Initial setup of up Minicom (or Putty) on Debian
- [Reconfigure a Switchport](reconfigure-switchport.md) - Change the VLAN or label of a switchport
- [Reconfigure a Trunk Port](reconfigure-trunk-port.md) - Basic switchport to a trunk port
- [Remove a Trunk Port](remove-trunk-port.md) - Reset a trunk port to a basic switchport
- [VLAN Config](vlan-config.md) - Basic VLAN commands
- [Assign Single VLAN to a Port](assign-single-vlan-switchport.md) - Single VLAN access mode on a switchport

## Informational Commands
Bring up a disabled interface
```bash
no shut
```
Show all registered VLANs (and associated access ports)
```bash
show vlan brief
```

Show allowed VLANs on a particular trunk port
```bash
sh int Gi0/43 trunk
```

Return all IPs registered to the switch
```bash
show ip interface brief
```

If the ports are only VLAN carriers, exclude unneeded stuff:
```bash
show ip interface brief | exclude unassigned
```

Show port security info
```bash
sh port-security address
```

Show port security info for a specific switchport
```bash
sh port-security int Gi0/2
```

Show existing config files / flash memory
```bash
show flash
```

Device info (IOS version, etc)
```bash
show version
```

Most IOS commands can be abbreviated like `int` for **interface** or `brie` for **brief**.. what I use in my notes is dependent on how lazy I was at the time I saved the command.
