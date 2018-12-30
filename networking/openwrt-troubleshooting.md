# OpenWRT Troubleshooting
Tweaking settings often requires troubleshooting steps.

### Remove a DHCP lease
Useful when changing DHCP settings and you need to make sure something didn't break that you'll only discover 12 hours later when it's time to reissue the IP.

Open the DHCP leases file:
```bash
vi /tmp/dhcp.leases
```
- Disconnect the device you're going to test with
- Hit **I** key; navigate to the device you want to remove the lease for (position the cursor to the left prefix of the line)
- Hit **ESC** key, type `dd` to remove the line
- `:wq` to save changes
- `/etc/init.d/dnsmasq restart` to restart DNSmasq
