# DC Loss Check
Check the logs on a schedule to see if something funky is going on with the domain connection to your Synology:
```bash
# typical domain disconnects:
synouserdir: domain_get_all_trust.c:304 trust domain info miss
```

- Something may be going on prior to this, but this log always associated with weird domain connectivity.  Until the precise cause is located, this will at least be a heads up something went on.

## Process
- First read the logs up to 24 hours ago:
  ```bash
  INITIALDATE="$(date -d "$DATENOW"'-24 hours' +"$DATEFORMAT")"
  ...
  TARGET=$(awk -v date_range="$INITIALDATE" '{ if ($1 > date_range) print $0 }' "$LOGMONITOR")
  ```

- When there's matches, re-process the results, looking for specific verbiage:

  ```bash
  SEARCHFOR="trust domain info miss"
  ...
  if [[ $line =~ $SEARCHFOR ]];
  ```

- Then, go back and pull the surrounding logs within +/-3 minutes (saves having to login and grep the logs)
  ```bash
  STARTDATE=$(date -d "$GETDATE"'-3 minute' +"$DATEFORMAT")
  ENDDATE=$(date -d "$GETDATE"'+3 minute' +"$DATEFORMAT")
  ...
  MAIL+=$(awk -v start_date="$STARTDATE" -v end_date="$ENDDATE" '{ if ($1 > start_date && $1 < end_date) print $0 }' "$LOGMONITOR")
  ```



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

To prevent php from eating all of the `\n` linebreaks:
```bash
HEADER="MIME-Version: 1.0"
HEADER+="Content-Type: text/plain; charset=utf-8"
/usr/bin/php -r "mail('you@example.com', 'Possible DC Loss on Synology', '$MAIL', '$HEADER');";
```

## Setup
From the Synology admin:
- Go to Control Panel > Task Scheduler
- Create: `scheduled task` > `user-defined script`
- Under **Task Settings** > paste [the script](synology-domain-trust-check)
