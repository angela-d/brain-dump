# Failed Unmounting Drive During Shutdown

When using vanilla shutdown (no Plymouth):
> [FAILED] Failed unmounting /var.

### Cause
After moving /var/log onto a separate partition, shutdown doesn't unmount /var due to systemd-journald using it.

### Solution
Make journald log to a volatile location, so it doesn't lock /var.  Caveat being there will be no shutdown logs.

Apply the fix:
```bash
pico /etc/systemd/journald.conf
```

Beneath `[Journal]`, add:
```bash
Storage=volatile
```
