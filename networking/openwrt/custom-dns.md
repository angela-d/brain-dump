# Custom DNS on OpenWRT
By default, with OpenWRT, the ISP-supplied DNS will be handed out, which is no good since ISPs will compile your habits and sell your browsing history to data harvesters and advertisers (pretty much what using 8.8.8.8 would do, too..).

ISP DNS also tends to go down at a regular interval, whereas hosts that maintain DNS-specific resolvers almost never do.

(Custom DNS won't *prevent* such behavior, as there are other means + rumors of decryption schemes already at their disposal - but will layer privacy features, rather than browsing out in the open with guaranteed slurping.)

## Basic DNS Setup
Until the following step is met, there will be DNS leaks to the ISP, even if you *do* set custom resolvers throughout the config.

Network > Interfaces > select your **DHCP Servers' Interface** (usually something like *WAN*):
- Untick *Use DNS servers advertised by peer*

DNS for this Interface Only (skip if setting for all interfaces):
- A box will appear after un-ticking: **Use custom DNS servers** -- enter your preferred DNS

DNS for All Interfaces:
- Ensure *Use DNS servers advertised by peer* is unticked (see above)
- Network > DHCP and DNS > DNS forwardings: enter preferred DNS

***

## DNSCrypt with OpenWRT
These instructions are based on [David C's OpenWRT build](https://dc502wrt.org/) - should work on other builds, providing ca-bundle is installed: `opkg update && opkg install ca-bundle`

1. Login to the router via CLI
2. Remove dnscrypt-proxy v1 (if installed): `opkg remove --autoremove luci-app-dnscrypt-proxy`
3. Obtain dnscrypt-proxy v2 from dc502wrt.org:
```bash
cd /tmp &&
wget https://dc502wrt.org/releases/dnscrypt-proxy.tar.gz && gunzip -d dnscrypt-proxy.tar.gz &&
tar xvf dnscrypt-proxy.tar &&
rm -f dnscrypt-proxy.tar
```

4. Copy the extracted service script to its destination:
```bash
cp /tmp/dnscrypt-proxy/dnscrypt-proxy /usr/sbin/ &&
chmod 755 /usr/sbin/dnscrypt-proxy
```

5. Copy the config to its destination:
```bash
cp /tmp/dnscrypt-proxy/dnscrypt-proxy.toml /etc/config/
```

6. Copy the init script & apply proper permissions:
```bash
cp /tmp/dnscrypt-proxy/init.d/dnscrypt-proxy /etc/init.d/ &&
chmod 755 /etc/init.d/dnscrypt-proxy
```

7. In the Luci GUI dashboard, set the DNS either per interface (or for all interfaces) -- see *Basic DNS Setup*; to route DNS requests through DNSCrypt, use `127.0.0.1#5300` as the DNS IP.

### Configure DNSCrypt
By default, *Cloudflare* is the primary; to pick another host, get the server name from the [public servers list](https://dnscrypt.info/public-servers).
1. Edit the DNSCrypt config: `vi /etc/config/dnscrypt-proxy.toml`

2. To choose another host, change the following line:
```bash
server_names = ['cloudflare']
````
to the servers you'd like to use:
```bash
server_names = ['arvind-io','adguard-dns-doh','bottlepost-dns-nl','aaflalo-me-nyc']
````

3. Test loading configs:
```bash
dnscrypt-proxy -config /etc/config/dnscrypt-proxy.toml -check
```
> [NOTICE] Source [public-resolvers.md] loaded
>
> [NOTICE] Configuration successfully checked

4. Save config
```bash
/etc/init.d/dnscrypt-proxy enable &&
/etc/init.d/dnscrypt-proxy start
```

5. Adjust the fallback server (if you don't want Cloudflare), from:
```bash
fallback_resolver = '1.1.1.1:53'
```
to
```bash
fallback_resolver = '9.9.9.9:53'
```

6. Disconnect & reconnect your wifi/wired connection and run a [DNS leak test](https://www.dnsleaktest.com) to ensure your preferred resolvers are set and not your local ISP.

7. Adjust/enable any other preferred settings

**Note:** If you encounter periodic latency, you may want to swap out any dead resolvers that no longer appear on the public servers list.

If modified the dnscrypt-proxy config, simply restart the service (rather than re-running commands from #4): `/etc/init.d/dnscrypt-proxy restart`

### OpenWRT Upgrades Lose Config
The next sysupgrade may require the above steps to be re-run.

In my experience, after a system upgrade, all of the files remain in-place - but never activate.  Fastest resolution (to-date) is to simply re-run the install steps.

Reducing the default cache from 512 to 2 & restarting dnscrypt had no effect.

[Build r11583+ has dnscrypt-proxy2 pre-installed](https://dc502wrt.org/releases/openwrt-mvebu-cortexa9.manifest), but I still had to re-run the above install instructions after the latest upgrade.
