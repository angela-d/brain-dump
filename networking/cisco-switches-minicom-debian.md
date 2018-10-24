# Configure Debian with Minicom for Cisco IOS Switches

Install Minicom

```bash
apt update && apt install minicom
```
Plug in  the console cable and check the serial port
```bash
dmesg | grep tty
```
> .... console [ttyUSB0] enabled

Minicom needs root (or sudo) privileges:
```bash
ls -l /dev/ttyUSB0
```
> crw-rw---- 1 root dialout 188, 0 Oct 18 13:12 /dev/ttyUSB0

The user can alternatively be added to the dialout group (as root), run:
```bash
adduser angela dialout
```


Start Minicom config in a terminal window and maneuver it by using the arrow and enter keys.
```bash
minicom -s
```

Select *Serial Port Setup*:
```txt
+-----[configuration]------+
| Filenames and paths      |
| File transfer protocols  |
| Serial port setup        |
| Modem and dialing        |
| Screen and keyboard      |
| Save setup as dfl        |
| Save setup as..          |
| Exit                     |
| Exit from Minicom        |
+--------------------------+
```

Change the following options:
```txt
+-----------------------------------------------------------------------+
| A -    Serial Device      : /dev/ttyUSB0                              |
| ...                                                                   |
| E -    Bps/Par/Bits       : 9600 8N1                                  |
| ...                                                                   |
|    Change which setting?                                              |
+-----------------------------------------------------------------------+
```
Exit and save as "cisco".  

Launch the Minicom terminal emulator:
```bash
minicom cisco
```

*If Minicom acts up, redo the settings and **Save setup as dfl** (default)*

Launch the switch config by hitting the Enter key (1-2 times)

***

### Info commands
Show a list of commands:
```bash
show ?
```

Show interfaces on the VLAN:
```bash
show vlan
```

List the interfaces
```bash
show interface
```

Get the status of a port on the Gigabit ethernet switch (interface type - rack/port)
```bash
show interface Gi6/27
```

***

### Re-configuring a switch port
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

***

### Debugging Minicom
Config saves to `/etc/minicom/minirc` (if originally processed as root), otherwise to `~/.minirc.dfl` or `~/.minicom.cisco`

**Minicom config variables**
```bash
pu = public
pr = private
```

If the terminal isn't receiving input or has dyslexic output, use a different console cable.  (If the same occurs on Putty in Windows, it's the cable and not minicom.)

Modem manager also has a tendency to interfere by misinterpreting a serial cable for a mobile network device, so removing it may help in some situations:
```bash
apt remove --purge modemmanager
```

***

### Testing a Console Cable Issues in Windows
Putty defaults to COM1 and the serial cable probably isn't registered to COM1.
- Right click the start menu > Devices
- Under Ports (COM & LP), The COM number will be listed.

In Putty, scroll to the bottom of the left panel > Under SSH > Serial:
- Serial line: COM7
- Speed: 9600
Connection type (radio): Serial

Click open to launch the session.
