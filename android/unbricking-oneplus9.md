# Unbricking Oneplus 9
Despite having ancient phones still running strong with the latest LineageOS, Oneplus 9 is the only device that managed to brick both on it's own and during initial setup.

Both events appear to be operator error.


## Brick to Qualcomm CrashDump
1. My first (ever) brick during a LineageOS ROM install and *also* my first A/B device I'm installing Lineage to!
2. The device (seemingly) bricked on it's own during the middle of use.

    Brick Symptoms:
      - Mobile data connectivity went kaput; rest of phone operated as normal until reboot
      - Rebooting the system landed in Qualcomm CrashDump mode
      - Device was fully recoverable and is once again back in operation

**Pre-requisites (notes from brick #1)**
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
      - I should have upgraded the firmware, first!


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


***

## Notes from brick #2

- No amount of reboots got it working
- Boot into fastboot (unplug from all USB sources, hold both volume buttons down first, then begin holding power button down)
  - Device was unresponsive to any fastboot CLI command
  - Use the volume keys on the phone to select recovery mode
    - Once in Lineage recovery, I saw it was using slot b
      - *I installed the main OS, all my files etc. to slot a; hadn't done an OTA update yet, either*
      - Knowing there was no data of value on b's slot, I factory reset from the recovery menu
        - Boots right into Lineage
        - Go and turn developer mode on, since it's a new OS
        - Via CLI:
        ```bash
        adb reboot bootloader
        ```
        - Once there, make sure we can see it:
        ```bash
        fastboot devices
        ```
        - Now, check the active slot:
        ```bash
        fastboot getvar current-slot
        ```
        > current-slot: b
        >
        > Finished. Total time: 0.004s

        - Set it back to a and see what happens:
        ```bash
        fastboot --set-active=a
        ```
        - Click the power button to boot normally

        ... *I watched it and saw it clearly looped - something is wrong with slot a!*

        - After doing an OTA update, slot a was "repaired"
          Magisk app was still present, but root was lost & had to be redone

            - Not out of the woods, yet.
              After patching boot.img and going into Magisk to push it to inactive slot, a factory reset was once again required, as Android wouldn't boot (went straight into recovery)... after the reset, root was retained.

### Lessons Learned from Brick #2
- After fixing brick #1, I should have done a factory reset.
  - I think this left the b slot in limbo and I'm operating under the assumption that when I attempted to reboot the system because my alleged network issue, it freaked out about something and tried to boot into slot b; which was out of sync with a.


- My operating system of choice is Debian, Lineage's wiki explicitly states older versions of fastboot don't auto push to slot a & b simultaneously.
  - I overlooked this extremely important fact, leaving the second slot in limbo for every fastboot/fastbootd flash
    - Magisk's install instructions, too!

      Manual a/b flashing for Magisk setup (**proper** commands for older fastboot versions):
      ```bash
      fastboot flash boot_a magisk_patched-[random keystrokes].img
      fastboot flash boot_b magisk_patched-[random keystrokes].img

      fastboot flash vbmeta_a --disable-verity --disable-verification vbmeta.img
      fastboot flash vbmeta_b --disable-verity --disable-verification vbmeta.img
      ```
      - Magisk's own documentation states vbmeta flashing is optional, but it appears it's required
