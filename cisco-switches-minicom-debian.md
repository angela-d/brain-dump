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

Start Minicom config in a terminal window
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
Exit and save.  Launch the DMZ by hitting the Enter key.

### Info commands
Show a list of commands:
```bash
show ?
```

Show interfaces on the VLAN:
```bash
show vlan
```
