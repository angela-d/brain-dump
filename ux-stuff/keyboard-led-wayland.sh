#!/bin/bash

# only root can write the /sys/class path
if [ "$EUID" == 0 ];
then
# get all scrolllock led ids
BRIGHTNESS_PATH=$(ls /sys/class/leds/input*\:\:scrolllock/brightness)

# loop through everything matching the brightness path and light em up
for scrollnum in $BRIGHTNESS_PATH
do
  echo 1 > "$scrollnum"
  echo "$scrollnum modified"
done
else
 echo -e "$USER requires sudo permissions to: $0\\n\\tCommon problems:"
 echo -e "\\t  - Ordering in visudo command"
fi
