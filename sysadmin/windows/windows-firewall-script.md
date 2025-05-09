# Accessing Windows Firewall with Batch or Powershell Scripts

***

Lines useful for batch or powershell scripts when managing Windows Firewall remotely (using Tailscale as an example target)

## Locating a Rule

Find rules matching `Tailscale`:

> Rule Name:    Tailscale-In
>
> Rule Name:    Tailscale-In
>
> Rule Name:    Tailscale-Process



```batch
netsh advfirewall firewall show rule name=all | findstr /R "Tailscale*"
```

## Disable a Rule Matching a Targeted Name
```batch
netsh advfirewall firewall set rule name="Tailscale-In" new enable=no
```


***

## Powershell Documentation from Microsoft

https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/configure-with-command-line?tabs=powershell
