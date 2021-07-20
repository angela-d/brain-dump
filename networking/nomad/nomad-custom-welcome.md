# Customizing Nomad's Welcome Screen
Adapt your welcome / about screen for Nomad Login AD based on the user's light / dark mode selection.


1. Copy the default template at:
  ```html
  /Applications/NoMAD.app/Contents/Resources/WelcomeSplash.html
  ```
  to your code editor.  Modify to suit.  If you're also deploying images, you can do a relative call: `<img src="/path/to/image.png">`

2. Inform your MDM about the destination somewhere else (don't modify the original source or you'll break the code signature and the app won't run), like `/etc/nomad-welcome/index.html` and reference such in your MDM profile under the **MenuWelcome** key: `/etc/nomad-welcome/`

3. Modify the default body css and remove:
  ```css
  background-color: rgb(236,236,236);
  ```

    Replace the above, with:
```css
@media (prefers-color-scheme: light) {
    body {
        background-color: #fff;
        color: #000;
    }
}
@media (prefers-color-scheme: dark) {
    body {
        background-color: #2b2b2b;
        color: #fff;
    }
}
```

You can also do other cool things like [embed web fonts](https://www.fontsquirrel.com/tools/webfont-generator) - just deploy them with your fileset!
