# Troubleshooting Switches in IOS

Display error counters
```bash
show interfaces counters errors
```

Filter `show interface` to output errors in an overview
```bash
show int | i line|errors
```

Zoom in on total drops for a particular interface
```bash
sh int Gi0/1 | in drop|bits
```

Zoom errors
```bash
show interface Gi0/1 counters errors
```

Reset counters
```bash
clear counters Gi0/5
```

## Err-Disabled State
No traffic is being sent or received; status light is orange.

Show the full status:
```bash
sh int gi0/25
```
> GigabitEthernet0/7 is down, line protocol is down **(err-disabled)**
>
>  Hardware is Gigabit Ethernet, address is 001a.21cv.n341 (bia 001a.21cv.n341)
>
>  MTU 1500 bytes, BW 100000 Kbit, DLY 100 usec, reliability 234/255, txload 1/255, rxload 1/255


Or view only the disabled ports:
```bash
sh int status err-disabled
```

Short-form view:
```bash
show gi0/25 status
```

Output example:
```text
Port    Name               Status       Vlan       Duplex  Speed Type
Gi0/25                      err-disabled 1          full   1000 1000BaseSX
```

At this state, manual intervention is required.
```bash
en
conf t
int gi0/25
shutdown
no shutdown
```

This doesn't fix the initial cause (which may return, if not addressed) but will bring the port back online.

### Potential Cause
- Port Security error (allowing a single MAC to connect to that port)

In the event of port security being triggered, the port is automatically disabled.

Get port security details:
```bash
show port-security interface GigabitEthernet 0/25
```

> ....
>
> Violation Mode                  : Shutdown
>
> ....


### Determine the Reason
```bash
show errdisable recovery
```

### Band-aiding (Auto-recovery)
Auto-recovery won't fix the root of the problem, but will bring the port back up under fluke situations.  Relying on this method won't improve the uptime and will be sure to cause latency on the active port!

To bring the port back up 30 seconds after a violation:
```bash
errdisable recovery cause psecure-violation
errdisable recovery interval 30
```

***

## View syslog
```bash
show log
```

***
[Cisco documentation](https://www.cisco.com/c/en/us/support/docs/lan-switching/spanning-tree-protocol/69980-errdisable-recovery.html) actually has quite a few nice examples for resolution, as well.


***
## Third-Party SFP's
No activity on the fiber port? 3750 switch?
> Starting from 12.2(25)SE release, the user has the option via CLI to turn on the support for 3rd party SFPs.

### Force It
```bash
en
conf t
service unsupported-transceiver
no errdisable detect cause gbic-invalid
```

You may have to run `shut` and `no shut` on the interface after, if it had been disabled due to the SFP.


***
## Unable to SSH/telnet to Switch from Management VLAN
I ran into a residual bug left over from a previous setup - in this particular case, inter-VLAN routing is done at the firewall-level and not at the switch.

This particular switch, had that capability enabled:
```bash
ip routing
```

Fix:
```bash
no ip routing
wr mem
```
