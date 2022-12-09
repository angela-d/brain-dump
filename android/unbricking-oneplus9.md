# Unbricking Oneplus 9 During LineageOS Install
My first brick during a LineageOS ROM install and *also* my first A/B device I'm installing Lineage to!

**Pre-requisites**
- ADB
- Fastboot
- [OxygenOS Full Image](https://www.oneplus.com/support/softwareupgrade/details?code=PM1617074715494)
  - Unzip
- [Payload Dumper Go](https://github.com/ssut/payload-dumper-go)
  - [Latest version](https://github.com/ssut/payload-dumper-go/releases) & unzip
  - Navigate to the directory where **payload-dumper-go** is
  ```bash
  ./payload-dumper-go OnePlus9Oxygen_22.O.13_OTA_0130_all_2111112106_03a66541157c4af5/payload.bin
  ```
    - *[path to payload_dumper_go] [path to unzipped Oxygen OS payload.bin]*
    - The extracted files are what's used for the unbricking process

**Problem**
- Ended up on Qualcomm CrashDump screen after flashing TWRP recovery
  - Lineage's instructions state third-party recovery... etc etc, which is fine; I've used TWRP on every device I've installed Lineage to and never had issues despite scary warnings.
  - TWRP was not the culprit, as [others on XDA](https://forum.xda-developers.com/t/recovery-11-official-teamwin-recovery-project.4294289/) had success.


**The culprit**
- From Lineage's install wiki:
  > Warning: This platform requires additional partitions to be flashed for recovery to work properly, the process to do so is described below.
  ```bash
  fastboot flash dtbo dtbo.img
  fastboot flash vendor_boot vendor_boot.img
  ```
    - In a rookie move, I downloaded the *latest* versions of the two above images and flashed them.  My device was on Android 11... the images were for **Android 12**


**Fix**
- [Unbrick Oneplus 9 article](https://www.droidwin.com/unbrick-oneplus-9-pro-fastboot-commands/) from Droidwin
- [This XDA thread](https://forum.xda-developers.com/t/restore-oneplus-9-to-stock-via-fastboot-commands.4265153/) covers a similar scenario, but users have some cross-platform commands that might also be useful while on Windows

**Messages encountered during the unbrick process**

```bash
angela@debian$ ~/Downloads: fastboot -w
Erasing 'userdata'                                 FAILED (remote: 'Erase of userdata is not allowed in snapshotted state')
fastboot: error: Command failed
```
  - Attempt to clear snapshot state:

  ```bash
  fastboot snapshot-update cancel
  ```

  - Result:
  > Snapshot cancel                                    OKAY [  0.003s]
Finished. Total time: 0.003s

***

Wipe everything (per the instructions):
```bash
angela@debian$: fastboot -w
Erasing 'userdata'                                 OKAY [  0.206s]
/usr/lib/android-sdk/platform-tools/make_f2fs failed with status 1
fastboot: error: Cannot generate image for userdata
  ```
  - Whatever.  Ignored this and proceeded (did not wipe at this step)
***

  > Invalid sparse file format at header magic


  - I already knew the partitions were jacked up, so I ignored this and waited for the images to process.
    It occurred on these steps, but the flash of the images were still successful:

    ```bash
    fastboot flash product product.img
    fastboot flash system system.img
    fastboot flash system_ext system_ext.img
    ```

Now, when I booted back into the OS it was stuck on the boot animation.  I waited about 5 mins, boot into fastboot > then recovery and wiped *everything* -- cache, system, files, etc.

Boot animation took about a minute the next run and then boot into Oxygen OS.

Note to self: Apparently the 'first boot' *can* take a while, but typically no more than 15 mins.

Phone was fully operational and running on it's original version of Oxygen OS / Android 11.
