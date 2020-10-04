# Grafana and PRTG
My notes + bits from the Grafana documentation and [neuralfraud's wiki](https://github.com/neuralfraud/grafana-prtg/wiki) (which is sorely lacking in thorough documentation).

![Dashboard](img/grafana-prtg.png)

![Old Dashboard](img/grafana-prtg-1.png)

My setup:

Application | Version
------------|----------
**Grafana** | Grafana v7.2.0 (efe4941ee3)
**PRTG Plugin** |  v4.0.4 (master branch from Github)
**PRTG** | 20.3.60.1623+

Development / Testing Environment ([see notes for setup](dev-environment.md)):

Application | Version
------------|-----------
**Grafana** | Grafana v7.2.0 (efe4941ee3)
**PRTG Plugin** |  v4.0.4 (master branch from Github)
**PRTG** | 20.3.60.1623+

^ The plugin is tested & working up to (at least) this Grafana version.

>> [Upgrading Grafana](upgrading.md)

Note: When upgrading (the PRTG extension) from v4.0.3 to v4.0.4, some graphs may break due to the channel name change.  To fix, I went in and re-added the channel for the affected visualizations.


Grafana also runs on Linux (which is easier to maintain + substantially lighter on resources), but since this is primarily for PRTG, it made the most sense (for me) to install it to PRTG's Windows Server.

Some of my notes will reference the Windows-install, as a result.  If you use Grafana for mostly things other than PRTG, the Linux version is probably the best way to go!

***

**Initial Setup**
- [Create an API-only user & group](setup.md) - Setup instructions for both Grafana and the PRTG Grafana plugin

***

**Build a Dashboard**
- [First Step](build-a-dashboard.md) - Single results or grouped graphs

**Statistical**
- [Group Sensor](regex-query.md) - Query similarly-named (but different) sensors that are members of the same Group
- [Data Transfer Rates](data-transfer-rates.md) - Getting the correct unit measurements
- [Combining Queries](grouping-results.md) - Combining two separate sensor results in the same map

**Visual**
- [Custom styles](custom-background-styles.md) - Add gradients, heading styles and custom icons to your dashboard
- [Adjust Bar Gauge Legend](remove-bar-gauge-label.md) - Remove the repeated channel on the bar gauge legend
- [Sort Ordering](sorting.md) - Sort options in graphs

**Troubleshooting**
- [Common Problems](troubleshooting.md) - Weird bugs and quirks and how to bypass them

**Preview Your Dashboard**

While on the dashboard view, click the monitor icon; click once more to enter kiosk mode and remove the headers.  ESC to quit kiosk mode.


**Share the Dashboard**

Click the arrow in the upper-right corner
If you want the shared dashboard to refresh, append `&refresh=3m` to the address bar of your browser.  By default, a username & password are required for previews.  Apparently you can make "groups" that don’t require such - I've not yet set up.

**Backup a Dashboard**

Dashboards are kept in a .db file/database.
- For a quick backup, click the *Share* button on a dashboard (arrow icon, top-right of the dashboard) > click the **Export** tab > Save to File
- [This tool](https://github.com/ysde/grafana-backup-tool) saves all of the board JSON at once, but not the database - though a simple copy of `C:\Program Files\GrafanaLabs\grafana\data\grafana.db` will suffice for infrequent/manual backups.

Since its a database, if backed up in a private git repo, [encrypt it](https://github.com/angela-d/gitenc).  Eventhough the user passwords are hashed and salted, its better to add another layer of security - should the current hashing algorithm get broken in the future.

**Add https to Grafana**
- [Encrypt your connection](enabling-ssl.md) - Enable SSL on your Grafana server

**Useful Links**

- [PRTG KB Thread about Grafana](https://kb.paessler.com/en/topic/77458-are-there-alternatives-to-maps) - Some of my notes were obtained from here
