# Block Windows 10 Telemetry at the Router
Windows 10 spying is easily avoidable by using a [better operating system](https://debian.org); one that doesn't discourage you from [customizing it](https://pling.com).

Even *with* telemetry blocked at hosts, [it appears to be ignored](https://www.extremetech.com/computing/313487-blocking-ms-telemetry-in-hosts-file-now-triggers-windows-defender-virus-warning), anyway.

Telemetry, **when opt-in** is useful for developers to gauge software use-cases and obtain useful statistics.  I participate in [Debian's telemetry](https://popcon.debian.org/) *because* it is **opt-in**.  Telemetry that doesn't give you a choice, and/or doesn't clearly and *concisely* inform you what's collected and what it's used for.. is safe to assume it's collected for nefarious purposes.

So, block it at your router and keep that bandwidth to yourself.

Log into your router via SSH
```bash
ssh root@192.168.1.1
```

Create a temporary file
```bash
vi /tmp/microsoft-sniffers
```
- Press `i` to open insert mode
- Paste the following:
```text
telemetry.microsoft.com
wns.notify.windows.com.akadns.net
v10-win.vortex.data.microsoft.com.akadns.net
us.vortex-win.data.microsoft.com
us-v10.events.data.microsoft.com
urs.microsoft.com.nsatc.net
watson.telemetry.microsoft.com
watson.ppe.telemetry.microsoft.com
vsgallery.com
watson.live.com
watson.microsoft.com
telemetry.remoteapp.windowsazure.com
telemetry.urs.microsoft.com
```

- Press `ESC` to exit insert mode
- Type `:wq` to write/save & quit the file you created
- Append it to the router's `/etc/hosts` file, by running:
```bash
cat /tmp/microsoft-sniffers >> /etc/hosts
```

From within your router's terminal, check:
```bash
nslookup vsgallery.com
```
You should see:
```text
root@OpenWrt:~# nslookup vsgallery.com
Server:		127.0.0.1
Address:	127.0.0.1#53
```
And if you try to visit that URL in your browser, it should fail.

***
To also block ads across your network (Android/iOS devices), see [site blocking](https://github.com/angela-d/brain-dump/blob/master/networking/openwrt/openwrt-site-blocking.md) or [DNSCrypt](https://github.com/angela-d/brain-dump/blob/master/networking/openwrt/custom-dns.md) notes for OpenWRT.  For Linux or Mac hosts blocking, see [autohosts](https://github.com/angela-d)

### Note
It is safe to assume Microsoft will start using a new series of URLs if they start noticing these URLs increasingly being blocked.  The only way to ensure you get them all, is to use something cooler, like a Linux distro.
