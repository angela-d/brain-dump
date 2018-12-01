# Removing a trunk port
Resetting a previously configured trunk port, to a singular VLAN.

Get the interface type (Gi/GigabitEthernet or Fa/FastEthernet)
```bash
sh int status
```

Confirm the switch port's status before modifying
```bash
sh int Fa0/38 status
```

Returns:
```bash
switch1#sh int Fa0/38 status

Port    Name               Status       Vlan     Duplex Speed   Type
------- ------------------ ------------ -------- ------ ------- ----
Fa0/38  RM E               notconnect   trunk      Auto    Auto 100BaseTX/FX
```

Go into edit mode
```bash
enable
```
Select the terminal for editing

```bash
conf t
```

Specify the port you're editing
```bash
int Fa0/38
```

Remvoe the trunk
```bash
no swi tr allowed
```

Remove dot1q encapsulation
```bash
no swi tr enc do
```

Set access mode to the switch port
```bash
swi mod ac
```

Assign the single VLAN
```bash
switchport access vlan 2
```

Exit the config interface
```bash
end
```
View the changes
```bash
sh int Fa0/38 status
```
If the port is tested and returns the proper VLAN's IP, commit to memory
```bash
wr mem
```

```bash
switch 1#sh int Fa0/38 status


Port    Name               Status       Vlan     Duplex Speed   Type
------- ------------------ ------------ -------- ------ ------- ----
Fa0/38  RM E               notconnect   2          Auto    Auto 100BaseTX/FX
```
