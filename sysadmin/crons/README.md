### Automated Git Notifications for Remote Backups
Linux desktop notifications for automating git pull to update local repositories with bzipped database backups.

![git output](../../img/git-output.png)

Reject the automated pull if a VPN session is detected:

![git output](../../img/git-fail.png)

If no updates exist in the remote directory (which should never occur if you time your local cron in sync with the remote schedule)

![git output](../../img/git-up-to-date.png)

- **crontab** has the cron schedule; this file also features the crons I use on the remote server which my local repository then pulls from.
- **db-backup-cron.sh** is a small shell script to check for the existence of a VPN tunnel; if the VPN is offline, the pull will commence.  If a tunnel is detected, the pull will be rejected and skipped with a notification.
