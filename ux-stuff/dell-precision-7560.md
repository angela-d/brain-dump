# Dell Precision 7560
The Dell Precision 7560 laptop came with Ubuntu pre-installed, I wanted to dual-boot Debian with Windows, instead of Ubuntu.
I ran into a few issues with that transition.

## Installing Windows
This was a piece of cake - the USB was immediately detected when booting into USB (F2) and I simply installed it over Ubuntu.

## Installing Windows Drivers
The networking stack wasn't auto-installed, so I had to use another machine to [get the drivers](https://www.dell.com/support/kbdoc/en-us/000188586/precision-7560-windows-10-driver-pack) from Dell.

[Dell Support Assist](https://www.dell.com/support/contents/en-us/article/product-support/self-support-knowledgebase/software-and-downloads/supportassist) will also go through and double-check everything was installed properly.
- Remove Support Assist after, no reason to keep it and it's a [popular target for attackers](https://www.thesecmaster.com/biosconnect-and-https-boot-vulnerabilities/)

## Partitioning for Linux
I used the Disk Partition tool in Windows and shrunk 300/500 GB for Debian (which will be the daily driver) - now there's 300GB of free space for the Debian installer.

- Download [Rufus](https://rufus.ie/en/), which will build the bootable USB for Debian
- Download the latest [Debian ISO](https://www.debian.org/) - **Note** that big download button *will not* have the firmware necessary - save yourself some time and use the [non-free](https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/) installers.

### Build the bootable Debian USB with Rufus
This model doesn't support Legacy BIOS.

- Parition scheme: `GPT`
- Target system: `UEFI`
- File system: `Fat32 (Default)`
- After you begin, a popup will appear asking what to do for image mode, `ISO` works just fine

## Boot to the USB
1. Turn off fast boot in Windows
2. Reboot (F2) and make sure the USB is visible
  - It was not, so I went into the BIOS settings (same menu you'd already be in, at this point) and turned off **Secure Boot**
3. Reboot again (F2)
  - Debian was now visible in the boot menu; moved the arrows to make it so the USB boots first; otherwise, it will continue booting into Windows

## Installing Debian
I realized during the installation I grabbed the netinstaller that didn't have any firmware, so I'll have extra work to do to get the necessary firmware.

## Configuring Debian
The networking worked over ethernet, but now I had to install the following packages to get the firmware:
- `firmware-linux`
- `firmware-iwlwifi`

Wifi is a problem.

From `/var/log/syslog`:
```bash
kernel: [    3.987148] iwlwifi 0000:92:00.0: loaded PNVM version 0x324cd670
kernel: [    4.235483] iwlwifi 0000:92:00.0: Timeout waiting for PNVM load!
kernel: [    4.235489] iwlwifi 0000:92:00.0: Failed to start RT ucode: -110
kernel: [    4.235493] iwlwifi 0000:92:00.0: iwl_trans_send_cmd bad state = 0
```

Intel(R) Wi-Fi 6 AX210 appears to be supported by the Linux kernel as of 5.10+ and Debian (at the time of writing) is **5.10.0-13** - check by running `uname -a`

There seems to be an extra driver being loaded that's incompatible, so removing it:
```bash
mv /lib/firmware/iwlwifi-ty-a0-gf-a0.pwm /lib/firmware/iwlwifi-ty-a0-gf-a0.pwm.bak
```
- Reboot
- I can now see my network, but can't connect.

From `/var/log/syslog`:
```bash
wpa_supplicant[534]: wlp146s0: CTRL-EVENT-SCAN-FAILED ret=-22
```

Add the following to `/etc/NetworkManager/NetworkManager.conf`:
```bash
[ifupdown]
#managed=false
managed=true

[device]
match-device=driver:iwlwifi
wifi.scan-rand-mac-address=no
```
- Restart network manager: `service network-manager restart`
- That did the trick

I suspect I'll have to do this again after the next kernel update, unless it's fixed upstream.

## Updating BIOS
- During a boot/reboot, press `F2`, go into BIOS and select the **Update BIOS** option
