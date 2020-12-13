# De-googling Android with Lineage OS
Android is a lot cooler without Google's spyware hooked into everything.

There are many ways to de-google a phone, install Lineage (or even [LineageOS for microG](https://lineage.microg.org/)), this is how I've done it (steps taken from my personal note stash and updated/sanitized to be device agnostic).

### Worth Noting
Lineage does not have Google apps out of the box, that means no app notifications, with the exception of those that built without Play Store dependencies.

If this important to you, you can install GAPPs after, or use [LineageOS for microG](https://lineage.microg.org/) to "spoof" the Play Store and only leak intermittent info (like your IP address and push notification content) to them.


## Initial Setup
- Make sure your [phone](https://wiki.lineageos.org/devices/) can run Lineage OS. **Do not mix and match models.  If you use the wrong ROM, even if it's the same model/manufacturer, with a slight variation, you'll brick your phone.**
- Unlock your bootloader (check the manufacturer's site of your device for specific details on how to do it; some require software to be downloaded and used to unlock)
- Install [ADB](https://www.xda-developers.com/install-adb-windows-macos-linux/) to your PC to manage the phone with a command-line interface. (ADB is a tool made and maintained by Google)
- Custom recovery will have to be set up.  Make sure your phone is compatible with [TWRP](https://twrp.me/Devices/) and then install it (click on the device name for instructions).
- [Download Lineage OS](https://download.lineageos.org/) **or** [LineageOS for microG](https://lineage.microg.org/) .zip for your device.


Assuming your bootloader is now unlocked, begin:
- Load the Lineage OS zip onto an SD card inside the phone. (Attach it to a USB to the PC > if it defaults to charge mode, switch to **Transfer File** mode and navigate to the SD card; usually by selecting the phone as a mounted drive from the PC's file manager > sdcard1 > drop the .zip somewhere.)
- Boot into recovery mode. **Power up+down & volume down button. Press volume up+down first; hold it for a few seconds and then press the power up button.**
- Once greeted by the TWRP warning page, you must **Swipe to Allow Modifications**

Once you're in TWRP:

![TWRP](../img/twrp.jpg)
- Select **Wipe** > **Flash** (this will delete the OEM Android ROM, but not the .zip you put onto the SD card)
- Tap Advanced Wipe and you'll get a menu with checkboxes, select the following:

[x] Dalvik / ART Cache
[x] System
[x] Cache

Leave everything else unchecked.

- Perform the Swipe to begin the erasure.
- Once complete, return to the main menu (screenshot above) > Select **Install**
- Follow the menu into the SD card and find the Lineage zip you placed there earlier and select it
- Don't select *Zip signature verification* (assuming you've already done this while initially downloading the zip) - this option causes some installs to fail.
- **Swipe to Confirm the Flash**
- Once complete, you'll be given the options: Wipe cache/dalvik or Reboot System. **Reboot** and you're done.

***
## (optional) Root Lineage
Don't root unless you understand the security implications and/or you:
- Install random apps
- Install tons of apps (each app increases risk)
- Are not security conscious

A rooted device gives apps access to your entire phone, essentially.  One rogue app and your entire device is a portable virus.

For experienced users, or with a little care and research you can greatly limit the attack vector and gain *complete* access to your device.

### To root:
As of Android 10 / Lineage 17, [Magisk](upgrade-major-lineage-version.md#su--root-permissions-on-v17) is pretty much the standard for rooting on Android.

### Enable Root for Apps
- Enable developer options.  In most devices: Settings (wheel icon at the top) > About phone > look for the build number and tap about 3 times, you'll get a prompt once developer options are enabled.
- Go back to **Settings** > **Developer options** > **Root Access**

You'll see the following options:
- Disabled (Use when you want to undo Root, but don't want to remove the capability)
- Apps only (Only apps have root access)
- ADB only (Only the ADB CLI can perform root functions)
- Apps and ADB (Self explanatory)

**Note:** If the above options aren't where they should be, [Magisk may have taken them over](adb-no-root-magisk.md)

### Install Apps and App Stores
- [F-Droid](https://f-droid.org/packages/org.fdroid.fdroid.privileged.ota/) - Open source apps.  Follow the instructions on the F-Droid page.
- [Aurora Store](https://f-droid.org/en/packages/com.aurora.store/) - You can install the Aurora Store from within F-Droid.  This gives you access to the **free** apps in the Play Store, without needing Google crap on your phone.  You will still have to connect to Google's services in order to get the apk's for Android to install, so if you're adverse to touching Google in any sort of way, use a VPN while utilizing Aurora, or avoid Aurora.  Aurora gives you 'fake' Google accounts, so you do not need to give those turds any of your own data, aside from the IP address they'll see when Aurora grabs the apk for you.

### Secure Your Phone
- [AF Wall](https://f-droid.org/en/packages/dev.ukanth.ufirewall/) (requires root) is a substantially thorough firewall.  Once installed, block everything by default and trial-and-error what truly needs access.  Warning: For whatever reason, the Linux kernel hammers web access and I've yet to find a reason for this.  Android being Google at the core, one can only suspect this is some unsavory occurrence.  I've had it blocked for 2+ years without adverse reaction; Lineage and all apps update (when I want them to).

Apps like music players, note taking apps and calendars *don't* need web access (if you have local mp3s on your phone) and I find most apps hammer the web trying to send analytic data to the mothership, cycle ads, or whatever creepy data the app development companies want in exchange for giving you 'free' apps; even with the "don't send diagnostic data to developers" checked.  

Apps like *period trackers* have been caught siphoning users' personal data.

If your apps can function without syncing or accessing the web, you're better off to lock them all down.  On the plus side, you won't see any ads in them, either!

AF Wall has a neat log that will show you how many times a blocked app tried to access the web.

![AF Wall](../img/af-wall.png)

- [DNS 66](https://f-droid.org/en/packages/org.jak_linux.dns66/) gives you the capability to use DNS servers, other than your ISPs while on mobile data.  It also offers host files, but I prefer to uses a hosts file that's inside the device, rather than a software-based filter.
- For SMS/text messaging, [Signal](https://signal.org/) can be set to your default texting app.  Caveat: They route through AWS/Amazon.. and you really only maximize your privacy if your txt recipient also uses Signal.  If they do not, your messages will be sent unencrypted/through your cell provider.
- [Fennec Browser](https://f-droid.org/ru/packages/org.mozilla.fennec_fdroid/) which allows you to install (a few) additional privacy extensions!  Caveat: Fork of Firefox
- Irregardless of Fennec/Firefox choice, a list of things to disable (neither browser is perfect): [Disable WebRTC](https://www.privacytools.io/#webrtc), [Integral Privacy Add-ons](https://www.privacytools.io/#addons)
  - **uBlock Origin is a necessity and works on even the garbage versions of Firefox Mobile (v68+)**
- Instead of swiping the browser away when you're done with it, click the three dot hamburger menu ... and go to **Settings** > **Privacy** > Tick **Do not track** and > **Clear private data on exit** > a prompt will pop up -- tick everything for maximum privacy.  When you close out a browsing session, click the ... and scroll to the very bottom > **Quit** - if you close any other way, 'Exit' is not triggered, so the Clear private data on exit options aren't executed.


### Unintended Network Connections to Google
Network connections often overlooked
- [Captive Portal](https://www.kuketz-blog.de/android-captive-portal-check-204-http-antwort-von-captiveportal-kuketz-de/) - [My captive portal notes](wifi-no-internet.md)
- [Most Push notifications (app dependent)](https://forum.f-droid.org/t/push-notifications-without-google/6010) (even if you use [microG](https://microg.org))
- [NTP / Time Servers](custom-time-server-lineageos.md)
- [This thread](https://old.reddit.com/r/fossdroid/comments/clg2ca/how_to_degoogle_lineageos_in_2019_xpost/) covers DNS, GPS, AOSP Webview and other services built-in


### Ad Blocking
Easy:
- Use [Fennec F-Droid](https://f-droid.org/en/packages/org.mozilla.fennec_fdroid/) - Firefox fork with telemetry stripped; install [uBlock Origin add-on](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - Only blocks ads while web browsing

Advanced:
- [System-based hosts file](updating-hosts-file.md)
  - Blocks ads in apps, as well as while web browsing; but does not auto-update

***
# Useful Commands
### View Logs
View an output of Android's logs
```bash
adb logcat -C
```

Search for something specific in the logs; having an issue with wifi?
```bash
adb logcat -C | grep wlan0
```
(Substitute wlan0 for whatever you want to search for in the logs) - grep may or may not work on Windows.  I've only used adb commands on a Linux machine.

*CNTRL + C keyboard combo to quit the log.*

### Download a File from the Phone to Your Computer
This is only useful in situations where you don't want to use the file manager of your computer and/or the directory isn't already mounted as read+write.
```bash
adb pull /path/on/phone /path/to/pc
```

### Push a File to the Phone from Your Computer
```bash
adb push /path/to/pc /path/on/phone
```

### Troubleshooting
On Linux/Mac systems, you can launch the manpage to get a list of commands available.
```bash
man adb
```

While the manpage is open, you can search for a word/phrase by utilizing a forward slash/phrase, like so:
```bash
/searchterm
```
And `q` to exit rhe search and/or manpage.

You can also install Lineage to [Raspberry Pi](https://www.maketecheasier.com/install-lineage-os-on-raspberry-pi/)
