# Assign a Single VLAN to a Switchport
To assign multiple VLANs one port, use [trunks](reconfigure-switchport.md).

```bash
enable
conf t
int Gi0/2
switchport mode access
switchport access vlan 12
```

Only traffic to VLAN 12 will route through port 2 from here on out.
