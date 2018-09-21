# Configure Debian with Minicom for Cisco Switches

Install Minicom

```bash
apt update && apt install minicom
```
Plug in  the console cable and check the serial port
```bash
dmesg | grep tty
```
> .... console [tty0USB] enabled

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
| A -    Serial Device      : /dev/tty0USB                              |
| ...                                                                   |
| E -    Bps/Par/Bits       : 9600 8N1                                  |
| ...                                                                   |
|    Change which setting?                                              |
+-----------------------------------------------------------------------+
```
Exit and save.  

Launch the Minicom terminal emulator:
```bash
minicom
```
Launch the DMZ by hitting the Enter key.

### Info commands
Show a list of commands:
```bash
show ?
```

Show interfaces on the VLAN:
```bash
show vlan
```

Get the status of a port on the Gigabit ethernet switch (interface type - rack/port)
```bash
show interface Gi6/27
```
