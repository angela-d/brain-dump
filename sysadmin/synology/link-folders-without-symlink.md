# Linking Shared Folders without Symlink

Symbolic links appear to be broken in later versions of SMB on Synology.

This workaround allows a shared folder to be 'synced' without the need of symlink, using mount with the --bind flag.

1. Create the target destination through Disk Station
2. Login to the Synology via SSH
3. `sudo su` into root
4. Run the following:
  ```bash
  mount --bind /volume1/Source_Directory/Source_Folder /volume1/Target_Directory/Target_Folder
  ```
5. In DSM, go to `Source_Directory` and select Properties > set permissions to the Active Directory group permitted to have access to this shared folder
