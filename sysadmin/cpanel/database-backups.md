# Database Backups in Cpanel
If you're doing automation of database backups, you'll want to ensure you're **not** using your cpanel user's credentials to trigger that backup.

Schedule a cron (and use git to pull into the local dev system), via [dbsync](https://github.com/angela-d/dbsync)
- Enable **git** and **ssh** on your cpanel account, if you haven't already


1. Create a designated backup user via cpanel > Databases > MySQL Databases >  MySQL Users
Add New User

2. Grant that user permission to all of the databases you want backed up: cpanel > Databases > MySQL Databases > Add User To Database > match the new backup user to your database(s)

3. Give the user the following permissions (do not select **ALL**):
- [x] INDEX
- [x] LOCK TABLES
- [x] SELECT
- [x] REFERENCES
- [x] SHOW VIEW

Note that add, update, execute, etc are all missing - should this user be compromised, there's not a lot of defacement or data destruction that can occur (via this user) with stripped down permissions.

4. Create a directory inside your account's root (**not inside public_html!**), something like: `/home/cpaneluser/dbbackupdir/` and run `git init` inside


5. Set up the cron on the cpanel system:
```bash
cd /home/cpaneluser/dbbackupdir/ && /usr/bin/mysqldump --defaults-extra-file=/home/cpaneluser/sql.cnf --opt --all-databases | bzip2 > /home/cpaneluser/dbbackupdir/sqlbackup-`date +\%Y\%m\%d`.sql.bz2 && git add . && git commit -m "Backup" && cd > /dev/null 2>&1
```

6. Create the password file (so you aren't running your password via command-line, with the cron), at `/home/cpaneluser/sql.cnf`

7. In `/home/cpaneluser/sql.cnf`, have the following:
```text
[client]
user = cpaneluser_databaseuser
password = [super secure pw goes here]
host = localhost
```

Run your cron command via SSH manually, for the first time.  If your backup appears, you're good to go.
