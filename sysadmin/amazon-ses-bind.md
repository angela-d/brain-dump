 # Amazon SES DKIM CNAME and Bind

Adding a domain keys CNAME to Bind's DNS record wasn't as straight forward as one might think.

Amazon issues the CNAME like so:

| Type | Name | Value |
| :----: | :---: | :-------: |
| CNAME | abc123._domainkey.example.com | abc123.dkim.amazonses.com |
| CNAME | def456._domainkey.example.com | def456.dkim.amazonses.com |
| CNAME | ghi789._domainkey.example.com | ghi789.dkim.amazonses.com |

Validation continuously failed, depsite it (seemingly) being formatted properly.


## Valid DKIM CNAME for AWS SES in Bind
Example of the properly formatted bind9 record
```bash
; AWS SES
abc123._domainkey IN CNAME abc123.dkim.amazonses.com.
def456._domainkey IN CNAME def456.dkim.amazonses.com.
ghi789._domainkey IN CNAME hi789.dkim.amazonses.com.
```

Retaining the TLD after the selector is what causes it to fail validation.