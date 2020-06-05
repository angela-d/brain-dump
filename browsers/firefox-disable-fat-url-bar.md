# Disable Fat URL Bar in Firefox 75+

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
