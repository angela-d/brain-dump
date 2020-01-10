# Cookie Auto-Delete Doesn't Work in Waterfox or Firefox
The `about:config` setting for **privacy.firstparty.isolate** collides with Cookie Auto-Delete and prevents it from working.  Setting it to *false* regains Cookie Auto-Delete's capabilities.

***

# Noscript/Firefox > This is a privileged page, whose permissions cannot be configured.

On Firefox 60 ESR, I first ran into this garbage:
> This is a privileged page, whose permissions cannot be configured.

To get rid this nuisance, modify **about:config** settings:
```bash
about:config
```

Create the following **boolean** if it doesn't exist:

- Right-click in a vacant space > New > boolean
- Enter preference name:
```bash
privacy.resistFingerprinting.block_mozAddonManager
```

Enter boolean value:
- Select **true**

Also **empty** the following (choose yourself what to whitelist):
```bash
extensions.webextensions.restrictedDomains
```

***

This appears to be a "hidden" setting meant for Tor, according to the extensions API:
```cpp
static bool IsValidHost(const nsACString& host) {
  // This hidden pref allows users to disable mozAddonManager entirely if they
  // want for fingerprinting resistance. Someone like Tor browser will use this
  // pref.
  if (Preferences::GetBool(
          "privacy.resistFingerprinting.block_mozAddonManager")) {
    return false;
  }
```

```text
https://dxr.mozilla.org/mozilla-central/source/toolkit/mozapps/extensions/AddonManagerWebAPI.cpp
```
