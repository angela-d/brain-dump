# Disabling Android 9/Lineage System Apps
Alot of the system apps on Android are garbage.  Even on Lineage, the Camera app *requires* voice permissions even to take a simple photo.
I've replaced most of my system apps with [Simple Mobile Tools](https://www.simplemobiletools.com/) from F-Droid.

Some apps have a disable button in the app settings, many do not.  So they'll constantly run in the background and interfere when unwanted (like Gallery)

Requirements:
- Phone connected to PC via USB
- ADB

In the terminal, launch a shell connection to the phone and list *all* apps:
```bash
adb devices && adb shell 'pm list packages -f'
```

You'll get a giant list of stuff that looks like:
> package:/system/app/embms/embms.apk=com.qualcomm.embms
>
> package:/system/priv-app/ContactsProvider/ContactsProvider.apk=com.android.providers.contacts
>
> package:/system/app/CaptivePortalLogin/CaptivePortalLogin.apk=com.android.captiveportallogin

The filename after `apk=` is what's worth paying attention to: `com.android.providers.contacts`

You can also get the filename on Android 9 / Lineage 16 by going to Settings > Apps & notifications > See all xx apps > click the 3 dots at the upper-right corner > find the app you want to see > Advanced > at the very bottom you'll see the filename path.

Disable the apps you don't want:
```bash
adb shell pm disable-user --user 0 com.android.gallery3d
adb shell pm disable-user --user 0 com.android.documentsui
adb shell pm disable-user --user 0 org.lineageos.snap
```

It doesn't uninstall them (no reason to, you can't reuse the space!) so if you find disabling them causes issues, just re-enable:
```bash
adb shell pm enable [package filename to enable]
```

## Do Not Disable
The contacts app default in Lineage is garbage, but disabling it will not allow another app to take precedence and will make save contacts disappear until it is re-enabled.  

The only way I've found to override its grip, is to first disable:
```bash
adb shell pm disable-user --user 0 com.android.providers.contacts
```

And then try to add a contact (No app found) warning should show.  Re-enable the app through Settings > Apps & notifications > Contacts: Enable.  Try to edit the contact now, you should have a prompt asking you to choose a default app.  From here, you can select Simple Mobile Tools' Contacts app. (Prior, no prompt would show)

The contacts database is still inaccessible, so re-enable the turd:
```bash
adb shell pm enable android.providers.contacts
```

And just never use it.  It will still show in the app drawer but won't pop up when managing contacts after selecting a better app to manage your contacts.
