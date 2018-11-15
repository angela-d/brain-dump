# IOS Basic Setup

Stuff to do when setting up a new switch

**Configuration verbiage:**
* Teletype = Typewriters.. vty before modern computers
* console = (**C**onsole **T**elet**y**pe/cty) lines used when wired into the physical switch via console cable `line con 0`
* vty = (**V**irtual **T**elet**y**pe lines/tty) used when connected remotely (SSH or, preferably not: telnet) `line vty 0 4`
* AUX = Auxillary port / `line aux 0`
* `0 15` = Allows 16, `0 4` = 5 simulataneous connections via SSH/telnet

***

### Erase Any Prior Config
```bash
enable
conf t
erase startup-config
# confirm by hitting enter
delete flash:vlan.dat
# enter to confirm
show flash
```

Output should now just be the .bin file.

```bash
show start
```
> startup-config is not present

Good to go.  Now do a system reload:
```bash
reload
# enter to confirm
```

### Disable DNS lookups of incorrectly typed commands

Not doing so will incur lag as you wait for the terminal as IOS goes out and looks for a response.

*Not necessary if you intend on having the switch talk directly to other devices*:
> Switch> zzz
>
> Translating "zzz"...domain server (255.255.255.255)
>
> % Unknown command or computer name, or unable to find computer address

Launch exec + terminal edit mode
```bash
enable
conf t
```

Disable DNS lookups
```bash
no ip domain-lookup
```

***

### Add/modify banner

(# being the delimiter notifier; if using # in the body, select an unused character to be the delimiter.)
```bash
banner motd #Dont touch#
```

***
### View existing config (also changes not yet saved to NVRAM)
```bash
show run
```

***
### Show startup config
```bash
show startup-config
```

If returns:
> startup-config is not present

Changes have not been written to NVRAM and will be lost at reboot!

To fix:
```bash
copy running-config startup-config
```
(taking RAM-based config > NVRAM for permanent storage)
> Destination filename [startup-config]?

Hit enter to accept default config filename..

***

### Set a console password

```bash
enable
conf t
line ?
```

Output:
> <0-16> First Line number
>
> console Primary terminal line
>
> vty Virtual terminal

Proceed editing:
```bash
line console 0
password [enter password here]
login
exit
```

*If vty is present in `show run`, also secure it:*
```bash
enable
conf t
line vty 0
password [enter password here]
login
exit
```

***

### Encrypt console passwords
Encrypt all passwords on the switch, otherwise, they're stored in plain text.
```bash
enable
conf t
service password-encryption
exit

show run # to confirm the password is now obfuscated
```

***

### Securing multiple vty lines
```bash
enable
conf t
line vty 1 15
password [enter password here]
login
exit
```

### Assigning a New IP to the Switch
```bash
enable
conf t
int vlan1
ip address 172.14.5.0 255.255.255.0
no shut
```
Success:
> %LINK-5-CHANGED: Interface Vlan1, changed to state up
>
> %LINEPROTO-5-UPDOWN: Line protocol on Interface Vlan1, changed state to up

***

### Change the Default Gateway
```bash
enable
conf t
ip default-gateway 172.11.10.1
```

***

### Configure Switchport Security
Manually assign a MAC address
```bash
enable
conf t
int Gi0/2
switchport mode [access or trunk, depending on the port]
switchport port-security mac-address 00c0.w53w.123c # pick a UNIQUE mac address
```
**Alternatively, set to auto-learn MAC addresses**

*If previously configured manually:*

Dump the manually assigned MAC address
```bash
no switchport port-security mac-address 00c0.w53w.123c
```

See available options
```bash
switchport port-security mac-address ?
```

Choose sticky, to let the switch obtain the MAC address from the received frame
```bash
switchport port-security mac-address sticky
```

Set the maximum number of learned addresses (on this port)
```bash
switchport port-security maximum 1
```

Set the port to auto-shutdown, if another port other than the set/learned MAC address attempts to use it
```bash
switchport port-security violation shutdown
```

***

### Configure a New VLAN
99 being the 'new', previously unconfigured/nonexistent VLAN
```bash
enable
conf t
vlan 99
```

*In config-vlan mode now*

```bash
name 99 Network
end
show vlan brie
```
A brief listing of exiting VLANs will be displayed.

### Save changes stored in RAM to NVRAM
```bash
write memory
```
