# Re-configure a basic switchport to a trunk port
Enable the terminal for config (config mode is potentially destructive with fat fingered changes)
```bash
enable
```

Specify mode type (`config` yields a list of choices), to select terminal:
```bash
conf t
```

*The terminal will now enter **config** mode*

Specify the port for changes (switch 6, port 8)
```bash
interface GigabitEthernet6/8
```
*The terminal will switch from **config** to **config-if** mode*

Assign a trunk port
```bash
switchport mode trunk
```

Specify the native VLAN (switchport trunk native vlan)
```bash
swi tr nat vl 6
```

Test the port.  If it returns the proper IP (assuming it's not a trunk port), exit out of config mode to save these changes.

```bash
exit # exit config-if
exit # exit config
end  # two for one exit
```

Write the changes to memory
```bash
wr mem
```
***
## Adding a description label to a switch port
Start config mode
```bash
enable
```
Select the terminal
```bash
configure terminal
```

Specify the interface, rack and port number
```bash
interface GigabitEthernet6/25
```

*Now in configure interface mode (config-if)*

```bash
description Print VLAN
```

Exit config-if mode
```bash
exit
```

Preview the changes
```bash
show interface GigabitEthernet6/25 status
```

Save changes to memory
```bash
wr mem
```

Done.
