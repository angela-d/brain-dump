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
These instructions are based on **dnscrypt-proxy v2** from [official OpenWRT documentation](https://openwrt.org/docs/guide-user/services/dns/dnscrypt_dnsmasq_dnscrypt-proxy2)

### Pre-requisites
There is no GUI on vanilla OpenWRT for dnscrypt-proxy2 at the time of writing; some custom builds offer one.
1. Login to the router via CLI
2. Remove dnscrypt-proxy v1 (if installed): `opkg remove --autoremove luci-app-dnscrypt-proxy dnscrypt-proxy`
3. Install dependencies:
  - Install *ca-bundle* for CA certificates `opkg update && opkg install ca-bundle`
  - Install *dnsmasq* & *dnscrypt-proxy2*: `opkg install dnsmasq dnscrypt-proxy2`


4. Enable DNS encryption
Continue running these commands in the router's terminal.
```bash
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server="127.0.0.53#53"
```

5. Enforce DNS encryption for LAN clients
```bash
uci set dhcp.@dnsmasq[0].noresolv="1"
uci commit dhcp
/etc/init.d/dnsmasq restart
```

### Configure DNSCrypt
With `server_names` commented out (prefixed with #), dnscrypt will choose resolvers based on the config settings in **/etc/dnscrypt-proxy2/dnscrypt-proxy.toml**

To override and use specific servers, uncomment that variable and choose your servers from the DNSCrypt public list.

1. Edit the DNSCrypt config: `vi /etc/dnscrypt-proxy2/dnscrypt-proxy.toml`

2. (optional) To choose custom hosts, change the following line:
```bash
server_names = ['cloudflare']
````
to the servers you'd like to use:
```bash
server_names = ['arvind-io','adguard-dns-doh','bottlepost-dns-nl','aaflalo-me-nyc']
````
- :warning: When using `ams-dnscrypt-nl` Google appeared as a resolver during a [DNS Leak Test](https://dnsleaktest.com/)
  - (despite Google already having been removed as a fallback resolver in the default config)


- :warning: When using `yandex` it appears they "poison" the DNS by loading Russian paypal.com over PayPal's own regional auto-detect settings

  **Optionally add these resolvers to your blacklist:**  Modify the existing variable *disabled_server_names*:
  ```bash
  # Server names to avoid even if they match all criteria                         
  disabled_server_names = ['ams-dnscrypt-nl','cloudflare','yandex']    
  ```

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

# Troubleshooting

**Unexpected Results**

If you're seeing an unexpected page (such as PayPal Russia, as mentioned above) you may want to disable the DNS cache in both OpenWRT and Firefox ESR before testing, or you will encounter a lot of false-positives:
- In OpenWRT: Network > DHCP and DNS > **Size of DNS query cache**: `0`
- In Firefox ESR: `about:config` > **network.dnsCacheExpiration**: `0` and **network.dnsCacheExpirationGracePeriod**: `0`

**No Access to the Web**

I ran into this when I decided to move my router: for whatever reason once I hooked everything up, the DNS was unresponsive, yet ping-able.  To fix, I simply went into Luci:
- Network > DHCP and DNS > Advanced Settings > Size of DNS query cache: `0`
- Network > DHCP and DNS > General Settings > DNS forwardings: `9.9.9.9` > try to access/ping a page

Once everything appears to be running:
- Network > DHCP and DNS > General Settings > DNS forwardings: `127.0.0.53` > try to access/ping a page > Go to [DNS Leak Test](https://dnsleaktest.com/) and make sure you're not on 9.9.9.9, anymore

***

Internet seemingly stopped working at random.

In the OpenWRT dashboard:

 - Status > System Log
 - The following entries were present:
 
  ```text
  Thu May 11 06:52:03 2023 daemon.err dnscrypt-proxy[14362]: [ERROR] No useable certificate found
  Thu May 11 06:52:03 2023 daemon.err dnscrypt-proxy[14362]: [NOTICE] dnscrypt-proxy is waiting for at least one server to be reachable
 ```

 Seems the time got messed up:

 - System > System > Time Synchronization
   - Make sure valid NTP servers are set
  - Under General Settings tab > make sure the proper timezone is set
    - Select Sync with NTP server

Internet / DNS is working again:

  ```text
  Thu May 11 19:38:15 2023 daemon.err dnscrypt-proxy[15063]: [NOTICE] [ams-dnscrypt-nl] OK (DNSCrypt) - rtt: 115ms
  Thu May 11 19:38:15 2023 daemon.err dnscrypt-proxy[15063]: [NOTICE] [cs-tx2] OK (DNSCrypt) - rtt: 141ms
  Thu May 11 19:38:15 2023 daemon.err dnscrypt-proxy[15063]: [NOTICE] Sorted latencies:
  Thu May 11 19:38:15 2023 daemon.err dnscrypt-proxy[15063]: [NOTICE] -   115ms ams-dnscrypt-nl
  Thu May 11 19:38:15 2023 daemon.err dnscrypt-proxy[15063]: [NOTICE] -   141ms cs-tx2
  ```

# Caveats
This will intermittently jag up the tracking from coupon sites like Ebates / Rakuten (if you choose a DNSCrypt provider that offers filtering).

If you keep getting a connection refused, after disabling [the hosts file](https://github.com/angela-d/autohosts), this would be the culprit.

Temporary unblock the trackers:
- DHCP and DNS > DNS forwardings > remove **127.0.0.53** and temporary place another DNS host like **9.9.9.9** in its place
- After you're done shopping, reverse the above steps (and restore the hosts block) **and also clear your cookies**!
