# Additional Security / Post-Installation

Default router setups are not secure.  Utilizing [GRC's Shields Up!](https://www.grc.com/default.htm) > All Service Ports scans can help locate things overlooked while configuring the network.

**After [setting up VLANs](README.md) for untrusted devices**
- Most ports were closed
- On OpenWRT, DNS/port 53 was wide open

To remedy this:
```bash
vi /etc/dnsmasq.conf
```

Add the following:
```bash
listen-address=192.168.1.1, 127.0.0.1
bind-interfaces
```

Restart the daemon:
```bash
/etc/init.d/dnsmasq restart
```

- Test any affected networks/VLANs
- Re-run the scan


***

## Security by obscurity

Move SSH off of port 22.  Even if you firewalled it by IP, its a nice habit to get into.

In OpenWRT web gui:

Systen > Administration
- Change **Port** from 22 to some non-standard port
- Un-tick Allow root logins with password (*only* if you supply an SSH key!!)
- Un-tick Password authentication (again, **only** with the presence of an SSH key)
- Add your pubkey in the textarea beneath the SSH Keys header
- If you already have firewall rules locking down port 22 by an IP filter, adjust that rule to reflect the new port

### Add an alias because you probably won't remember the port you changed it to
```bash
pico ~/.ssh/config
```

Append the following:
```bash
Host router
HostName 192.168.1.1
Port 2299
User root
Compression yes
IdentityFile ~/.ssh/path/to/your/privatekey
```

Now anytime you need to SSH into the router, simply run:
```bash
ssh router
```
- Make backups of the router config *and* `~/.ssh/config`

It should be noted that if you do *not* firewall by IP range (only allow *your* local, trusted IP range), the port can still be discovered if its wide open by any self-respecting script-kiddie.

If you do not intend to use SSH, turn it off altogether.
