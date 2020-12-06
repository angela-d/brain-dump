# Unable to ADB Root Using Shell on Android Using Magisk
If Magisk is already installed and the typical `adb root` and `adb remount` sequence fails, in addition to `su -` once inside the device via `adb shell`, Magisk may be controlling it.

After installing Magisk, the option for ADB Root is **no longer** under the Android Developer Options.

## Restore ADB Root for Shell
1. Go to the Magisk app on your device
2. Click the Settings wheel (upper right corner)
3. Scroll to the **Superuser** section > **Superuser Access** is what you're looking for *to grant root over ADB*
4. To allow **shell** access over ADB, click the **shield** icon in the footer of the Magisk app > toggle the user **Shell**
5. You should now be able to run root as shell
6. Toggle off when your task is complete
