# Transfer Files Between Laptop and Phone
My phone is a glorified iPod.  Plugging your phone in via USB to transfer files immediately activates the battery charge, which uses up the limited life cycles on your phone's battery.

Easily transfer files between the two, without having to use a USB connection and instead, use a wifi connection.

## Pre-requisites

- [LocalSend](https://localsend.org) - installed both on the laptop & phone
- Firewall (I use ufw on the laptop, NetGuard on the phone)
    - [Allow Localsend through NetGuard](https://github.com/M66B/NetGuard/blob/master/FAQ.md)
        - Really not as complex as this looks; it's an on/off button in the settings!

## Transfer Config

On the laptop:

- For root, I set the following aliases at the end of my `~./bashrc`:
    ```bash
    alias localsendon='ufw allow from 192.168.1.0/24 to any port 53317 && echo -e "\n\n\tBe sure to disable isolation on the wifi network!!"'
    alias localsendoff='ufw delete allow from 192.168.1.0/24 to any port 53317 && echo "Removed firewall rule to port 53317" && ufw status numbered && echo -e "\n\n\tBe sure to re-enable isolation on the wifi network!!"'
    ```

        - Source for the IP ranges: my home network (most people's, by default)
        - Ports for Localsend: [Localsend protocol](https://github.com/localsend/protocol)
        - **What does this do?** By default, this port is not open on my laptop.  Running these commands will enable/disable access to these ports, along with a textual reminder of what to do once they're run.

- Usage:
    ```bash
    su -
    localsendon
    ```

    ```bash
    root [~]: localsendon
    Rule added


	Be sure to disable isolation on the wifi network!!
```

- **What does this mean?*
    - I have device isolation enabled in OpenWRT on my home network.  
    
    Pop into the dashboard and go to (for OpenWRT users):
        - Network > Wireless > select your SSID > Edit > Advanced Settings tab under **Interface Configuration** > *un-check* Isolate Clients to activate LocalSend; un-check to deactivate

        - Transfer your files/folders as necessary


To turn off localsend on my laptop:

```bash
root [~]: localsendoff
Rule deleted
Removed firewall rule to port 53317
Status: active


	Be sure to re-enable isolation on the wifi network!!
```