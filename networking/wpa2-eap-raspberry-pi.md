# Connecting to WPA2 Enterprise Wifi on a Raspberry Pi 4
Connecting to EAP MSCHAPv2 wifi on the default LXDE network applet requires a bit of effort via CLI.

A much simpler approach (in my opinion), is to use the Gnome-based Network Manager, instead.

**If you're attempting to connect to a university or school network with a Pi, make sure your network administrator or IT department knows you're using a Raspberry Pi.  Some institutions may require you use special credentials for an IOT device.**


1. Open the terminal app and run `sudo apt install network-manager network-manager-gnome` - this will install the new applet and all of its dependencies.  You will be prompt before the dependencies install, type `y` to confirm your acceptance and to finish the download.

2. Then, disable the existing applet in LXDE GUI: Right-click on the up-down arrows in the upper-right corner > Panel Settings > find **Wireless & Wired Network** > select it and hit the **Remove** button

3. Click on the Raspbian logo to get to the app menu > Preferences > Advanced Network Configuration > **+** to add a new connection and populate the following:

### Setup a New Connection
- 802.1x Connection

The following correlate to the applet tabs.

### Wi-fi Tab:
  - **SSID:** [name of the connection you want to connect to]
  - **Band:** [select whether your network is 2g or 5g]

### Wi-fi Security Tab:
  - **Security:** WPA & WPA2 Enterprise
  - **Authentication:** Protected EAP (PEAP)
  - *If you have a CA cert from your network administrator, specify the path to it in the certificate section, otherwise, tick No Certificate Required*
  - **PEAP version:** [select your PEAP version; use Automatic if unsure]
  - **Inner Authentication:** MSCHAPv2
  - **Username:** [your username]
  - **Password:** [your password]

### IPv6 Tab:
If your network doesn't use IPv6, disable it.  Otherwise, ignore this step.
  - **Method:** Ignore


4. Go back to the terminal and type: `reboot`

When Raspbian boots back up, you should see the Network Manager applet in place of the LXDE Network Applet and your active wifi connection.

### Troubleshooting
If for whatever reason something gets weird, re-initialize the wifi interface:
```bash
ifdown wlan0 && ifup wlan0
```

Restart the networking entirely:
```bash
sudo service networking restart
```

### And as always, check the logs at `/var/log/syslog`:
Sort by interface (limit to 200 of the latest lines, only):
```bash
tail /var/log/syslog -n 200 | grep wlan0
```

Check the kernel logs:
```bash
sudo dmesg | grep error
```

```bash
sudo dmesg | grep warning
```
