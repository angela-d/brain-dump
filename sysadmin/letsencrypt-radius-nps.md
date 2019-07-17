# Let's Encrypt SSL with Radius NPS & GPO
In environments with BYOD (bring your own devices), self-signed SSL certificates for Radius NPS wifi are not ideal; users not receiving a GPO with the auto-enrolled certs will be prompt about an insecure certificate when connecting to wifi.

Utilizing a [wildcard Let's Encrypt cert](automating-letsencrypt-wildcard.md) can fix that.

**The following assumes you have already obtained the wildcard cert from Let's Encrypt**

If you obtained the wildcard cert on a Linux machine and need to convert to pfx for importing to a Windows Active Directory domain controller, you can do so easily, with OpenSSL (on the origin Linux machine):
```bash
openssl pkcs12 -export \
-out /home/angela/ssl/wildcard-certificate.pfx \
-inkey /etc/letsencrypt/live/example.com/privkey.pem \
-in /etc/letsencrypt/live/example.com/cert.pem \
-certfile /etc/letsencrypt/live/example.com/chain.pem
```
You'll be prompt to create a password, which will be used to import it on the Windows AD DC server.

Once you have the **wildcard-certificate.pfx** ready to go, you can connect to a network share to get it on the Windows machine:
```bash
smb://dc3.example.com/c$/Shared
```


### Manual Import of the PFX Cert
After exporting from the .pem and placing the generated PFX cert into the Windows machine, simply double-clicking it and allowing the installer to place it where it needs to be.

*If imported into multiple machines and one machine isn't allowing the key to move around, export it with the private key from an operable server and re-import into the other server.*

### Extracting the Root CA's for a GPO
Setting a GPO to push the trusted certs to domain-joined devices will prevent the user from having to explicitly accept & trust the certificate.  BYOD devices will still have to, but they will see a *trusted* certificate and not an invalid/self-signed cert.

- First, open the mmc.exe snap-in > Add New Snap-In > Certificates > Local Computer
- Open Certificates and browse to **Trusted Root Certification Authorities**

Export 2 roots: **DST Root CA X3** and **Let's Encrypt Authority X3**
- Right-click DST Root CA X3 > All Tasks > Export > Next > tick Base-64 encoded X.509 (.CER) > Next > Browse.. select a location on the desktop and name it dstroot > Save > Next > Finish
- Repeat the above steps for *Let's Encrypt Authority X3*, but choose a different filename

### Push the Let's Encrypt Certificate via Group Policy
If you don't already have a specific GPO for Let's Encrypt, create one; rather than using the Default Domain Policy.  I titled mine **LetsEncryptSSL**

1. Administrative Tools > Group Policy Management > right-click example.com → Create GPO & Link it here, or select "LetsEncryptSSL" GPO
2. Right-click "LetsEncryptSSL" GPO > Edit > Computer Configuration > Policies > Windows Settings > Security Settings > Public Key Policies > Trusted Root Certification Authorities
3. Add a new cert: Right-click > import > select the two certs from the desktop

### Ensure Windows Clients Validate Using the Right CA
In the GPO where you have Wireless Network  (IEEE 802.11) Policies set (check Default Domain Policy if there isn't a clearly-named GPO):
- Administrative Tools > Group Policy Management > right-click & Edit the GPO
- Computer Configuration > Policies > Windows Settings > Security Settings > Wireless Network  (IEEE 802.11) Policies > right-click your profile(s) > Properties
Select SSID(s) > Edit > Security tab > Beside Microsoft: Protected EAP (PEAP), click Properties > select DST Root CA X3

That's it.

### Force Group Policy Updates
To prevent having to wait for GPO propagation, you can force it on the client machine (optional).

Mac machines (via Centrify):
```bash
sudo adflush && adgpupdate
```

Windows machines:
```bash
gpupdate /force
```

Now, both (domain-joined) Windows & Mac clients can connect to Radius NPS wifi without any sort of certificate prompts.

### Non-domain Joined Macs
For a BYOD Mac user, when they receive the certificate prompt, they can hit "Show Certificate" > Trust > set to "Always Trust" -- now they won't be prompt, for as long as you use this cert.  The downside is with every subsequent cert (since Let's Encrypt certs expire after 90 days) they will have to go through and re-trust after every renewal.
