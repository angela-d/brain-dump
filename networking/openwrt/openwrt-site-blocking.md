# Site Blocking in OpenWRT
If you have a cheap router, chances are you won't have enough space to utilize a hosts file after installing OpenWRT.

You can cherry-pick the worst offenders you need to block, using DNSMasq and SSH + CLI to cover *all* devices logged onto your network.

Open DNSMasq config:
```bash
vi /etc/dnsmasq.conf
```

- `i` to begin editing
- Append the following:
```bash
address=/google-analytics.com/0.0.0.0
address=/fonts.gstatic.com/0.0.0.0
address=/atdmt.com/0.0.0.0
address=/graph.facebook.com/0.0.0.0
address=/ads.ak.facebook.com/0.0.0.0
address=/creative.ak.facebook.com/0.0.0.0
address=/pixel.facebook.com/0.0.0.0
address=/ads.ak.facebook.com.edgesuite.net/0.0.0.0
address=/adobetm.com/0.0.0.0
address=/doubleclick.net/0.0.0.0
address=/googletagservices.com/0.0.0.0
address=/googletagmanager.com/0.0.0.0
address=/google-analytics.l.google.com/0.0.0.0
address=/google-analytics.l.google.com/0.0.0.0
address=/adservice.google.com/0.0.0.0
address=/googlesyndication.com/0.0.0.0
address=/googleadservices.com/0.0.0.0
address=/pagead-googlehosted.l.google.com/0.0.0.0
address=/tiqcdn.com/0.0.0.0
address=/pingdom.net/0.0.0.0
address=/newrelic.com/0.0.0.0
```
- When done, hit **ESC** key
- `:wq` to save your changes
- `/etc/init.d/dnsmasq restart` to restart DNSMasq

***
Note that this is basically poor man's filtering.  If you have a spare Pi, [Pi-Hole](https://pi-hole.net/) offers superior filtering.

[DD-WRT](https://dd-wrt.com/) is comparable router firmware to OpenWRT and is more friendly to cheap routers' space; the only advantage (imo) is OpenWRT VLAN support for select devices is superior to DD-WRT's.

[PC-based](https://github.com/angela-d/autohosts) filtering will offer substantially more protection, also.

***
## Automated Ad-Blocking

If your router has enough space (check: System > Software) you can install pre-made packages to maintain lists for you (especially useful when configuring a router that is not your own where your custom filters are too strict; for the types of people that click on ads because "they're convenient" ...)

Install SSL
```bash
opkg install libustream-openssl
```

Prepare the cert directory
```bash
mkdir -p /etc/ssl/certs
```

Set the environment variable
```bash
export SSL_CERT_DIR=/etc/ssl/certs
```

Install root certs
```bash
opkg install ca-certificates
```

Install the adblock package
```bash
opkg install adblock
```

And its companion for GUI control
```bash
opkg install luci-app-adblock
```

Select what filters you want to apply:

Services > Adblock

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


## Now that Site Filtering is Working, Automate List Updates
Add a cron entry
```bash
crontab -e
```

Customize your preferred update schedule (if you're using UTC time, run `date -u` in SSH to correlate the current time):
```bash
30 02 * * 5 /etc/init.d/adblock reload
```


According to OpenWRT documentation, crons aren't enabled by default, so activate it for good measure:
```bash
/etc/init.d/cron start && /etc/init.d/cron enable
```

If you added today's date/time to test, you can see if it ran by viewing the logs:
```bash
logread
```
***
## Adblock Troubleshooting
From the Luci Adblock log:
> your adblock config seems to be too old, please update your config with the '--force-maintainer' opkg option

If you're running a custom build, running the --force-maintainer option doesn't seem to work.

I had to pull in the latest adblock.conf from [OpenWRT's Github](https://github.com/openwrt/packages/tree/master/net/adblock/files).

- Log into the router over SSH
- Navigate to the Adblock config directory: `cd /etc/config/ && ls -l` - you should see **adblock**:
> -rw-------    1 root     root          9102 Dec 28 20:29 adblock

- Back it up: `mv adblock adblock.old`
- Pull in the new copy from OpenWRT's Github:
```bash
wget -O adblock https://raw.githubusercontent.com/openwrt/packages/master/net/adblock/files/adblock.conf
```

- Login to the GUI and reconfigure your list hosts, enable adblock > Save & Apply.  If you look at the log now, you should see its satisfied:
> blocklist with overall 44138 domains loaded successfully
