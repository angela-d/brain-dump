# Re-configuring a switch port
Enable the terminal for config (config mode is potentially destructive with fat fingered changes)
```bash
enable
```

Specify mode type (`config` yields a list of choices), to select terminal:
```bash
configure terminal
```

*The terminal will now enter **config** mode*

Specify the port for changes (switch 6, port 8)
```bash
interface GigabitEthernet6/8
```
*The terminal will switch from **config** to **config-if** mode*

Assign a new vlan to it
```bash
switchport access vlan 10
```

```bash
exit # exit config-if
exit # exit config
end  # two for one exit
```
## Adding a description label to a switch port
Start config mode
```bash
enable
```
Select the terminal
```bash
configure terminal
```

Specify the interface, rack and port number you want to edit (get the interface type and rack number by running `sh int status`)
- GigabitEthernet = shorthand `Gi`
- FastEthernet = shorthand `Fa`
```bash
int Git6/25
```

Write the changes to memory (outside of config mode)
```bash
wr mem
```
