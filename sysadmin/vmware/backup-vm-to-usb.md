# Backup a Virtual Machine to USB
aka "Poor man's backup," "old school waste of time" and always wise to do for the most integral systems, regularly (also, keep it off-site - in a secure location; and encrypted, after.. depending on the data content).

## Pre-requisites
- A USB 3.0 with sufficient storage to hold the entirety of your VM
- vCenter (you could do with just ESXI, but my notes are based on using vCenter)
- SSH enabled on the host (not vCenter)

## Backing Up
1. Go to wherever you create datastores and create a new datastore, mirroring the specs of the datastore that holds the VM you wish to copy to a USB.
2. Once the datastore is in vCenter, **clone** the original machine:
  - Right-click the machine you want to backup
  - Clone
  - Clone to a virtual machine
3. Assuming you pass through all of the typical vCenter menus, once you get to storage, be sure to select the *clone* datastore you just created, for it; not the source datastore of the VM you want to back up
4. After the clone has successfully completed, go to your SFTP client (or file manager, if you're using Linux)
5. If using a file manager like Nautilus, in the file manager footer you can connect to the host via: `ssh root@address_of_your_host(not_vcenter)`
6. After you've authenticated, you'll see the root filesystem of the host, navigate to: `/vmfs/volumes/`*

`*`Once in **volumes**, you'll see a listing of randomly-named folders; scroll below that and you'll spot "friendly names" (the name of your datastore), which are *symbolic links* to the ugly randomly-named folders - clicking one of the symbolic links is effectively the same as knowing which randomly-named directory you need.

7. Find the datastore that contains the clone you just made
8. Open a new file manager, drag the contents to your USB and wait.
9. Once complete, disable SSH in your host, once again

Super easy.  The most difficult part is having adequate speeds to achieve a backup of this nature.

Once the contents are on your USB, it's probably a good idea to destroy the **clone**, so it isn't taking up space on your NAS or SAN.
