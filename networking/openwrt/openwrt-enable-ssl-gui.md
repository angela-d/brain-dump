# Enabling SSL on OpenWRT's Luci GUI

If the router has more than 4mb of flash storage, you can use SSL.

### Backup, first

- System > Backup / Flash Firmware > Generate Archive

### Check if you have enough storage
- System > Software

![OpenWRT Storage](../img/openwrt-storage.png)

If you have a decent amount of space left, proceed.

### Login to the router via SSH
Run the following commands to update the package repos and install dependencies:
```bash
opkg update && opkg install luci-ssl
```

By default, https is pre-configured to listen on port 443.

Restart the http server and a self-signed SSL certificate will be automatically created:
```bash
/etc/init.d/uhttpd restart
```

### Using the new SSL Cert
The first time you click back to your Luci GUI, you'll get the self-signed warning:
- Click **Add Exception**

![Security Exception](../img/security-exception.png)

- Click Confirm Security Exception to add it to your browser's certs.

Now the router's GUI connections are running under SSL.
