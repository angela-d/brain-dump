# Re-configuring a switch port
Modifying trunk setups of a previously active trunk port

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

Turn off any residual native VLAN linkage (1 & 2 being previously configured VLANs)
```bash
no swi tr nat vl 1
no swi tr nat vl 2
```
Remove the previously enabled voice VLAN
```bash
no swi vo vl 3
```

Turn off access mode
```bash
no swi mod ac
```

Make it a trunk
```bash
swi mod tru
```

Set dot1q encapsulation
```bash
swi tr enc do
```

Set the new native VLAN
```bash
swi tr nat vl 6
```

***

## Adding a description label to a switch port
Write something descriptive
```bash
TC12-17 Someones Phone
```

When done, return to the interface view (exiting config mode)
```bash
exit # exit config interface
exit # exit config
end  # (end in place of the dual exits)
```

***

### Adjust an Invidual Switchport's Speed
- Half-Duplex = Send or Receive (Airport with one landing strip)
- Full-Duplex = Send or Receive at the Same Time (Airport with two landing strips; one for incoming, one for outgoing)

- *`speed [tab key]` will list available speeds to this switchport*
- *`duplex ?` lists available duplex speeds to this port*

**Mismatches at the client-side could experience performance degredation if their machine is not equipped for 1000 and 1000 is chosen as the hardcoded speed.**

'Auto' is less risky.

```bash
enable
conf t
int Gi0/2
speed auto
duplex auto
```

***

Write the changes to memory (outside of config mode)
```bash
wr mem
```
