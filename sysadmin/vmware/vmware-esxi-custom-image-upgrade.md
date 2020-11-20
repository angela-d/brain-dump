# VMware ESXI Custom Image Upgrade
I'll base my notes off of Dell PowerEdge R740 servers.

There are a few different approaches to custom image upgrades, this is just how I've done it.

## Pre-Upgrade Checks
1. Log into vCenter and go to a host to obtain the model (Poweredge 740, for example)
2. Go to Dell's website and search for [firmware release updates](https://www.dell.com/support/home/en-us/product-support/product/poweredge-r740/drivers) - if there is a version later than what you're running, upgrade this, first
3. Determine what version of ESXI will be needed.  
  - From vCenter: Select the host > Configure tab > System > Licensing > the Product column is what you need, ie: *VMware vSphere 6 Essentials Plus (CPUs)*
4. Check [hardware compatibility](https://www.vmware.com/resources/compatibility/search.php) for the **planned version**
5. Confirm the [upgrade path](https://www.vmware.com/resources/compatibility/sim/interop_matrix.php#upgrade) compatibility

## Obtain the Upgrade Package
The image can also be obtained from Dell's site, but I find Dell's image is more out of date than VMware's.
1. Log into *my.vmware.com*
2. (At the top panel) Products > My Products > All Products tab > **VMware vSphere** *(not other vSphere listings!  The one written exactly as shown)*
3. At the left of the same column: **View & Download products**
4. At the top of the page, select the ESXI version you're upgrading to (defaults to to current latest, 7.0)
5. **Custom ISOs** tab > expand OEM Customized Installer CDs > select your harware's latest version, ie. *DellEMC Custom Image for ESXi 6.7U3 GA*
> For existing installs: DellEMC Custom Image for ESXi 6.7 **Offline Bundle**; for a bare-metal install: DellEMC Custom Image for ESXi 6.7 **Install CD**

6. At the left of the same column: Go to Downloads
7. In vCenter, upload the downloaded .zip to a datastore

## VMware Upgrade (using the .zip and not the vendor repo)

1. Enable SSH (from vCenter) > Select the **host** you'll be updating > Configure > System > Services > SSH > Start

2. Open a terminal and SSH into the host: `ssh root@host_ip_address`

3. **Backup the Host Config**
  - `vim-cmd hostsvc/firmware/backup_config` - this will save a tar gzipped bundle to */scratch/downloads/* for a short period of time
  - The CLI command will return the following:
  > Bundle can be downloaded at : http://*/downloads/5d4fc6f-1e4b-7470e-c45-ae6278684d11/configBundle-vmware.tgz

  - Replace the asterisk for your host's IP & run a wget, with the *--no-check-certificate* flag (if you're using a self-signed SSL, you'll get errors, otherwise):
  ```bash
  cd ~/Downloads && wget https://192.168.1.2/downloads/5206ac6f-1e4b-740e-c005-ae6265454d11/configBundle-vmware.tgz --no-check-certificate
  ```

4. Make note of the version running
```bash
vmware -vl
```
> VMware ESXi 6.5.0 build-14320405
>
> VMware ESXi 6.5.0 Update 3


5. Put the host in maintenance mode: `vim-cmd /hostsvc/maintenance_mode_enter` (can also be done via the GUI by right-clicking the host > Enter Maintenance Mode)

6. Go into the directory where the datastores live: `cd /vmfs/volumes && ls -l`

7. `cd` into the datastore you put the zip into & `ls -l` to see the .zip you uploaded earlier

8. List profiles contained in the zip package (note that the full pwd path is needed in the -d argument):  
```bash
esxcli software sources profile list -d /vmfs/volumes/bdcfsdsdsd/VMware-VMvisor-Installer-6.7.0.update03-16316930.x86_64-DellEMC_Customized-A06.zip
```
  - Output (make note of the *Name* value):
    ```text
    Name                             Vendor  Acceptance Level
    -------------------------------  ------  ----------------
    DellEMC-ESXi-6.7U3-16316930-A06  Dell    PartnerSupported
    ```

9. Perform the update based on the echo'd profile (this will begin the update):
```bash
esxcli software profile update -d /vmfs/volumes/bdcfsdsdsd/Utilities/VMware-VMvisor-Installer-6.7.0.update03-16316930.x86_64-DellEMC_Customized-A06.zip -p DellEMC-ESXi-6.7U3-16316930-A06
```
> `-p` is the argument value returned from step 6.

10. Once complete, the terminal will echo all of the packages updated and the following phrase:
> Update Result
>
> Message: The update completed successfully, but the system needs to be rebooted for the changes to be effective.
>
> Reboot Required: true

11. Reboot the hypervisor and the update will be complete.  reboot command via CLI, or do so from the GUI by right-clicking the host > Power > Reboot

12. After reboot, check the running version
```bash
vmware -vl
```

13. Head back into vCenter and make sure SSH is turned off, on the host
