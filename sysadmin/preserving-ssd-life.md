# Preserving SSD Life
Super nerds will say "Modern SSDs will last 17000tb+ / 51 years" - don't waste your time etc etc.

Bugs happen, runaway processes happen - so if it's easy enough to preserve gigs of bits over the lifespan of an SSD, why not?  Certainly not something I'd prioritize necessarily (I didn't tweak mine until after it was a year or so old).

Some of my configs are a bit splintered for organizational purposes, so I'll link to those:


## Firefox/Waterfox tweaks
- [about:config changes](../tree/master/browsers/.mozilla/)

## Linux tweaks
- [Moving logs to another partition](changing-where-logs-are-stored.md)

### Disabling timestamp read writes
Disables *accessed* times on files and folders when you right-click.  Access times will be 'frozen' after setting these flags.  I find them only really useful in a server setting, not on desktop.
In `/etc/fstab`:
- Pre-pend `noatime,nodiratime` to all mounted directories (ignoring swap), like so:

```bash
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
...
#before:
#UUID=... /               ext4    noatime,nodiratime,errors=remount-ro 0       1

#after:
UUID=... /               ext4    noatime,nodiratime,errors=remount-ro 0       1
...
```
