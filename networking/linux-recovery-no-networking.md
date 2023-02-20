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

  If not:

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

5. See if there's any broken dependencies
  ```bash
  apt --fix-broken install
  ```

6. Reboot and see if it's fixed
  ```bash
  reboot
  ```

***

## Repairing a Broken Pop OS Install
I ran into a machine running Pop OS (which has always upgraded smoothly prior) that completely obliterated itself this time around.

Symptom:
- Boots into Pop! launch screen and just sits there.  aka the Plymouth screen (which obfuscates boot messages)


1. I gave it at least 2 hours because I was on a limited-speed ISP; far exceeding the normal upgrade window.
  - Hold the power key down to cut the power to the system
  - Tap it to start it back up
  - Use the arrow keys on the grub screen to **Advanced Options for Pop! OS Recovery**
    - Worth noting: I ended up with a read-only system, using the arrow keys I select the root option and ran:
    ```bash
    mount -o remount, rw /
    ```
    Otherwise, any changes won't stick.  I ran into issues mounting read-write, so I opted for an earlier kernel in the recovery boot menu and was able to mount rw successfully.

2. First step: Get rid of Plymouth.  Since it's baked into Ubuntu (Pop's upstream), I decided to just leave it be, but remove it from Grub
  ```bash
  nano /etc/default/grub
  ```
  Change the variable **GRUB_CMDLINE_LINUX** to be blank:
  ```bash
  GRUB_CMDLINE_LINUX=""
  ```
  Now, it should display all boot messages and not be obfuscated by any "pretty" graphics.

3. Error message:
  > Can't locate Text/Iconv.pm in @INC (you may need to install the Text::Iconv module)...

  - `apt install libtext-iconv-perl` or download the deb manually:
    ```bash
    cd /tmp && apt download libtext-iconv-perl
    dpkg -i --force-all libtext-iconv-perl*.deb
    ```
    That should install the missing module.

    Continue trying to fix the broken upgrade until there's nothing left to fix:
    ```bash
    apt --fix-broken install
    ```


4. Running all of the above (from the Debian recovery fix) yielded no success.. Pop was way more far gone.
  After `dpkg` or `apt` fixes, initramfs updates persistently failed, which prevented the full upgrade from completing.

  A fix for that is to temporarily halt initramfs updates, so the rest of the broken packages can get fixed:
  ```bash
  nano /etc/initramfs-tools/update-initramfs.conf
  ```

  Temporarily disable updates; change the line `update-initramfs=yes` like so:
  ```bash
  update-initramfs=no
  ```

  After that, the broken packages were able to be fixed via `dpkg --configure -a` and `apt full-upgrade`

5. Once all of the fixes and upgrades complete, undo the initramfs hold:
  ```bash
  nano /etc/initramfs-tools/update-initramfs.conf
  ```

  Change the line `update-initramfs=no` like so:
  ```bash
  update-initramfs=yes
  ```

6. `reboot` and boot normally into the desktop environment
