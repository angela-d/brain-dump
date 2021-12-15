# Chrome & Firefox MDM Profiles
Automate management of the Google Chrome & Mozilla Firefox browser with MDM profiles.

My sample mobileconfigs should work in both Filewave or JAMF; edit to suit.

## Benefits Of MacOS Profiles for Google Chrome & Mozilla Firefox Browsers
GPO-like management for Macs:
- Force install browser extensions like uBlock Origin
- Block installation of unapproved browser extensions (prevent drive-by malware addons users manage to find)
- Force auto-updates and browser restart prompts to apply updates
- Prevent users from signing in on personal Google accounts (during testing, it was discovered users could sign into their personal gmail and install unapproved extensions on a managed browser!)

## Example Profile
- [Chrome-Preferences.mobileconfig](Chrome-Preferences.mobileconfig) - Forced updates via the `com.google.Keystone` namespace is at the bottom, too.  I deploy these two "profiles" as a single profile, you may or may not be able to do the same with your MDM software.
Edit to suit.

**Setting Explanations**

- [Google Knowledgebase](https://support.google.com/chrome/a/answer/2657289?hl=en&ref_topic=9027936)
- [Policy Reference](https://chromeenterprise.google/policies/) - Search values, or find policies to fit your organization


- [Firefox-Preferences.mobileconfig](Firefox-Preferences.mobileconfig)
- [Policy Reference](https://github.com/mozilla/policy-templates) - Search values, or find policies to fit your organization

## Test Your Policies
To see whether or not your policies are being applied, (after deployment) on a target machine, go to the following in the Chrome address bar:
```bash
chrome://policy
```
or Firefox address bar:
```bash
about:policies
```

:warning: **Chrome profile bugs:** you have any typo in your profile deployment (such as a string where an integer is expected), it will throw silent errors & that rule won't be processed; you'll only notice by going to `chrome://policy` on a target machine and checking for errors.
