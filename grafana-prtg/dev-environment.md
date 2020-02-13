# Development Environment of Grafana
Test the PRTG plugin capability of future versions, before upgrading.

## Install Grafana on a Debian Desktop
From the [nightly](https://grafana.com/grafana/download) section (far right of the page) along with a SHA256.

I don't use sudo on my desktop system, I just switch to root via `su -` when I need to run administrative tasks, your environment may differ.

Grafana's instructions suggest to use dpkg, but I don't want to, because I want apt to manage it for easy upgrading.

- If you don't want to mess around with manual downloads, you can [add Grafana to your apt repos](https://grafana.com/docs/grafana/latest/installation/debian/) to automatically update the beta version and skip the step below.

Manually download the deb installer (not needed if using the apt repo for beta):
```bash
cd /tmp && su -
apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_6.6.1_amd64.deb
apt install ./grafana_6.6.1_amd64.deb
```

Grafana does not autostart (unless you want it to) and being a testing application on my day-to-day desktop, I don't want it to.

To start it each time I want to test:
```bash
su -
service grafana-server start
```

If it doesn't start or is behaving weird:
```bash
su -
service grafana-server status
```

## Login
The default URL is `http://localhost:3000` and should be accessible as soon as the **grafana-server** is started.

**Default Username:** admin

**Default Password:** admin

You will be prompt to change it on first login.

## Upgrade
This is not applicable if using the apt repo - which will upgrade Grafana anytime a new release is found while running `apt update && apt upgrade`

To upgrade to the next Grafana version, use apt in the exact same fashion as the initial install (adjust version numbers); it will install over the old version as an upgrade.

```text
apt install ./grafana_6.7.0-df1b0ae0pre_amd64.deb
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Note, selecting 'grafana' instead of './grafana_6.7.0-df1b0ae0pre_amd64.deb'
The following packages will be upgraded:
  grafana
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
````

***
Note that the following will only need to be done once, on initial setup (aside from adjusting `custom.ini` to suit, if you make future changes.)

## Testing the Plugin
My live Grafana install is on a remote intranet, so I connect to its VPN and pull the latest copies of everything I want to test:

Use Nautilus file manager to connect to the Windows server and manage everything over the graphical desktop environment:
1. Open Nautilus
2. In the left pane, click + Other Locations
3. In the **Connect to Server:** area, I enter the smb path to the C:\ drive (I login with my domain admin credentials): `smb://prtg.example.com/c$/`
4. Navigate to **Program Files\GrafanaLabs\grafana** and copy the following to a **grafana** folder on my desktop (this is what I want to test compatibility for):
  - data/plugins/jasonlashua-prtg-datasource

Copying the plugin folder will bring over my customizations to the plugin.

### Local Environment Setup
The Linux version installs to `/var/lib/grafana` and you'll notice your everyday user doesn't have read or write access to these directories.

Since this is a dev environment, we can reduce the security of these permissions a bit, by adding your user to the *grafana* group, so we can write to the directories without switching accounts or needing root.

Open up a terminal and as sudo/root, run (replace angela with your desktop's user name):
```bash
usermod -a -G grafana angela
```
1. Log out of the desktop
2. Log back in for the group assignment to take effect

You will note that you still don't have any access to these directories or files.

Loosen the permissions, a bit, by adding read/write/execute permissions to everything (`-R` = recursively) in the `/var/lib/grafana/` directory:
```bash
chmod g+rwx -R /var/lib/grafana/
```
To *remove* these permissions, you can re-run the command, but replace `+` with `-`

### Load the Files to Test
Now that you have write permissions, you can simply use the file manager to drag files where they need to go, to appropriately test.



Move the files to their designated location:

Origin Server | Local Linux Install
------------|-------------
data/plugins/jasonlashua-prtg-datasource | /var/lib/grafana/plugins

Now start/restart the Grafana server (as root/sudo):
```bash
service grafana-service start
```

I decided against mirroring the environment totally, because then it would be harder to determine if the new version of Grafana is causing the problem, or my boards.

Because of that, I need to reconnect my API in my local Grafana install so that I can build test boards.

1. Login to VPN so I have an intranet connection to my PRTG installation
2. Add PRTG as a new datasource
3. Create new boards and see if you can break any needed capability
4. When you're done testing, turn the Grafana server off `service grafana-server stop`
