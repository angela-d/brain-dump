# Powershell Modules
PS modules are applications written by others, like pip applications in Python or Ruby Gems in Ruby.

Powershell's installation of them is a bit less straight-forward.


## Nuget Errors
Nuget is the package manager for Powershell modules.

Installing a module
```powershell
Install-Module [module name]
```

Returns:
```text
NuGet provider is required to continue
PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories. The NuGet
 provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies' or
'C:\Users\angelad\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install the NuGet provider by
running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'. Do you want PowerShellGet to install
and import the NuGet provider now?
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
WARNING: Unable to download from URI 'https://go.microsoft.com/fwlink/?LinkID=627338&clcid=0x409' to ''.
WARNING: Unable to download the list of available providers. Check your internet connection.
PackageManagement\Install-PackageProvider : No match was found for the specified search criteria for the provider
'NuGet'. The package provider requires 'PackageManagement' and 'Provider' tags. Please check if the specified package
has the tags.
...
PackageManagement\Import-PackageProvider : No match was found for the specified search criteria and provider name
'NuGet'. Try 'Get-PackageProvider -ListAvailable' to see if the provider exists on the system.
...
```

It may not say so, but this is probably related to EOL TLS versions.

Check what version is being used by Powershell:
```powershell
[Net.ServicePointManager]::SecurityProtocol
```
> SSLv3 TLSv1

Change it to TLSv1.2:
```bash
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

- Hit the up arrow and re-run the command


## Where Powershell Modules are Kept
Usefull if you want to add your own for custom scripts.

Check the environment variable:
```powershell
$env:PSModulePath
```

Locations:
```powershell
C:\Users\<username>\Documents\WindowsPowerShell\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\Windows\system32\WindowsPowerShell\v1.0\Modules
```
