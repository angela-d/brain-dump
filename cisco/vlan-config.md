# VLAN Configuration on IOS

VLAN config is automatically saved to the VLAN database on flash memory in Cisco IOS; vlan.dat (no `wr mem` necessary)

### List Available VLANs
```bash
sh vl
```

### Change a VLAN's name
```bash
enable
conf t
vlan 11
name VLAN 11
```

Save changes
```bash
wr mem
```

***

### Delete a VLAN
It would be a good idea to *ensure* no ports are using this VLAN, first, else you'll end up with an orphaned port.. `show vlan brief` - if its row is empty, good to go.

If ports are using it, see [reconfigure switchport ](reconfigure-switchport.md) to remove the VLAN from individual switchports.

```bash
enable
conf t
no vlan 67
```
