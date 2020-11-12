# Checking Domain Controller Health
Analyze the state of the domain controllers in a forest.

Roughly 30 tests available
- `dcdiag /?` for help menu/test details
- If AD Domain Services are installed, dcdiag should already be installed, as well

Test DNS
```bash
dcdiag /e /v /test:DNS /DnsAll /f:dnstest.txt
```

Test Registration
```bash
dcdiag /test:registerindns /dnsdomain:example.com /v
```
