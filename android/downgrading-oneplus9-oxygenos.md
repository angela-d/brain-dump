# Downgrading Oneplus 9 Oxygen OS
After [unbricking a Oneplus 9 device](unbricking-oneplus9.md), I expected the jump from Android 11 to Android 12 to have some sort of warning - but it jumped straight to Android 13.

As there is no Lineage compatible version for Android 13 at the time of writing, this was too much of an upgrade.

**Note that downgrading this way wipes the system, so back up anything important**

1. Download the *old* system update APK from Oneplus and put it in the phone's download folder: https://oxygenos.oneplus.net/OPLocalUpdate_For_Android13.apk and install

    *This is required, otherwise you need to do it via fastboot, the same as the unbrick method*
    - Native system update app does not allow downgrading
    - If not already allowed, you'll be prompt to allow the File Manager permission to install 'unknown' apps.

2. Download the rollback package from Oneplus, [this article](https://www.rprna.com/tips-tricks/oxygenos-13-rolback-guide-update-3/) has links to rollback variants (North America, India, Europe) coming directly from Oneplus
  - Put the zip in the *device* root, not Download/update or anything like that.  The system update APK specifically looks in the system root for the rollback zip.
  - [Rollback packages to Open beta / forum thread for Android 12 to Android 11](https://community.oneplus.com/thread/1502946)

3. Reboot when prompted
  - After the 1+ / Android splash screen, there was a brief screen where Chinese text with a progress bar shown, it lasted for about 30 seconds and booted into the Oxygen OS splash screen
    - Unclear on what it said, but considering the package is sourced from Chinese manufacturer Oneplus, likely just a diagnostic message


4. Locate Build mode in Settings and tap 3-4 times to get developer mode back
