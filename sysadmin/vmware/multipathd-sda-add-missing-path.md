# Syslog: multipathd: sda: add missing path
After an OS upgrade, the following begins to spam `/var/log/syslog`:

```text
multipathd: sda: add missing path
multipathd: sda: failed to get udev uid: Invalid argument
multipathd: sda: failed to get sysfs uid: Invalid argument
multipathd: sda: failed to get sgio uid: No such file or directory
```

## Cause
- There is no link in /dev/disk/by-id for SCSI (sdx) devices
- The OS is running as a guest on VMWare ESXI
- Source: [SUSE: no /dev/disk/by-id for scsi LUNs on VMWare ESX](https://www.suse.com/support/kb/doc/?id=000016951)

## Fix
By default VMWare doesn't provide information needed by udev to generate /dev/disk/by-id.

You can make it do so, by editing the VM's settings.

If you don't have vCenter, follow the steps from SUSE's knowledgebase.

## My notes cover the vCenter resolution
1. Ensure you have a snapshot from your NAS or SAN; a vCenter/ESXI-only snapshot may not wipe this change if you do a restore (didn't have to test it!)
2. In vCenter, power down the VM
3. Right-click the VM > Edit Settings
4. Click the **VM Options** tab
5. Under `> Advanced` > Configuration Parameters > Edit Configuration
6. Click the **Add Configuration Params** button
  - Name: `disk.EnableUUID`
  - Value: `TRUE`
7. Click OK > Save
8. Power on the virtual machine > `tail -f /var/log/syslog` and wait a bit to see if it returns (it should not)
