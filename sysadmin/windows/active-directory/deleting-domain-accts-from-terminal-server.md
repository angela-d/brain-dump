# Deleting Domain Accounts from a Terminal Server
Each user profile (that's not a thin client) takes up a lot of space on a Windows server.

When an employee departs, cleanup is super easy - but worth noting when deleting the users' folder from `C:\Users` - the registry key will remain.

So if you ever have another employee named `bobsmith` in the future (or if that employee is re-hired) and the, a .bak key will be generated at `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList` and the user will be logged in with a TEMP profile and warning "We can't sign into your account"

## Cleanly Purge Unneeded Local Accounts from Domain Users
The proper way to cleanup obsolete user accounts.

1. Start > Run > `sysdm.cpl`
2. Click to the **Advanced** tab
3. Under **User Profiles** > Settings
4. Select the user(s) you want to purge > Delete

Now going to `C:\Users` their directories are gone.
