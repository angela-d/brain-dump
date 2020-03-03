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
3. Current versions of David's build include dnscrypt-proxy v2 by default

4. In the Luci GUI dashboard, set the DNS per interface (Network > Interfaces > Edit > Use custom DNS servers) to route DNS requests through DNSCrypt, use `127.0.0.53` as the DNS IP.

### Configure DNSCrypt
By default, *Cloudflare* is the primary; to pick another host, get the server name from the [public servers list](https://dnscrypt.info/public-servers).
1. Edit the DNSCrypt config: `vi /etc/dnscrypt-proxy2/dnscrypt-proxy.toml`

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
dnscrypt-proxy -config /etc/dnscrypt-proxy2/dnscrypt-proxy.toml -check
```
> [NOTICE] dnscrypt-proxy 2.0.39
>
> [NOTICE] Network connectivity detected
>
> [NOTICE] Source [public-resolvers] loaded
>
> [NOTICE] Source [relays] loaded
>
> [NOTICE] Configuration successfully checked


4. Save config
```bash
/etc/init.d/dnscrypt-proxy restart
```

5. Adjust the fallback server (if you don't want Cloudflare or Google), from:
```bash
fallback_resolver = '1.1.1.1:53'
```
to
```bash
fallback_resolver = '9.9.9.9:53'
```

6. Disconnect & reconnect your wifi/wired connection and run a [DNS leak test](https://www.dnsleaktest.com) to ensure your preferred resolvers are set and not your local ISP.

7. Adjust/enable any other preferred settings


# Caveats
This will intermittently jag up the tracking from coupon sites like Ebates / Rakuten (if you choose a DNSCrypt provider that offers filtering).

If you keep getting a connection refused, after disabling [the hosts file](https://github.com/angela-d/autohosts), this would be the culprit.

Temporary unblock the trackers:
- DHCP and DNS > DNS forwardings > remove **127.0.0.53** and temporary place another DNS host like **9.9.9.9** in its place
- After you're done shopping, reverse the above steps (and restore the hosts block) **and also clear your cookies**!
