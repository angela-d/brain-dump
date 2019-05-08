# Updates into Recovery / Firmware Upgrade Needed
When performing an OTA / over the air update on a Oneplus device, when a firmware upgrade is required it boots into recovery with no prompt or warning as to indicate why.

## Firmware Upgrade is Needed
- Check the [Changelog](https://www.lineageoslog.com/)
> require 9.0.5 firmware

There are a few methods to upgrading the firmware:
- Flash OxygenOS from recovery and *do not reboot*, flash Lineage after (too many steps)
- Extract the firmware and radios from the official Oneplus image. (easiest)

## Extracting the Firmware from an OxygenOS Image
- Download the official image from [Oneplus' Site](https://www.oneplus.com/support/softwareupgrade) for your model
- Clone and run [firmware-oneplus](https://github.com/angela-d/firmware_oneplus) by [Koenkk](https://github.com/Koenkk) (I forked it to supply a readme and also made some improvements to the extraction script; at the time of writing it hasn't had any activity in 2+ years until my commits)

Easy.

These extra steps are only required when Oneplus upgrades the firmware, these steps aren't necessary for every OTA update.
