# Upgrading Grafana while Retaining Data
How I upgrade Grafana.  My development/testing environment runs Grafana on a Debian 11 desktop.  The live/production version runs on Windows Server 2016.

## Pre-upgrade Prep
Read the release note(s) on the [downloads](https://grafana.com/grafana/download) page to see if there's any ominous warnings of things that might break my install
- [Backup your database](https://grafana.com/docs/grafana/latest/installation/upgrading/) (location varies depending on database engine your install uses)

## Linux
1. Simply [download the .deb](https://grafana.com/grafana/download?platform=linux)
2. Follow the instructions (though I prefer to use `apt install` instead of `dpkg -i`)
3. Compare/diff grafana.ini with default.ini for new settings
4. Restart the Grafana server
    ```bash
    service grafana-server restart
    ```
4. Done.

## Windows
Note that if you fail to stop the Grafana server before upgrading, you'll probably get a prompt to reboot the *entire server* to finish the upgrade!

1. Make a copy of `C:\Program Files\GrafanaLabs\grafana\data\plugins` on the desktop
2. Go to **Services** (services.msc) > Grafana > right-click > Stop
3. [Download the .msi installer](https://grafana.com/grafana/download?platform=windows) > run
4. Compare/diff custom.ini with default.ini for new settings
5. Go to **Services** (services.msc) > Grafana > right-click > Start
6. Done.
