# Disable Fat URL Bar in Firefox 75+

### Update for 78+
You can sort of disable this monstrosity, but if you use any of the "features" of the URL bar, you're SOL.

The first flag does not exist, so you must create it.

- In the browser's address bar, go to `about:config`
- "Search" for `browser.urlbar.disableExtendForTests` and tick **Boolean** > + to save
- Search for `browser.urlbar.maxRichResults` > adjust from `10` to `0`

If you've previously opt out of their telemetry (like me) it may  be time to reconsider.  Mozilla does *not* listen to complaints from beta testers or daily users, perhaps they may listen to telemetry feedback if you allow them to capture technical data and they see these flags being used.

If you do decide to allow the technical data to be captured, be sure to **un-tick** the studies garbage, which re-enables itself when you re-activate the technical telemetry.

### Update June 4, 2020
Mozilla has decided you no longer need the option to disable this eyesore, as of Firefox v77 you cannot disable this 'feature' via about:config.

Your options:
- 'Upgrade' to [Firefox ESR](https://www.mozilla.org/en-US/firefox/enterprise/) (*Upgrade* because this is a slow-ring release; feature "upgrades" don't get pushed to it until months after it hits the primary release; ESR receives security patches regularly, though.)  Inevitably, this garbage will make its way into ESR.
- Use [userChrome.css](https://invidio.us/watch?v=omogB3odJAg) to disable the "megabar"


### Options for versions under v77
*Does not work for v77+*

If you want to disable the fat URL bar / pop out bar "feature" nobody asked for:

- In the browser's address bar, go to `about:config`

Find the following settings and adjust accordingly (double-click to toggle true/false if **boolean** is selected at the bottom):
- `browser.urlbar.openViewOnFocus` set to `false`
- `browser.urlbar.update1` set to `false`
- `browser.urlbar.update1.interventions` set to `false`
- `browser.urlbar.searchTips` set to `false`
