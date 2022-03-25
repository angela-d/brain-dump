# Make Windows 11 Work on vCenter / VMWare ESXI
Setup and create the VM from the .iso like you would any other Windows version, but before you boot, be sure to set to BIOS firmware.
The following is working as of 3/24/22

Before you power the Windows 11 VM on, in vCenter or ESXI:
1. Right-click > Edit Settings
2. (in vCenter) Click the VM Options tab
3. Expand Boot Options
4. Change the Firmware pull-down to BIOS


Turn the VM on and continue normally:
- You'll eventually get to "This PC doesn't meet the minimum requirements to install this version of Windows."
- Make sure 'Enforce Keyboard' is on and that you're not inside of another VM while running the vCenter or ESXI setup window
- Hit Shift + F10 and command prompt will launch
- Run the following, to create the necessary registry keys to bypass the minimum requirements message:
  ```bash
  reg add HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig
  reg add HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig /v ByPassTPMCheck /t REG_DWORD /d 1 /f
  reg add HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig /v BypassSecureBootCheck /t REG_DWORD /d 1 /f
  exit
  ```
- Click the red X and restart the installation process
