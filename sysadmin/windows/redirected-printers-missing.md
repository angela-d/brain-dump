# Redirected Printers Missing from Terminal Server
A situation arose where a needed printer wasn't appearing and there was inconsistency when testing multiple users.

Every printer but the one needed was being redirected.


## Cause
From Event Viewer (on the terminal server):
> The number of printers per session limit was reached. The following print queue was not created ...

- Event ID 1124

## Fix
Add the registry key **MaxPrintersPerSession** (DWORD (32-bit) to `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services`

Default is 20

- After setting the **MaxPrintersPerSession** have the user log out and log back in (simply disconnecting will not build a new session with the updated key activated)
