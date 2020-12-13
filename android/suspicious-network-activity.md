# Suspicious Network Activity on Android
Android devices are *very* chatty and make a lot of connections to servers you may not want your deivce talking to.

## How to Find Suspicious (or Unwanted) Network Attempts
1. Use a firewall ([AFWall](https://f-droid.org/en/packages/dev.ukanth.ufirewall/) is a good one, if you're rooted)
2. Block everything by default, allow only what you **know** needs internet access; any type of incoming/outgoing permissions
3. Assuming that firewall has good log access to easily differentiate between denied and approved requests, look at them and research who the attempt is trying to talk to

- `logcat` or `adb logcat` can show you DNS activity, too.

Once you have the IP addresses of the blocked attempts, focus on those, first. Then you can [monitor with Wireshark](wireshark-android.md) to see what's making it's way through your approved apps.

## Find the Owner of the IP Android is Connecting To
If you're on a Linux system, you can use the `whois` package to do whois lookups from your terminal
```bash
whois 216.239.35.12
```
> OrgName:        Google LLC

Not every lookup will return a nameserver, but it can clue you in on what the attempt may have been trying to do
```bash
nslookup 216.239.35.12
```
> 12.35.239.216.in-addr.arpa	name = time4.google.com.

This connection was the result of the NTP time settings of Android being set to 'null'; [set a custom time server](custom-time-server-lineageos.md)
