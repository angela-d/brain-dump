# Root for Android 12 / Lineage 19 and Android 13 / Lineage 20 on Oneplus 9

## Initial Setup
**Pre-requisites**
- Full image of the upgrade/payload.bin
  - For microG Lineage, obtain it from the [downloads](https://download.lineage.microg.org/) page
  - Unzip
- [Payload Dumper Go](https://github.com/ssut/payload-dumper-go)
  - [Latest version](https://github.com/ssut/payload-dumper-go/releases) & unzip
  - Navigate to the directory where **payload-dumper-go** is
  ```bash
  ./payload-dumper-go lineage-19.1-20221206-microG-lemonade/payload.bin
  ```
    - *[path to payload_dumper_go] [path to unzipped Oxygen OS payload.bin]*
    - The extracted **boot.img** is what's used for the patching process


1. Upload the extracted **boot.img** to the device
2. Open the Magisk app
  - Magisk > Install > Select and Patch a File > select boot.img that you uploaded to the device
3.  Once complete, you'll see a new .img, named something like `magisk_patched-22100_o0abc.img` (yours will differ, so pay attention to the filename!) > copy this **magisk_patched-22100_o0abc.img** file to your PC
4. Launch adb (`adb devices`) > load fastboot:
```bash
adb reboot bootloader
```

  - Confirm a connection to the device:
    ```bash
    fastboot devices
    ```
    > 123a1234	fastboot

5. Flash the image Magisk patched:
```bash
fastboot flash boot magisk_patched-22100_o0abc.img
```

  - Root/su is now accessible after restarting the device

# OTA Updates

Retaiting root during updates (without having to follow the initial setup steps)

Summarized from [Magisk official OTA wiki](https://topjohnwu.github.io/Magisk/ota.html)

1. Download the new OTA update from Settings > System > Updater
2. Open the Magisk app & click the big **Uninstall Magisk** button front & center
  - Select *Restore Images*

3. Wait for the installation to complete (both step 1: “installing update”, and step 2: “optimizing your device”, of the OTA)
  - Do not press the “Restart now” or “Reboot” button, yet!

4. Go into the Magisk app > Install > Install to Inactive Slot (After OTA)
5. A reboot option appears after Magisk patches the image; after rebooting, root should persist post-upgrade
