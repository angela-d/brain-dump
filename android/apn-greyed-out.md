# APN Greyed Out After Installing Lineage

My mobile service (an MVNO) was working prior to flashing Lineage, for whatever reason, it was returning "No Service" after booting into Lineage for the first time.

**Symptoms**

- No Service in title bar
- APNs could not be added or modified under Network Settings
- Physical SIM (eSIM was not tested or a part of this experiment)
- Verizon is the upstream service provider


## Troubleshooting

ADB (or a local shell app on the phone) is required for the following.

This will list APNs on the phone, if you have multiple APN profiles, you may notice `subId` value incrementing.


```bash
adb shell content query --uri content://telephony/carriers/preferapn
```

- Make note of `subId` and `numeric` values


Alot of options will show for the following:
```bash
adb shell content query --uri content://telephony/carriers/ --where "numeric='[your numeric value from preferapn output above]'"
```

Astonishingly, all of my APN data (even the values not shown in the Android GUI) were there.

Tech support at my provider suggested an app from the Play Store/Aurora Store, "MyTechSuite" which basically just pulls up the equivalent of `*#*#4636#*#*` -> Testing -> Phone information; the MyTechSuiteApp crashed on clicking 'Force Add New APN'



## Fix
---
As a test, I switched to another upstream service (which is free from my MVNO); waited for the transport notification signaling my number was moved successfully and went into APN settings - adding a new option was present!

With a non-Verizon provider (without doing any other changes, short of rebooting the device) I was able to add the MVNO custom APN settings.  Mobile service and MMS are working.
