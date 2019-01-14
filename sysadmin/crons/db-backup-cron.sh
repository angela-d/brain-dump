#!/bin/sh

# path to your local repository
LOCAL_REPO='/storage/db_backups'

# specify a timeout for ssh-agent to live in seconds; otherwise its forever
TIMEOUT='150'

# specify which private key to use (the pubkey should already be in ~/.ssh/authorized_keys on the remote server)
# as well as the fingerprint stored locally in known_hosts (do a manual pull the first time you set this up)
# note that if you have a password on your key, it'll bungle this script up unless you add additional processing for the pw
USEKEY='~/.ssh/your_private_key'

# see if a vpn connection is active, i use openvpn
if [ "$(pgrep -a openvpn)" = "" ];
then

  cd "$LOCAL_REPO" && \
  ssh-agent bash -c "ssh-add -t "$TIMEOUT" "$USEKEY"; git pull 2>&1" && \
  cd && \
  notify-send -i git-gui "Remote Database Backup" -u critical "Weekly backup complete, at $LOCAL_REPO"

else

  # vpn detected, abort
  notify-send -i gnome-warning "Remote Database Backup" -u critical "DB Backup failed; VPN detected"

fi
