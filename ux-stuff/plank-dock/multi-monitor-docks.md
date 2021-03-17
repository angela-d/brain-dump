# Using Plank on Multiple Monitors
I have a [new machine setup script](../new-machine-setup)

In there, I borrowed some code from [notanimposter](https://gist.github.com/notanimposter/952ec7aefad1825ee9a30cbbbc4a6453) and made some modifications to auto-detect the second monitor:

## Create a new shell script
```bash
touch plank-create && chmod +x plank-create && pico plank-create
```

Script content:
```bash
#!/bin/bash

# plank dock duplicator from: https://gist.github.com/notanimposter/952ec7aefad1825ee9a30cbbbc4a6453
newdock="dock2"
plank -n "$newdock" &
kill $!
# get the non-primary monitor
monitor=$(xrandr | grep " connected" | awk '$3 !="primary" { print $1 }')
echo "Using $monitor as monitor for $newdock"
gsettings reset-recursively net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock2/
for key in $(gsettings list-keys net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/);
do
  val=$(gsettings get net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ "$key")
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock2/ "$key" "$val"
done
gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock2/ monitor "$monitor"

# symlink dock1 to dock2
mkdir -p "$HOME"/.config/plank/dock2/
rm -rf "$HOME"/.config/plank/dock2/launchers
ln -s "$HOME"/.config/plank/dock1/launchers "$HOME"/.config/plank/dock2/launchers

# enable dock 2
current=$(gsettings get net.launchpad.plank enabled-docks)
append=$(echo "$current" | sed "s@dock1@dock1','dock2@g")
gsettings set net.launchpad.plank enabled-docks "$append"
killall plank
```

- Save it
- Run it:
```bash
./plank-create
```
