#!/bin/bash
MY_THEME="$HOME/.local/share/plasma/desktoptheme/Dracula/icons"
BREEZE="/usr/share/plasma/desktoptheme/default/icons"
LOG_INFO=/tmp/custom-theme.txt

# reset any existing log
echo > "$LOG_INFO"

# allow stdout and log capture at the same time
function writeLog {
  # allow escaping so newlines can be added, when needed
  echo -e "$1"
  echo -e "$1">>"$LOG_INFO"
}

[ ! -e "$MY_THEME" ] && echo "$MY_THEME is invalid, enter a valid path!" && exit 1

if [ -e "$BREEZE" ];
then

    # loop through the default theme
    for ICONS in "$BREEZE"/*.svgz;
    do
        # RELATIVE_PATH will be created as a dummy file to override using the default icon set
        RELATIVE_PATH=${ICONS##*/}
        THEME_ICON=$MY_THEME/$RELATIVE_PATH

        # make sure the icon pack doesn't already exist; if so, we'll assume you want to keep & skip it!
        if [ -e "$THEME_ICON" ];
        then
            writeLog "$THEME_ICON already exists - skipped"
        else
            touch "$THEME_ICON" && echo "<svg></svg>" > "$THEME_ICON" && echo "Created dummy file $THEME_ICON successfully"
        fi
    done


else
    echo ">> Cannot find $BREEZE - fix the path and try again.  Exiting..."
    exit 1
fi

echo "About to restart Plasma..." && sleep 3

# https://askubuntu.com/a/481738
kquitapp5 plasmashell || killall plasmashell && kstart5 plasmashell

echo "DONE!"

echo -e "\n\n\n"
echo "THESE ICONS WERE NOT OVERRIDDEN:"
cat "$LOG_INFO"
echo -e "\n\n"
echo "If you wanted the above mentioned icons overriden by your custom theme, delete or rename the existing .svgz in $MY_THEME & run this script again."

exit 0