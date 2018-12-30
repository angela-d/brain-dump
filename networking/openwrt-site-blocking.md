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
```
- When done, hit **ESC** key
- `:wq` to save your changes
- `/etc/init.d/dnsmasq restart` to restart DNSMasq

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

***
Note that this is basically poor man's filtering.  If you have a spare Pi, [Pi-Hole](https://pi-hole.net/) offers superior filtering.

[DD-WRT](https://dd-wrt.com/) is comparable router firmware to OpenWRT and is more friendly to cheap routers' space; the only advantage (imo) is OpenWRT VLAN support for select devices is superior to DD-WRT's.

[PC-based](https://github.com/angela-d/autohosts) filtering will offer substantially more protection, also.
