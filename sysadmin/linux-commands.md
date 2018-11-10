# Linux Commands

## Sort directory contents by filesize (largest to smallest)
With K, MB or GB overview
```bash
ls -lSh
```

***

## Flushing DNS

### Debian/Ubuntu-based distros (non-BIND)
Clear systemd DNS cache
```bash
systemd-resolve --flush-caches
```

Confirm the DNS purge
```bash
systemd-resolve --statistics
```
0 cache size indicates a successful DNS purge.

### RHEL/CentOS/Arch-based distros
Clear systemd DNS cache
```bash
systemctl restart nscd
```

Simply restarting the service clears the DNS cache.

###BIND-based DNS Servers
```bash
systemctl restart named
```
or
```bash
systemctl restart bind9
```
