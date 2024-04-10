# OpenWRT Retain Addon Packages During Sysupgrade
Configuration typically makes it through basic upgrades, but addon software and subsequent customizations get overwritten during upgrades.

## Sysupgrade to Keep Custom Addons

First, backup and then get a list of your installed addons.

Most will be native, but things you recall installing yourself are what you're looking for.

1. Login to the router dashboard (http(s)://192.168.1.0 or https://192.168.1.1 most commonly)
2. System > Software > Installed
    - Stuff like `dnscrypt-proxy2` and `luci-app-adblock-fast`, for example, are non-native addons
    - If your addons have custom config files like dnscrypt, go to **System > Backup / Flash Firmware**
        - Click the Configuration tab
        - Add `/etc/dnscrypt-proxy2/dnscrypt-proxy.toml`
3. [OpenWRT's site](https://openwrt.org/) has a link to **Download a firmware image for your device (firmware selector)** for the latest release
4. Type in your router identifier
5. Click **> Customize installed packages and/or first boot script**
6. Append the following (adjust accordingly for whatever addon packages you use):
    ```bash
    dnscrypt-proxy2 luci-app-adblock-fast
    ```

    - If you're using dnscrypt, you'll want to setup the following commands for a custom script; under **Script to run on first boot (uci-defaults)**

        - OpenWRT suggests a custom script to ensure your values load last, to avoid interfering with other scripts. [Source documentation](https://openwrt.org/docs/guide-developer/uci-defaults)

        - Adjust key `[0]` accordingly, for your target

    ```bash
    cat << "EOF" > /etc/uci-defaults/999-custom
    uci -q batch << EOI
    uci -q delete dhcp.@dnsmasq[0].server
    uci add_list dhcp.@dnsmasq[0].server="127.0.0.53#53"
    uci set dhcp.@dnsmasq[0].noresolv="1"
    uci commit dhcp
    /etc/init.d/dnsmasq restart
    EOI
    EOF
    ```

7. Click the Request Build button
    - The build takes a minute or two
8. Download the custom .bin for **SYSUPGRADE**
    - Make note of the sha256sum, it has likely changed
9. Validate the sha256sum by running the following inside the directory of your .bin's download:

    ```bash
    sha256sum openwrt-*-squashfs-sysupgrade.bin
    ```

    - If your terminal's sha256sum matches what's on OpenWRT's website for your download, your file was not tampered with in transit and you're good to go.
    - A subsequent check is made during the flashing process, but this validates image compatibility for the existing install.
10. On the router dashboard: System > Backup / Flash Firmware