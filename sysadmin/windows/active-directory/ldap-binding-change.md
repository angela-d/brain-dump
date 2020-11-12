# LDAP Secure Signing Warnings
All of the following info is obtainable from [Microsoft](https://docs.microsoft.com/en-us/archive/blogs/russellt/identifying-clear-text-ldap-binds-to-your-dcs), but copying to my notes, as MS tends to delete stuff.

Event viewer log:
> During the previous 24 hour period, some clients attempted to perform LDAP binds that were either:
(1) A SASL (Negotiate, Kerberos, NTLM, or Digest) LDAP bind that did not request signing (integrity validation), or
(2) A LDAP simple bind that was performed on a clear text (non-SSL/TLS-encrypted) connection
>
>This directory server is not currently configured to reject such binds.  The security of this directory server can be significantly enhanced by configuring the server to reject such binds.  For more details and information on how to make this configuration change to the server, please see http://go.microsoft.com/fwlink/?LinkID=87923.
>
> Summary information on the number of these binds received within the past 24 hours is below.
>
> You can enable additional logging to log an event each time a client makes such a bind, including information on which client made the bind.  To do so, please raise the setting for the "LDAP Interface Events" event logging category to level 2 or higher.
>
> Number of simple binds performed without SSL/TLS: xx
Number of Negotiate/Kerberos/NTLM/Digest binds performed without signing: xx

## How to Find What Hosts are Connecting Insecurely
To find what systems are connecting in plaintext, turn up the logging options for the LDAP Interface Events and wait for a connection:
- Open an elevated command-prompt and run:
```bash
Reg Add HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics /v "16 LDAP Interface Events" /t REG_DWORD /d 2
```

This will **generate 'basic' logs of LDAP connections**, showing the IP of the connecting host, as well as the user.

- Chances are, this is going to generate a *lot* of logs, so **toggle it off** when you're done researching:
```bash
Reg Add HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics /v "16 LDAP Interface Events" /t REG_DWORD /d 0
```

The linked Microsoft blog offers a [pre-made Custom Views template](ldap-binding-change-custom-view.xml) to add to your Custom Views to show an easily-accessible grouping of these messages. (Import it to the Event Viewer)

Repeat for all domain controllers.

## Fix the Offending Hosts
- Assuming you already have DC certificates setup, change the connection port to `636` or `ldaps:\\` (depending on application)
- Some applications may have a toggle for `Secure Connection`
