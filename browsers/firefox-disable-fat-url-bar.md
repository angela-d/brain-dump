# Disable Fat UR: Bar in Firefox 75
If you want to disable the fat URL bar / pop out bar "feature" nobody asked for:

- In the browser's address bar, go to `about:config`

Find the following settings and adjust accordingly (double-click to toggle true/false if **boolean** is selected at the bottom):
- `browser.urlbar.openViewOnFocus` set to `false`
- `browser.urlbar.update1` set to `false`
- `browser.urlbar.update1.interventions` set to `false`
- `browser.urlbar.searchTips` set to `false`
