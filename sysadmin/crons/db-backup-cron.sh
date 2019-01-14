#!/bin/sh

LOCAL_REPO='/storage/db_backups'

# see if a vpn connection is active, i use openvpn
if [ "$(pgrep -a openvpn)" = "" ];
then

  cd "$LOCAL_REPO" && \
  GITOUTPUT=$(git pull 2>&1) && \
  cd && \
  notify-send -i git-gui "Remote Database Backup" -u critical "$GITOUTPUT"

else

  # vpn detected, abort
  notify-send -i gnome-warning "Remote Database Backup" -u critical "DB Backup failed; VPN detected"

fi
