# Upgrading vCenter and Custom VMware Images
vCenter can be updated over the GUI appliance, by adding :5480 to the vCenter URL and logging in as root (not your domain admin login).

vCenter should be upgraded prior to VMware, otherwise it may not connect or be inconsistent.
The below instructions are for patch upgrades and not a minor version upgrade (ie. *not* 6.5 > 6.7, but for 6.5.1 > 6.5.2 type upgrades).

## vCenter Password Expiry
If your password has expired or is near expiring, it won’t let you check for updates.


1. Go to the Administration tab and make sure Root password expires is set to **No**
2. If not, login to ssh `ssh root@ip_address_here` and run: `shell` and then `passwd` to change root's password
3. Log out of vCenter:5480 and log back in
4. Go back to the Administration tab, set the expiry time to 0 and save.

***

## vCenter Upgrade
1. Click the **Update** tab
2. In the upper-right corner, click Check Updates > Check Repository
3. It should then pull in updates from the pre-set repository
4. Once it completes, the modal will tell you a restart is required -- click OK and head to the Summary tab > Reboot in the upper-right corner

As it boots back up, it'll take about 5-10 mins and show a 503 error.  If you get a white screen 10+ mins on, close the browser and re-open it, as the browser cache would be at fault for jagging things up (Angular errors in the browser console log).

If it's been a while, you'll have to repeat this step multiple times, until it tells you you're up-to-date.

***

## Custom VMware Image Upgrade
In my notes, I'm using a Dell EMC Power Edge Custom image.

Using the Dell Custom Image is a *very different upgrade method* than using a typical VMware image over CLI (because the Dell repo is broken, at the time of writing)!

- Dell's image is always going to be very out of date & behind security updates
- The Power Edge did not find the drives when using the typical VMware image when first attempted install as an entirely new server -- so the Dell image has drivers specific to the Power Edge
- Dell's repo: https://vmwaredepot.dell.com/DEL/ is currently incomplete & broken, hence going to VMware to obtain the image.

*The particular image used may vary by your environment.  Double-check as necessary and adjust accordingly.*

1. Go to my.vmware.com and login with your account credentials.
2. (At the top panel) Products > My Products > All Products tab > VMware vSphere (not other vSphere listings!  The one written exactly as shown)
3. At the left of the same column: View & Download products
At the top of the page, select the ESXI version (defaulting to 6.7)
4. Custom ISOs tab > expand OEM Customized Installer CDs > select your harware ISO's latest version, ie. DellEMC Custom Image for ESXi 6.5U3 GA Install CD
5. At the left of the same column: Go to Downloads
For existing installs: DellEMC Custom Image for ESXi 6.5 Offline Bundle; for a bare-metal install: DellEMC Custom Image for ESXi 6.5 Install CD
6. In vCenter, upload the downloaded .zip to a datastore; I used "ISO Library" and inside ISO library, a folder named "Utilities"

***
## VMware Upgrade (using the .zip and not the vendor repo)
1. Enable SSL (in vCenter) > Go to the host > Configure > System > Services > SSH > Start
2. Open a terminal and SSH into the host: `ssh root@host_ip_address`
3. Put the host in maintenance mode: `vim-cmd /hostsvc/maintenance_mode_enter` (can also be done via the GUI by right-clicking the host > Enter Maintenance Mode)
4. Go into the directory where the datastores live: `cd /vmfs/volumes && ls -l`
5. `cd` into the ISO Library datastore; append `&& ls -l` to see the .zip you uploaded to the datastore earlier
6. List profiles contained in the zip package (note that the full `pwd` path is needed in the `-d` argument):  
```bash
esxcli software sources profile list -d /vmfs/volumes/bdcfsdsdsd/VMware-VMvisor-Installer-6.5.0.update03-14320405.x86_64-DellEMC_Customized-A03.zip
```
7.Perform the update based on the echo'd profile (this will begin the update):
```bash
esxcli software profile update -d /vmfs/volumes/bdcfsdsdsd/Utilities/VMware-VMvisor-Installer-6.5.0.update03-14320405.x86_64-DellEMC_Customized-A03.zip -p DellEMC-ESXi-6.5U3-14320405-A03
```
*-p is the argument value returned from step 6.*

Once complete, the terminal will echo all of the packages updated and the following phrase:
> Update Result
>
>    Message: The update completed successfully, but the system needs to be rebooted for
>
>    the changes to be effective.
>
> Reboot Required: true

8. Reboot the hypervisor and the update will be complete.  `reboot` command via CLI, or do so from the GUI by right-clicking the host > Power > Reboot
