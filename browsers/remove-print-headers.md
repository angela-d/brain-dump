# Remove Print Headers and Footers in Firefox
In Mozilla's continuous quest to remove user customizability, they deleted the **Page Setup** options from the File menu (which had been there for *eons*), that took the user to a graphical interface to easily remove the page numbers, URL and time from pages printed from the browser.

In modern versions of Firefox, these settings are *hidden* in `about:config`

1. In your address bar, type `about:config` and click the accept button to bypass the warning.

2. Search for `print.` - find the following settings, double-click to get a popup box to change the string value, simply delete anything that's present:
- print.print_headerleft
- print.print_headerright
- print.print_headerleft
- print.print_headerright
- print.print_footerleft
- print.print_footerright

3. Go to File > Print Preview and you should now see the header & footers empty.

Since Mozilla is now encouraging users to modify stuff in `about:config`, you should also tweak the privacy settings that are hidden in **about:config**~
- [Privacy Tools](https://www.privacytools.io/browsers/#about_config) has an excellent and easy to understand list of values to adjust to maximize your privacy while browsing.
