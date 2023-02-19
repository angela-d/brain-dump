# Linux Recovery Mode with Networking
When upgrading an older machine from Debian 10 to 11, I ran into a broken install.

Symptom:
- First indicator was Gnome went missing and booted into another desktop environment that was already on the machine
- Reinstalling and rebooting threw the error:

    > Oh no! Something has gone wrong. A problem has occurred and the system can't recover.


## Repairing the Install
Boot into recovery

While on the Grub boot screen:
- Select the **Advanced Options for Debian/GNU Linux** using the arrow keys (2nd option in my boot menu)
- While in recovery, it will prompt for root's password



1. Make sure there's no unconfigured packages
  ```bash
  dpkg --configure -a
  ```

2. See whether or not there's networking
  ```bash
  ip a
  ```
    - If not:
    ```bash
    ifconfig eth0 up
    ```
      - The ethernet interface may be 'renamed' by your distro, `ip a` should show you the available networking interfaces, replace eth0 with yours
      - Now that the interface is active, force it to get a DHCP IP:
      ```bash
      dhclient eth0
      ```
        - Use the same interface name you used prior, if yours isn't eth0

3. Confirm you have an IP from your network:
  ```bash
  ip a
  ```
  If so, now you can get back to resolving the broken upgrade.

4. Try the full upgrade, again:
  ```bash
  apt full-upgrade
  ```

5. See if there's any broken dependences
  ```bash
  apt --fix-broken install
  ```

6. Reboot and see if it's fixed
  ```bash
  reboot
  ```
