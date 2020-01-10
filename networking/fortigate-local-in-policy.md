# Fortigate Local-in Policy
If you enable logging notifications on IPSEC/IKE events (like failed VPN login/brute force attempts) via Log & Report > Email Alert Settings, you're going to get bombarded with notifications resulting from port scanners.  

Setting a policy rule to block them won't help, because the negotiation occurs before any firewall rule is processed.

(The notes below do not block *port scanning*, but should thwart the useless notifications you receive from their activity)

> To slow down port scanners, enable the [DoS Policy](https://help.fortinet.com/fos60hlp/60/Content/FortiOS/fortigate-firewall/Policy%20Configuration/IPv4%20DoS%20Policy.htm)

## Solution
Set a local-in policy for port 500 (used by IKE)

- The local-in policy can't be configured from the GUI and requires CLI.

## Preliminary Set-Up
Assuming you have existing IPSEC VPN tunnels already active, you're going to want to take note of the **source address** for each tunnel.

1. Make an **address group** that lists all of these source addresses, like "ALLOWED IPSEC"

In the GUI, you can do this via: Policy & Objects > Addresses > Address Group

2. Take note of the **services** you want to whitelist/blacklist

In the GUI, you can do this via: Policy & Objects > Services

## Create the Local-in Policy
Note that local-in policies are incremental.  If you don't currently have any, use the ID 1.  For the next one you create, use ID 2 and so on.  

Note that there should be a companion rule for whitelisting (rule 1 = whitelist, rule 2 = blacklist everything else)

Run the command to enter the local-in policy section of the config
```bash
config firewall local-in-policy
```

Create/edit the rule number (1 if none exist, yet)
```bash
edit 1
```

Define the zone (this is the 'friendly' name, not the zone ID).. to see available zones, run: `set intf` and hit enter.
```bash
set intf Untrust
```
(Untrust being the 'internet' zone from my setup)


Assuming you have an **Address Group** already set, of IPs or CIDRs, use that here (this would be the IPs I want to *grant access* to IKE/port 500)
```bash
set srcaddr ALLOWED-IPSEC
```

Define the destination address
```bash
set dstaddr all
```
(If you have policies already setup with restrictions to services later on in "Policy Objects," you can just set this to 'all')

Define the service(s) to be affected by this rule (The service is the 'friendly name' taken from Policy & Objects > Services)
```bash
set service IKE
```

Define the schedule (if no schedule, use always)
```bash
set schedule always
```

Set the default action (allow)
```bash
set action accept
```

Close out the policy
```bash
end
```

To preview the policy
```bash
config firewall local-in-policy
show
```

***

You should see:
```bash
config firewall local-in-policy
  edit 1
    set intf "Untrust"
    set srcaddr "ALLOWED-IPSEC"
    set dstaddr "all"
    set action accept
    set service "IKE"
    set schedule "always"
  next
end
```

Now, set up the blacklist/catchall - take note that there is no explicit deny in rule 2, it’s implicit (ie. **very dangerous** if fat-fingered and/or setting the service to something like *all*).
```bash
config firewall local-in-policy
edit 2
  set intf "Untrust"
  set srcaddr "all"
  set dstaddr "all"
  set service "IKE"
  set schedule "always"
end
```
Local in policy 2 is a companion rule required for 1 to even work.

### Adding a New IPSEC VPN Tunnel / Modifying an Existing Rule
To add IPSEC VPNs to the allow list, modify the **address group** "ALLOWED-IPSEC," append any new source VPN addresses and don’t modify this rule at all.

Easy!

It is worth noting you should use the local-in conservatively, if you're too loose with the "all" and "always" options, you may find yourself with an inaccessible network and you'll need to console in to bring it back up!
