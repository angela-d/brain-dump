# Automating Let's Encrypt Wildcard Certificates for Enterprise Distribution
The following is ideal for scenarios where you have an authoritative bind server *and* an internal/non-public system that's used to distribute SSL certificates to internal/non-public/private IP sites.

Topology:
- **Bind Server** - The authoritative (public facing) DNS server for your TLD that will carry the wildcard.  I'm using **example.com** in these notes.
- **Distribution Server** - The intranet server that generates, accepts and disperses the certs (the latter part isn't part of these notes at this time)

Operating Systems in Use:
- Bind Server: Ubuntu 16.04
- Distribution Server: Debian 9


***

### On the Bind Server
`dnssec-keygen` is part of Bind-Utils, so it should already be installed if you're running BIND9.

Create a key:

**On Ubuntu 16.04, generating a key with dnssec-keygen will take forever.  Using /dev/urandom will significantly speed up the process.  Run this as a non-root / non-sudo user.**
```bash
dnssec-keygen  -r /dev/urandom -a HMAC-SHA512 -b 512 -n HOST example.com
```
*The host makes sense to be the actual host you're using, but it appears it will take "certbot" type names, also.*

That will create a keypair in the following conventions:
- Pubkey: Kns.example.com.+165+12345.key
- Private Key: Kns.example.com.+165+12345.private

To view the content of the keys (which you'll need to modify the upcoming config):
```bash
cat Kns.example.com.+165+12345.key
```

In `/etc/bind/named.conf`, add:
```bash
key "example.com" {
  algorithm hmac-sha512;
  secret "asd.....re==;
};
```

Find the root zone file for example.com:

`cd /etc/bind && grep "example.com" -R ./`

(`/etc/bind/named.conf.local` in most cases)

Under the zone entry for example.com, before:
> zone "example.com" {
>
> type master;
>
> file "/etc/bind/db.example.com";
>
> };

*The **file** path may vary, depending on who set up the system, originally.  Modify it to suit your environment.*

After, adding acme challenges needed by Certbot/Let's Encrypt:
```bash
zone "example.com." IN {
  type master;
  file "db.example.com";
  update-policy {
  grant example.com name _acme-challenge.example.com. txt;
  };
};
```

If this server is running Apparmor, you'll run into some issues, out of the box:
> ns kernel: [11277.173074] audit: type=1400 audit(123456.021:45): apparmor="DENIED" operation="mknod" profile="/usr/sbin/named" name="/etc/bind/db.example.com.jnl" pid=5396 comm="named" requested_mask="c" denied_mask="c" fsuid=110 ouid=110

To fix/prevent the Apparmor permissions issue, whitelist named for writing the journal file:
```bash
pico /etc/apparmor.d/local/usr.sbin.named
```
Append the following:
```bash
/etc/bind/db.example.com.jnl rw,
```

After that, you will still likely run into:
> ns named[4193]: /etc/bind/db.example.com.jnl: create: permission denied

Let's look at the current permissions of `/etc/bind`:
```bash
ls -l /etc/ | grep bind
```
> drwxr-sr-x 3 root bind 4096 May 10 13:11 bind

*Group* doesn't have write permissions, hence the above error.

Since Bind will need to write to a file that doesn't currently exist, the path of least resistance is mildly weakening the security and granting it to all of `/etc/bind`:
```bash
chmod g+rw /etc/bind/
```

Check the permissions again:
> drwxrwsr-x 3 root bind 4096 May 10 13:11 bind

Changes to the **Bind Server** are now complete.

***

### Modifications to the Distribution Server
This server ideally shouldn't be public facing and secured behind a firewall with no external access.

Install the backports repo so we get the latest version of certbot
```bash
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list && apt update
```

Install dependencies:
```bash
apt install certbot python3-certbot-dns-rfc2136 -t stretch-backports
```

Create a config file that will be used by Certbot:
```bash
mkdir -p /root/.secret/certbot && pico rfc2136.ini
```

Paste the following into `rfc2136.ini`
```bash
# Target DNS server
dns_rfc2136_server = # "Bind Server" IP
# Target DNS port
dns_rfc2136_port = 53
# TSIG key name - this is what you named the key while running dnssec
dns_rfc2136_name = example.com
# TSIG key secret
dns_rfc2136_secret = asd.....re==
# TSIG key algorithm
dns_rfc2136_algorithm = HMAC-SHA512
```

*Note: If you will be running the following for the first time, append a `--dry-run` flag; you're limited to 5 cert calls per week - don't waste them on testing!*

Obtain a new cert from Let's Encrypt:
```bash
certbot certonly --dns-rfc2136 --dns-rfc2136-credentials /root/.secrets/certbot/rfc2136.ini -d example.com,*.example.com --preferred-challenges dns-01 --dns-rfc2136-propagation-seconds 5
```

You should now have a wildcard SSL certificate from Let's Encrypt!

To automate, build a cron at `crontab -e` (as root/sudo) with **certbot renew**
