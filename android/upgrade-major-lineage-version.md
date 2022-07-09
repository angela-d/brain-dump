# Upgrading Major Versions of Lineage on Oneplus
The OTA updater does not currently upgrade from v18 to v19, so there's a few more steps involved.

:warning: The upgrade steps deviate between versions with changes to Android and su/Magisk.  I tend to update my notes after each change I've run into. (v17 to v18 and v18 to v19 used exactly the same ugprade approach)

**These notes are based on a Oneplus device - if you have a different model, the steps & requirements may differ greatly; especially with regards to Magisk.**

While upgrading this method, I did not lose any apps or data.  Your mileage may vary.
- Things like Magisk of course, lost its capability and needed to be re-patched
- F-Droid, Aurora and app settings made it through without issue

## Pre-Upgrade
You'll want to upgrade TWRP (assuming that's how you initially installed Lineage/MicroG Lineage)
1. Backup anything important *outside of the device*!
2. [Download the latest version of TWRP](https://twrp.me/Devices/), specific to your device
3. Under **Download Links**, obtain the .img file
4. Press & hold the phone's power button > Restart > Recovery (if the latter isn't available, after Developer Mode is enabled, enable *Advanced Restart*)
5. Once in TWRP: select **Install** > navigate to where the image was saved to on the device (it won't appear, yet) > select **Flash Image** > select the .img most recently saved > select **Recovery** > reboot the phone when complete
6. [Upgrade the firmware](https://github.com/angela-d/firmware_oneplus); otherwise, if you begin the upgrade and the modem checks for a later version, it may fail and tell you to upgrade the firmware anyway

## Upgrade
If you're running [microG Lineage](https://download.lineage.microg.org/) and not [vanilla Lineage](https://download.lineageos.org/), you'll want to stay consistent with the upgrade - don't mix versions unless you're doing a clean flash.
1. Obtain the **.zip** from either microG or Lineage's website for your device (be sure it's the latest version you want to upgrade to)
2. Locate your device on LineageOS' wiki and [follow the upgrade](https://wiki.lineageos.org/devices/cheeseburger/upgrade) instructions

Failure to follow them accurately will result in the device sitting on the Lineage splash screen and you'll have to do a factory reset and lose your data!
- You could follow all of these instructions and still have a bootloop if you did any customizations that didn't carry over - so have an adequate backup of anything worth keeping.

## SU / root permissions on v19
Lineage has abandoned the su addon due to the breaking changes in Android 10, so [Magisk](https://www.didgeridoohan.com/magisk/HomePage) is the de facto if you want to root your device.

After upgrading from v18 to v19, root/su was gone (as expected) - The app was still present, so skip steps 1-2 for typical upgrade situations.

1. Download the [Magisk apk](https://github.com/topjohnwu/Magisk/releases) from the developer's Github
2. Plug a USB into the phone and use a file manager to add the .apk into your *Downloads* folder > click on it to install
3. Unzip the Lineage/microG zip from step 2 of **Upgrade** steps and look for **boot.img** > Put it in your phone's **Download** folder, so Magisk can patch it
4. Open the Magisk app on your phone > you'll see two panels: Magisk and App (heed the warnings on the [developer's install notes](https://topjohnwu.github.io/Magisk/install.html) about ramdisk) -- if your phone has ramdisk (like mine!), my notes may apply to you.. click **Install** on the Magisk panel > select **Choose and Patch a File** > navigate to where you put *boot.img* and select it
5. Once complete, you'll see a new .img, named something like `magisk_patched-22100_o0abc.img` (yours will differ, so pay attention to the filename!) > copy this **magisk_patched-22100_o0abc.img** file to your PC
6. Launch adb (`adb devices`) > load fastboot:
```bash
adb reboot bootloader
```

  - Confirm a connection to the device:
    ```bash
    fastboot devices
    ```
    > 123a1234	fastboot

7. Flash the image Magisk patched:
```bash
fastboot flash boot magisk_patched-22100_o0abc.img
```

  - Root/su is now accessible after restarting the device
