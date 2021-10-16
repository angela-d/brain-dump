# phpmyadmin Errors on Vanilla Install from Privileges Tab
On a clean setup, after creating a new database and going to the permissions tab:
```text
#1267 - Illegal mix of collations (utf8mb4_general_ci,COERCIBLE) and (utf8mb4_unicode_ci,COERCIBLE) for operation '<>'
```

This appears to be:
> ... the problem is this collations in this view don't automatically update when you change collations from the my.cnf

Source/one approach for a fix: [relm on phpmyadmin issue](https://github.com/phpmyadmin/phpmyadmin/issues/15463)

### My Fix
On the main page of phpmyadmin:
- Click the `Server:localhost` breadcrumb at the top of the page to get back to phpmyadmin home
- Under **General Settings** > Server connection collation: select `latin_general_ci`
- Privileges tab is now accessible
