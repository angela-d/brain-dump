# Site Blocking in OpenWRT

If your router has enough space (check: System > Software) you can install pre-made packages to maintain lists for you (especially useful when configuring a router that is not your own where your custom filters are too strict; for the types of people that click on ads because "they're convenient" ...)

1. Go into OpenWRT's GUI > System > Software
2. Search for: `luci-app-adblock-fast`

    - That should also bring in all dependencies
3. Select your blacklists and add any whitelisted domains from: Services > Adblock Fast

***

Test your new filter; in your local CLI (not the router):
```bash
dig +short @192.168.1.1 google-analytics.com A
```
Replace 192.168.1.1 for *your* main gateway.

If setup correctly, you'll see:
```bash
angela@debian: dig +short @192.168.1.1 google-analytics.com A
0.0.0.0
```

0.0.0.0 = google-analytics.com's DNS is returning localhost/not routable (it will never reach Google)

Example of a routable address:
```bash
angela@debian: dig +short @192.168.1.1 github.com A
192.30.253.112
192.30.253.113
```

Returning two routable addresses to github.com

## Troubleshooting

I ran into a weird scenario where I wanted to access a site that was being blocked on the hosts list, so I added it to Adblock Fast's whitelist and hit save, closed all my browsers and made sure the browser wasn't caching.

Adblock Fast showed itself downloading a new list each time I hit save, I assumed this meant it was re-building the list.

Perhaps it was, but the original iteration may have been stored in RAM or cached; I was only able to access the site once I temporarily disabled Adblock Fast by doing the following experiment:

- Test the site with Brave (Settings > search for: DNS > select Security > Use secure DNS)
    - OS default was toggled on, but in this particular scenario, Brave wasn't using my local DNS (dig had no A record IP)
    - Blacklisted sites worked!
- Test the site with a separate Firefox profile than my default (about:profiles > select/create something else) > Settings > search for: DNS > Under: Enable secure DNS using: > set to **Max protection** and choose a provider
    - (1 of 2) blacklisted sites worked! (not sure what went on here and why the results were different than Brave)

This confirms the blocking is coming from the router (not the computer's local hosts file or adblocking browser extensions)

In OpenWRT GUI:
- Network > DHCP and DNS > Forwards
- Under: Additional servers file > remove `/var/run/adblock-fast/dnsmasq.servers`
- Save and update
    - Blacklisted site worked! (put it back after testing)


### Fix for Future Issues
Restart or stop/disable > re-enable Adblock Fast after appending whitelisted domains

### Worth Noting
These types of addons will not survive OpenWRT updates without [additional steps](upgrading-openwrt-retaining-packages.md)