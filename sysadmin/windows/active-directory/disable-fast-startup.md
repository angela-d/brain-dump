# Disable Fast Startup via Group Policy
From Microsoft's own website:

> **Windows updates might not be installed on your system** after you shut down your computer. This behavior occurs when the Fast Startup feature is enabled. This behavior doesn't occur when you restart your computer.

Source: https://docs.microsoft.com/en-US/troubleshoot/windows-client/deployment/updates-not-install-with-fast-startup

## Disable Fast Startup
In a domain controller's group policy manager:

- Computer Configuration > Preferences > Windows Settings > Registry > right-click > New:
  - Action: `Update`
  - Hive: `HKEY_LOCAL_MACHINE`
  - Key Path: `SYSTEM\CurrentControlSet\Control\Session Manager\Power`
  - Value Name: `HiberbootEnabled`
  - Value type: `REG_DWORD`
  - Value data: `0`

See if it got applied:
```powershell
gpresult /r /scope computer
```
