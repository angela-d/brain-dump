# Restoring the Statusbar in Firefox
Because statusbars bloat code and give users too many options, right?

### For some reason, you have to turn this on in v68+, now
userChrome.css (custom UI styles) won't work out of the box, so you have to toggle:
```stylesheet
toolkit.legacyUserProfileCustomizations.stylesheets
```
to **true**


### Restore the classic static statusbar
Brings back the behavior of the original status bar that didn't pop out and make itself known with every click or hover.

Inside the .mozilla folder I have copies of my CSS, structured similarly to how it would be on most systems (user directory/.mozilla/blabla..)
- **statusBar.css** - From [MatMoul](https://github.com/MatMoul/firefox-gui-chrome-css/blob/master/chrome/userChrome.css)
- **userChrome.css** - I like to `@import` the CSS, that way if I want to add/remove customizations, I don't have to dig through a huge CSS file looking for chunks to snip
- **userContent.css** - Not necessary for statusbar (image blobs are custom backgrounds for new page + tabs.. only noteworthy since I keep them in the same spot in this repo)

The following are all that is required to bring the status bar back:
- userChrome.css
- statusBar.css

### Detailed Instructions
For more thorough instructions on using CSS to fix Firefox and customization options, see the [CustomCSSforFx](https://github.com/aris-t2/customcssforfx) repo
