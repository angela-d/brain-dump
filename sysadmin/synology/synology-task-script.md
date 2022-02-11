# Verify Backups on Synology NAS
Make sure scheduled backups aren't failing, programmatically.

This short script was put together to make sure scheduled [Duplicati](https://www.duplicati.com/) backups are actually making their way to the Synology NAS and if they don't - notify someone.

Since the backups are encrypted, we're not able to test them (unless we want to decrypt and compile), so this will simply check the destination directory on Synology and make sure the modified time is what it should be.

The script has the backup target hardcoded and assumes anything within that directory is a backup.

Folders that aren't, are excluded like so:
```bash
egrep -v "eaDir|recycle"
```
which ignores anything matching the regex of eaDir or recycle.

Also match the time threshold for last modified:
```bash
-mtime +0
```
- +0 = greater than a day / more than 24 hours ago

## Sending Mail
Since Synology runs on php, you can use the built-in mail() function.

This will invoke config from:
```text
/etc/ssmtp/revaliases
```

Set your bounce destination, like so:
```text
root:user@example.com:mailserver.example.com:25
```
customize to suit.

Set the destination user:
```bash
/usr/bin/php -r "mail('notifyuser@example.com', 'Backup Appears to Have Failed for $directory', '$NOTIFY');";
```

## Setup
From the Synology admin:

- Go to Control Panel > Task Scheduler
- Create: scheduled task > user-defined script
- Under Task Settings > paste the script:

```bash
#!/bin/bash

# go into the working directory, for good measure
cd /volume1/BackupDirectory || exit

# loop through the backup directory and exclude dirs that don't have backups in them
for directory in /volume1/BackupDirectory/*/ ;
do
  # make sure the dir was last modified within the prev 24 hr
  if [ "$(find "$directory" -mtime +0 -type d | egrep -v "eaDir|recycle")" ];
  then
    # anything older that 24 hrs will be triggered here
    MODIFIED=$(stat -c '%y' $directory)
    NOTIFY="$directory was last modified at: $MODIFIED - no backups for more than 24 hours!"

    # uses php mail that's part of synology
    /usr/bin/php -r "mail('notifyuser@example.com', 'Backup Appears to Have Failed for $directory', '$NOTIFY');";
  else
    echo "All backups appear to be current."
  fi
done
```
