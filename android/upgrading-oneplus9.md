# Upgrading Lineage OS
Notes for upgrading major versions (LineageOS 20 to LineageOS 21) as well as OTA and Magisk notes.

My notes are based off an A/B slot device.

## Major Upgrade (Lineage 20 to 21)
Note that the firmware update is done in fastboot**d** and not fastboot; trying to run the commands in regular fastboot will yield the error:
> fastboot: error: Could not check if partition abl has slot all

 - Pop into Recovery
 - *Then* go into "fastboot" and you'll be in the fastbootd window (in Lineage Recovery, this is red colored, opposed to purple-themed)

Using the official documentation:
1. [Upgrade the firmware, if necessary](https://wiki.lineageos.org/devices/lemonade/fw_update) - was not necessary from v20 to v21
  - Oxygen Updater drops the Android 13 zip in the main folder where Ringtones, Podcast, Download, etc. folders are.
  - Drag the downloaded zip to a PC
  - Unzip
  - Run payload dumper go on it
  - Proceed with upgrade commands to flash the modem and other firmwares.


2. **Completely uninstall Magisk** from within the Magisk app; reboot
3. While still in Recovery, use the volume keys to pop back into the bootloader
4. Continue with the `adb sideload` command to upload the Lineage 21 zip.


***

## Upgrading Magisk on A/B Devices (minor upgrades - v21.1 to v21.2)
Overlooking this will uninstall root.

From [official Magisk wiki](https://topjohnwu.github.io/Magisk/ota.html):
> NOTE: In order to apply OTAs, you HAVE to make sure you haven’t modified and read-only partitions yourself (such as /system or /vendor) in any way. Even remounting the partition to rw will tamper block verification!!

- Disable **Automatic system updates** in developer options, so it won’t install OTAs without your acknowledgment.


### When an OTA Update is Available
1. Go to the Magisk app > Uninstall > Restore Images
  - **Do not reboot yet** or you will have Magisk uninstalled. This will restore partitions modified by Magisk back to stock from backups made at install in order to pass pre-OTA block verifications


2. After completing step 1, apply the OTA as you normally would (Settings > System > System Update)

3. Wait for the installation complete. Do not press “Restart now” or “Reboot” yet

4. Go to Magisk app > Install > Install to Inactive Slot, to install Magisk to the updated slot

5. After step 4 is done, press the reboot button in the Magisk app. This forces your device to switch to the updated slot, bypassing any possible post-OTA verifications

***

### Troubleshooting or Re-installing Magisk Post-Major Upgrade
If any step is missed for Magisk after an OTA, simply do a fresh patching of boot and vbmeta images and reflash:
1. Download the **full** zip of the latest upgrade from Lineage or microG Lineage (matching your existing OS)

2. Verify the sha256 hash to ensure it wasn't tampered with in transit:
```bash
sha256sum lineage-20.0-20230207-microG-lemonade.zip
```
  - Ensure it matches the hash from the downloads page and you're good to go

3. Unzip

4. Run [payload dumper go](https://github.com/ssut/payload-dumper-go) on it:
```bash
./payload-dumper-go /home/angela/Downloads/lineage-20.0-20230207-microG-lemonade/payload.bin
```
  - In payload dumper go's running directory, you'll find an **extracted** folder with a bunch of images
    - Copy **vbmeta.img** and **boot.img** to a new directory, by themselves (for ease of access)


5. Upload **boot.img** to your phone's `Download` folder via USB or adb (navigate to the directory in your terminal where `boot.img` is, first):
```bash
adb push boot.img /storage/emulated/0/Download/boot.img
```

6. Open the Magisk app and click **Install** on the top 'Magisk' card
  - Select and Patch a File
  - Select **boot.img** that was recently transferred to the phone

7. After patching is complete, download the patched boot.img back to your PC (drag via a file manager) or adb -- be sure to replace the original **boot.img** from your `magisk` folder location and ensure **vbmeta.img** is in the same directory, otherwise you'll need to specify an absolute path in your CLI command later:
```bash
adb pull /sdcard/Download/magisk_patched_[random_strings].img
```

8. Run `adb reboot bootloader` in your terminal while connected to the phone via USB

9. While in fastboot mode, run:
```bash
fastboot flash boot_a magisk_patched-[random keystrokes].img
fastboot flash boot_b magisk_patched-[random keystrokes].img
fastboot flash vbmeta_a --disable-verity --disable-verification vbmeta.img
fastboot flash vbmeta_b --disable-verity --disable-verification vbmeta.img
```
