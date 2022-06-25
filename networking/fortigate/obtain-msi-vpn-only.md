# Obtain MSI & PKG for Forticlient VPN Only
The online installer doesn't self-update and is a pain for mass deployment of the non-EMS (VPN only) version of Forticlient.

Obtaining the MSI & PKGs allows for pushing updates to your users via MDM, easily.

### Obtain the Windows MSI
1. Download the full installer for **Forticlient VPN**, to obtain the latest version: `https://www.fortinet.com/support/product-downloads`
2. On a Windows machine, run **FortiClientVPNOnlineInstaller.exe**
  - Once it's finished downloading, it'll pop up with a GUI installer, *don't close or proceed with the install*
3. Open File Explorer and navigate to: `C:\ProgramData\Applications\Cache\` and sort by date
  - Go into the latest folder and you'll see a subfolder with the Forticlient version number
  - Open the versioned folder
  - There's your MSI
    - Make a copy of it before closing the GUI installer, otherwise it'll disappear

### Obtain the MacOS PKG
1. Download the full installer for **Forticlient VPN**, to obtain the latest version: `https://www.fortinet.com/support/product-downloads`
2. On a Mac machine, run **FFortiClientVPNOnlineInstaller_x.x.x.dmg**
  - Once it's finished downloading, it'll pop up with a GUI installer, *don't close or proceed with the install*
3. In Finder:
  - Top bar, select **Go**
  - Select **Go to folder**
  - Go to: `/private/var/folders`
  - In **/private/var/folders**, search for: `Forti`
  - Under **Search**, select `"folders"`
    - Mount **FortiClient.dmg**
    - Drag **Install** to your desktop
      - Now you have a PKG!

  [Gray has an alternate approach to finding the offline installer for MacOS](https://blog.grayw.co.uk/obtaining-the-forticlient-offline-installer-for-distribution/)

## Deploying the MSI / PKG
- MSI - No issues, like any other MSI
  - **Caveat:** If you send the update while the user is online/Forticlient is running, it will not actually update and if they attempt to do check/use it after, it will make them reboot before the update commences.  A preinstall script is necessary.

- PKG - For some reason, it would not upload into Filewave, renaming it to **Forticlientx.x.x.pkg** allowed it to upload without any issues
  - During deployment, the user will receive the following popup:
  > "Fortitray" Would Like to Add VPN Configurations
  >
  > All network activity on this Mac may be filtered or monitored when using this VPN.

  To get rid of this, create an MDM profile:
  - **Forticlient Setup**
  - Under **VPN**, create a dummy connection:
    - Identifier: `com.fortinet.forticlient.macos.vpn`
    - Server: `localhost`
    - Provider Bundle Identifier: `com.fortinet.forticlient.macos.vpn`

  - Under **System Extension Policy**:
    - Allowed System Extensions:
      - Allowed Team Identifiers: `AH4XFXJ7DK` ([reference](https://docs2.fortinet.com/document/forticlient/6.0.1/macos-release-notes/825724/special-notices))
      - Allowed System Extensions: `com.fortinet.forticlient.macos.vpn.nwextension`


  **This profile must be installed / sent to the client before installation of the pkg!**

## Another Approach
The following link: `https://filestore.fortinet.com/forticlient` has XML content of the latest installers.

## MDM Deployment
My notes for MDM deployment of Forticlient to Macs can be found at [filewave-scripts/mac/forticlient-vpn](https://github.com/angela-d/filewave-scripts/mac/forticlient-vpn)
