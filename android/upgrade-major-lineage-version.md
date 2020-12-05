# Upgrading Major Versions of Lineage on Oneplus
The OTA updater does not currently upgrade from v16 to v17, so there's a few more steps involved.

**These notes are based on a Oneplus device - if you have a different model, the steps & requirements may differ greatly; especially with regards to Magisk.**

## Pre-Upgrade
You'll want to upgrade TWRP (assuming that's how you initially installed Lineage/MicroG Lineage)
1. Backup anything important *outside of the device*!
2. [Download the latest version of TWRP](https://twrp.me/Devices/), specific to your device
3. Under **Download Links**, obtain the .img file
4. (For rooted devices only) - the [TWRP app](https://twrp.me/app/) is the easiest way to update - give it root permissions; launch the app
5. Click TWRP Flash > select your device
6. Upgrade the firmware, otherwise if you begin the upgrade and the modem checks for a later version, it will fail and tell you to upgrade the firmware anyway

Note that the TWRP app, if kept on your device, can periodically check for OTA updates - so you'd theoretically be able to skip this step, going forward.

## Upgrade
If you're running [microG Lineage](https://download.lineage.microg.org/) and not [vanilla Lineage](https://download.lineageos.org/), you'll want to stay consistent with the upgrade - don't mix versions unless you're doing a clean flash.
1. Obtain the .img from either microG or Lineage's website for your device (be sure it's the latest version you want to upgrade to)
2. Locate your device on LineageOS' wiki and [follow the custom recovery](https://wiki.lineageos.org/devices/dumpling/install) instructions

Failure to follow them accurately will result in the device sitting on the Lineage splash screen and you'll have to do a factory reset and lose your data!
- You could follow all of these instructions and still have a bootloop if you did any customizations that didn't carry over - so have an adequate backup of anything worth keeping.

## SU / root permissions on v17
Lineage has abandoned the su addon due to the breaking changes in Android 10, so [Magisk](https://www.didgeridoohan.com/magisk/HomePage) is the de facto if you want to root your device.

1. Download the [Magisk vXX .zip & Magisk Manager apk](https://github.com/topjohnwu/Magisk/releases) from the developer's Github
2. Plug a USB into the phone and use a file manager to add the .img into your *Downloads* folder
3. [Boot into recovery](boot-into-recovery.md) and head to **Install**
4. Navigate to the *Downloads* folder and select the .zip you placed there in step 2
5. Hit **Swipe to Confirm Flash**
6. Once the zip is installed, go to the "Wipe cache/Dalvik" option, select > **Swipe to wipe**, then reboot
Magisk should now be installed as soon as the phone reboots.
