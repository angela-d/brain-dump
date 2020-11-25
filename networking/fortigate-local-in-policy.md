# Fortigate Local-in Policy
Local-in policies load before policy objects and only cover addresses that reside on the firewall.

Example:
- If an IP address is hit from a bot that should have been covered by a local-in, but the IP space it probed is 'inactive,' not currently tied to anything under Trusted, Isolation, etc. it will then proceed down the rule evaluations, before rule 0 is triggered.
  - An example would be an IP in your assigned space, but not currently active.

## Address Groups
For *source addresses* that will likely need modifications in the future, I set these as **address groups**, so you do not modify the local-in policy to add addresses or geo locations, you modify the group.

| Local-in Policy | Address Group | Example Addresses |
| ------------- |:-------------:| ------------- |
| Allow IPSEC / IKE service | ALLOWED-IPSEC | Your ISPEC partners |
| VPN connections / any chatter to the firewall | Firewall-Allowed | Geo locations permitted to log onto your corp VPN |
| Public webserver | Webserver Group | Countries you service |


## Example Local-in Policies
Note that **set action deny** is implicit, but doesn't hurt to add when you're first adding a rule.

```bash
config firewall local-in-policy
    edit 1
        set intf "Internet"
        set srcaddr "ALLOWED-IPSEC"
        set dstaddr "all"
        set action accept
        set service "IKE"
        set schedule "always"
    next
    edit 2
        set intf "Internet"
        set srcaddr "all"
        set dstaddr "all"
        set action deny
        set service "IKE"
        set schedule "always"
    next
    edit 3
        set intf "Internet"
        set srcaddr "Firewall-Allowed"
        set dstaddr "all"
        set action accept
        set service "ALL"
        set schedule "always"
    next
    edit 4
        set intf "Internet"
        set srcaddr "all"
        set dstaddr "PublicDNS"
        set action accept
        set service "DNS"
        set schedule "always"
    next
    edit 5
        set intf "Internet"
        set srcaddr "Webserver-Allowed"
        set dstaddr "Webserver Group"
        set action accept
        set service "HTTPS" "HTTP"
        set schedule "always"
    next
    edit 6
        set intf "Internet"
        set srcaddr "all"
        set dstaddr "all"
        set action deny
        set service "ALL"
        set schedule "always"
    next
end
```


To preview the policies
```bash
config firewall local-in-policy
show full
```

> Without `show full` you will not see the deny action

***

It is worth noting you should use the local-in conservatively, if you're too loose with the "all" and "always" options, you may find yourself with an inaccessible network and you'll need to console in to bring it back up!
