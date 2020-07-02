# Scheduling a Reboot on a Linux-based System
A quick and useful command I don't use frequently enough to remember the syntax.

If a production system needs to be restarted for whatever reason, a simple restart schedule can be implemented:
```bash
shutdown -r 20:00
```
> Shutdown scheduled for Thu 2020-07-02 20:00:00 CDT, use 'shutdown -c' to cancel.

The `-r` argument indicates this will be a **reboot**; from the *manpage*:
```bash
man shutdown
```
```text
-r, --reboot
    Reboot the machine.
```
