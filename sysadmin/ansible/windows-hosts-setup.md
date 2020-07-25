# Set Your Windows Remote Hosts Location for Ansible

Create a Yaml file with info on the remote systems you'd like to manage, at `~/.ansible/hosts/test.yml`
```yaml
[winvms]
windows.example.com

[winvms:vars]
ansible_user=aduser@EXAMPLE.COM
ansible_winrm_scheme=https
ansible_winrm_transport=kerberos
ansible_connection=winrm
ansible_port=5986
ansible_winrm_server_cert_validation=ignore
```

- **winvms** are a list of machines, separated by newline
- **winvms:vars** is config override to specify any parameters you want to ensure are used

> Ansible knows to look in ~/.ansible/hosts because of the config change you did during [setup](initial-setup.md)

## Prepare the Remote Host
On the *target* machine that you want Ansible to manage, you have to enable WinRM.

The Ansible Github offers an excellent [script](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1) that will automate this for you.  Simply run it from within that machine.

I find that the defaults are a tad too generous (run in an elevated Powershell window):
```powershell
winrm get winrm/config/service/auth
```
```text
Basic = true
Kerberos = true
Negotiate = true
Certificate = false
CredSSP = false
CbtHardeningLevel = Relaxed
```

There is no reason to allow http or unencrypted auth.

Run as elevated Powershell/cmd:
```powershell
winrm set winrm/config/service/auth @{Basic="false"}
winrm set winrm/config/service @{AllowUnencrypted="false"}
```

Check it again
```powershell
winrm get winrm/config/service/auth
```

```text
Basic = false
Kerberos = true
Negotiate = true
Certificate = false
CredSSP = false
CbtHardeningLevel = Relaxed
```
Much better.

## Kerberos Setup (on the Debian/local Machine)
This will allow authentication **to** the Windows machines, via Active Directory.

This assumes all of the dependencies from the [initial setup](initial-setup.md) are all in place and ready to go.

Open Kerberos config
```bash
pico /etc/krb5.conf
```
You'll see some defaults as a helpful guide - pay attention to case/capitalization; if you stray, you will get vague errors!

Add some logging
```bash
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log
```

### Under `[libdefaults]`
If the entry already exists, modify it.  CASE is *important*!
- `default_realm = EXAMPLE.COM`
- `allow_weak_crypto = false`

### Under `[realms]`
```bash
EXAMPLE.COM = {
kdc = DC1.EXAMPLE.COM:88
kdc = DC2.EXAMPLE.COM:88
admin_server = dc1.example.com
default_domain = example.com
}
```

### Under `[domain_realm]`
```bash
.example.com = EXAMPLE.COM
example.com = EXAMPLE.COM
```

## Generate a Kerberos Ticket
CASE is *important*!
```bash
kinit adusername@EXAMPLE.COM
```
See existing tickets:
```bash
klist
```
```text
Ticket cache: FILE:/tmp/krb5cc_1000
Default principal: adusername@EXAMPLE.COM

Valid starting       Expires              Service principal
07/24/2020 16:47:24  07/25/2020 02:47:24  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 07/31/2020 16:47:18
```

***
## Troubleshooting
Some bugs I ran into.

> kinit: Cannot find KDC for realm "example.com" while getting initial credentials

Get some verbose output that might clue you in:
```bash
KRB5_TRACE=/dev/stdout kinit adusername
```

What the above problem ended up being:
```text
[realms]
EXAMPLE.COM = {
kdc = DC1.EXAMPLE.COM
kdc = DC2.EXAMPLE.COM
...
}
```
- I had to append `:88` to my **kdc** hosts:
```text
[realms]
EXAMPLE.COM = {
kdc = DC1.EXAMPLE.COM:88
kdc = DC2.EXAMPLE.COM:88
...
}
```

***
Error:
```bash
windows.example.com | UNREACHABLE! => {
    "changed": false,
    "msg": "kerberos: authGSSClientStep() failed: (('Unspecified GSS failure.  Minor code may provide more information', 851968), ('KDC reply did not match expectations', -1765328237))",
    "unreachable": true
}
```

Problem was *lowercase* of `example.com` in `/etc/krb5.conf` under `[domain_realm]`:
```text
[domain_realm]
        .example.com = example.com
        example.com = example.com
```

- Fix:
```text
[domain_realm]
        .example.com = EXAMPLE.COM
        example.com = EXAMPLE.COM
```
