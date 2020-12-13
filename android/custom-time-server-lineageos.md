# Setting a Custom Time Server on LineageOS / Custom ROM

I use [AFWall](https://f-droid.org/en/packages/dev.ukanth.ufirewall/) and saw a lot of outgoing denied connections to a bunch of IPs when I wasn't using the phone, the outgoing connections route under "Linux Kernel," instead of a system app that may be making the call, so a bit of work is involved in figuring out who Android is trying to talk to.

One of them happened to be `216.239.35.12` - a `whois 216.239.35.12` reports back it's owned by Google.

Does this IP have a nameserver that can clue me in on what it does?
```bash
nslookup time4.google.com
```

I'd rather deprive Google of that sliver of data of my device phoning in, so I want to change the NTP server (and then I will allow NTP to access the web!)
- Hook up the device to a laptop with ADB / Android Debug Bridge
- `adb devices` to activate a connection

Obtain the current NTP setting
```bash
adb shell settings get global ntp_server
```
- null = Google's choice

Set your own
```bash
adb shell settings put global ntp_server 0.pool.ntp.org
```

Check the setting, now
```bash
adb shell settings get global ntp_server
```
> 0.pool.ntp.org
