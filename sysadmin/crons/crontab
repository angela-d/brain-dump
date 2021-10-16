# desktop reminders
# as normal user (not root): crontab -e
#
# m h  dom mon dow   command -i icon "subject" (no timeout/click to remove) "concise message"
#
# icon directories:
# /usr/share/icons or ~/.local/share/icons (filename without extension)
#
# export variables are necessary as the crontab runs headless in the background with no display utility
DISPLAY=":0.0"
XAUTHORITY="/home/angela/.Xauthority"
# full path to your .Xauthority file
XDG_RUNTIME_DIR="/run/user/1000"
# if your user id is not 1000, find via cli by: id -u

00 19 26 * * notify-send -i gnome-warning "Reminder" -u critical "message body"
05 19 11 * * notify-send -i gnome-warning "Reminder" -u critical "message body"
10 19 22-28 * 5 notify-send -i calligraplan "Reminder" -u critical "message body"
15 19 */15 * * notify-send -i kchart "Reminder" -u critical "message body"
50 23 30 * * notify-send -i gnome-warning "Reminder" -u critical "message body"

# a warning to turn off the vpn, else the pull will fail w/ ip filtering in place
30 15 * * 0 notify-send -i gnome-warning "Turn off VPN" -u critical "DB Backup is about to commence, in 5 minutes"

# pull db backups from a remote server (using git) and notify me when done, on sunday
# pipes the output response to a variable and reads it back in the notification bubble via $GITOUTPUT
# if the connection fails, the output hangs!!
# chmod +x /home/your_user/.config/db-backup-cron.sh else it will fail
35 15 * * 0 35 15 * * * ~/.config/db-backup-cron.sh


### remote crons ###
# this will run a dump of *all* databases and append them to a single file, bzip them for max compression
# if you have insanely large databases you may want to trim obsolete records; bzip has great compression, but is also slow
# absolute paths for system executables may/may not be necessary, depending on your system; nowadays probably not
# --defaults-extra-file usage prevents using mysql passwords on cli & storing in a non-public system directory
cd /home/user/hiddenpath/ && /usr/bin/mysqldump --defaults-extra-file=/home/user/sql.cnf --opt --all-databases --ignore-database=information_schema --ignore-database=mysql --ignore-database=performance_schema --ignore-database=phpmyadmin | bzip2 > /home/user/hiddenpath/sqlbackup-`date +\%Y\%m\%d`.sql.bz2 && git add . && git commit -m "Backup" && cd > /dev/null 2>&1

# rotate database backups older than 5 days, automate git commit so my local cron can login via ssh (pk auth) and do a pull without manual intervention
# only remove files with the sqlbackup-*.sql.bz2 filename, to prevent removal for the .git folder
cd /home/user/hiddenpath/ && /usr/bin/find /home/user/hiddenpath/* -name "sqlbackup-*.sql.bz2" -mtime +5 -exec rm {} \; && git add . && git commit -m "Purge old backups" && cd > /dev/null 2>&1

# > /dev/null 2>&1 = redirect stdout/stderr to a blackhole (no email notifications)
