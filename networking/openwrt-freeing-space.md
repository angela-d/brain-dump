# Freeing Space on OpenWRT

You cannot free space from the SquashFS used by OpenWRT, as it is read-only.  

A second partition, JFFS2, is where changes are made to.  Deleting a system-installed app will actually *decrease* the available storage space, as the 'deleted' bits are written over with notes, rather than wiped.  

Space on the SquashFS cannot be reclaimed.

Alternatives:
- Compile from source for installation and strip out apps you don't need in advance
- Ignore the pre-installed apps you don't need


The same seems to happen when you uninstall something you installed yourself.  For some reason, it doesn't appear OpenWRT does `--autoremove` when removing addons from the GUI.

Alternative:
- Don't delete your self-installed apps from the GUI, do so from the command line:
```bash
opkg remove wifischedule --autoremove
```
