# Deploying uBlock Origin with Custom Settings
[uBlock Origin](https://github.com/gorhill/uBlock) deployment via Active Directory Group Policy for Chrome, Microsoft Edge and Mozilla Firefox; with custom settings and whitelists.

My notes are for badware/malware blocking only, with the adblocking features de-selected.  If you want to keep that functionality in your deployment, be sure to adjust the options as necessary.

## Pre-deployment
Make sure you have the GPO templates installed for these browsers, first.
- [Chrome](https://cloud.google.com/chrome-enterprise/browser/download/)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge/business/download)
- [Mozilla Firefox](https://github.com/mozilla/policy-templates/releases)

Generate the settings to deploy.

1. Install uBlock Origin on Chrome to a "test" machine and configure it how you want the options to be set for your users > Apply Settings
2. On the main **Settings** tab of uBlock Origin, click the *Backup to file* button > a .txt file will be generated > open it
3. Remove everything except the components that you want to deploy to users; you will need to re-format the curly brackets (don't simply remove them)
  - For example, if you only want to customize what filter lists your users receive (badware/malware; nothing else), this is what you'll want your .txt to look like:
  ```json
  {
    "selectedFilterLists": [
      "ublock-badware",
      "ublock-abuse",
      "urlhaus-1",
      "spam404-0"
    ]
  }
  ```
4. uBlock Origin developer gorhill has a [string generator](http://raymondhill.net/ublock/adminSetting.html) that will convert this into a string for the Windows registry; the values in the *JSON-encoded settings to be used for adminSettings as a plain string value box* are what need to be used.
  - For example:
  ```json
  {"selectedFilterLists":["ublock-badware","ublock-abuse","urlhaus-1","spam404-0"]}
  ```

***

## Chrome Deployment
The registry key below is what will deploy the customizations for uBlock Origin to the Windows machines.

1. Create a GPO and begin setup:
  - Computer Configuration > Preferences > Windows Settings > Registry > right-click > New:
    - Action: `Update`
    - Hive: `HKLM`
    - Key Path: `SOFTWARE\Policies\Google\Chrome\3rdparty\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy`
    - Value Name: `adminSettings`
    - Value type: `REG_SZ`
    - Value data:  `{"selectedFilterLists":["ublock-badware","ublock-abuse","urlhaus-1","spam404-0"]}`

2. The following will force deploy uBlock Origin to Chrome installations.
  - Computer Configuration > Policies > Administrative Templates > Google > Extensions > Configure the list of force-installed apps and extensions
  - Set to `Enabled`
  - In the comment box, describe what the string IDs are for:
  ```text
  cjpalhdlnbpafiamejdnhcphjbkeiagm = uBlock Origin
  ```
  - Below, click **Show**
  - Add the following: `cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx`

  ^ The string is the identifier from uBlock origin.  The URL is the store location to install/update the extension.

## Microsoft Chromium Edge
Since this browser is force-installed on Windows, it’s worth deploying uBlock to, also.  Though I did not do a custom filter list; if you wanted to, you could follow the Chrome instructions but use the Microsoft Edge registry paths, instead.

The following will force install uBlock Origin to Edge, with default settings.

1. Computer Configuration > Policies > Administrative Templates > Microsoft Edge > Extensions > Configure which extensions are installed silently
  - Set to `Enabled`
  - In the comment box, describe what the ID string is:
  ```text
  odfafepnkmbhccpbejgmiehpchacaeak = uBlock Origin
  ```
  - Click **Show**
  - Add:
  ```text
  odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx
  ```

***

### Mozilla Firefox
Firefox's setup is a little different as it requires a local json file for custom lists.

Unlike Chrome, when you use [gorhill's](http://raymondhill.net/ublock/adminSetting.html) generator, you'll use the *JSON-encoded settings to be used for adminSettings as a JSON string value* output.

1. Using the same custom settings output as chrome, run it through gorhill's generator
2. Create `uBlockOriginConfig.json` and save it to `C:\Windows\SYSVOL\domain\Scripts` to be distributed to all domain controllers via Active Directory; with the following content:
```json
{
 "name": "uBlock0@raymondhill.net",
 "description": "ignored",
 "type": "storage",
 "data": {
    "adminSettings": "{\"selectedFilterLists\":[\"ublock-badware\",\"ublock-abuse\",\"urlhaus-1\",\"spam404-0\"]}"
 }
}
```
3. Now, create a file create GPO that points Windows to that file in your Active Directory environment and copies it to the user's local `ProgramData` directory
  - Computer Configuration > Preferences > Windows Settings > File > right-click > New:
    - Action: `Update`
    - Source file: `\\example.com\NETLOGON\uBlockOriginConfig.json`
    - Destination file: `C:\ProgramData\uBlockOrigin\uBlockOriginConfig.json`
    - [x] Readonly
    - Apply > OK
4. Add a registry key to call the JSON file you just created from the domain
  - Computer Configuration > Preferences > Windows Settings > Registry > right-click > New:
    - Action: `Update`
    - Hive: `HKLM`
    - Key Path: `SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net`
    - Value Name: [x] *(default)* (tick the default box; do not name it)
    - Value type: `REG_SZ`
    - Value data:  `C:\ProgramData\uBlockOrigin\uBlockOriginConfig.json`
5. Force install Firefox
  - Computer Configuration > Policies > Administrative Templates > Mozilla > Firefox > Extensions > Extensions to Install
  - Set to `Enabled`
  - Get the latest XPI by going to [See all versions on addons.mozilla.org](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/versions/)
  - Click **Show** > paste https://addons.mozilla.org/firefox/downloads/file/3719054/ublock_origin-1.33.2-an+fx.xpi (there may be a later version, don't copy this one; get it from the *See all versions* link above)

  ### See if the extension auto-installs
  - Go to `about:profiles` > Create a new profile and launch in a new window > check for uBlock Origin and troll its settings

  - `about:policies` also lists policy details some details about enterprise options applied


### If you don't want users able to disable or remove uBlock Origin, be sure to set the appropriate GPO for each browser!
