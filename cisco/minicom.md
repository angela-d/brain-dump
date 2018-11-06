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

### Putty on Debian often works when Minicom doesn't
In 35xx switches, intermittent performance seems to occur with Minicom on Debian.  Either it doesn't respond to hitting the enter key to initially login, or the keys 'stick'.. ie. `aaddm` are received instead of `admin`

Most of the time, [Putty for Debian](https://packages.debian.org/stretch/putty) worths without a hitch.  Occasionally it does not, where Windows/Putty will have a 100% success rate using the same hardware.

### Testing a Console Cable Issues in Windows
Putty defaults to COM1 and the serial cable probably isn't registered to COM1.
- Right click the start menu > Devices
- Under Ports (COM & LP), The COM number will be listed.

In Putty, scroll to the bottom of the left panel > Under SSH > Serial:
- Serial line: COM7
- Speed: 9600
Connection type (radio): Serial

Click open to launch the session.
