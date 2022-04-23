# Wildcard Addresses on a Fortigate
> Support for wildcard FQDN addresses in firewall policy has been included in FortiOS 6.2.2.

Source: [Using wildcard FQDN addresses in firewall policies](https://docs.fortinet.com/document/fortigate/6.2.0/cookbook/217973/using-wildcard-fqdn-addresses-in-firewall-policies) and [Technical Tip: Using wildcard FQDN](https://community.fortinet.com/t5/FortiGate/Technical-Tip-Using-wildcard-FQDN/ta-p/196118)

1. After adding a wildcard FQDN to the Addresses panel of the firewall, they appear as unresolved until a contact attempt is made.
  >  As compared to the standard FQDNs, the wildcard FQDN does not use system DNS settings (Network -> DNS).
The wildcard FQDN is updated when a DNS query is made from a host connected to FortiGate (DNS traffic passing through a FortiGate.).
If the query matches the wildcard FQDN, the IP address is added to the cache for that object on the FortiGate.

2. To initiate the contact, SSH into the firewall and run:
  ```bash
  diagnose firewall fqdn list | grep cloudflare
  ```
  - Address entries for `*.cloudflare.com` should now be resolved

> Note that all IP addresses are assigned to that wildcard FQDN object for an unlimited time by default.
**If FortiGate is rebooted, all IP addresses has to be learned again.**

## Troubleshooting
> Some of the domains (For example., google.com) have very short TTL and resolves to different IPs for different request to implement DNS based load balance. That will result in discrepancy of the IP resolved between FortiGate and by the other host. A workaround to the problem is to set a large cache-ttl so that IP address will be saved longer even its TTL expires.

  ```bash
  # config firewall address
      edit "wildcard.google.com"
          set type fqdn
          set fqdn "*.google.com"
          set cache-ttl 86400          < -----
      next
  end
  ```
