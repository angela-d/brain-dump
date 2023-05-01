# Custom System Tray Icons for Weather Widget 
I found most of the Plasma weather widgets either didn't work or didn't easily have an option to use your chosen themes icons (some using font icons, instead).

Initially, I tried to symlink the icons to the plasmoid folder, but noticed KDE throwing a traversal warning and they didn't seem to take, anyway.

Simply deleting & replacing the defaults offered by the widget worked after restarting the shell.

Making a backup here, in case my changes are lost after a future widget update.

## My Setup
- Weather widget: [Plasmoid Wunderground](https://github.com/k-donn/plasmoid-wunderground)
- Icon theme: [Cyberpunk Technotronic](https://store.kde.org/p/1999292)

## How to Customize the Icons Used
The icon location for this widget is located at `~/.local/share/plasma/plasmoids/com.github.k-donn.plasmoid-wunderground/contents/icons/`

- Open that directory and simply replace any icons you want to override with your custom icons
- In my case, my icon theme's location is
`~/.local/share/icons/cyberpunk-technotronic-icon-theme/`
    - Copy & rename any in the widget's icon folder to match the widget's structure