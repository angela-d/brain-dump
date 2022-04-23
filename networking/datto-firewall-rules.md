# Datto Firewall Config
Rules to open ports specifically for a Datto appliance, without exposing the port, or truly 'opening' it.

Note that if you don't allow these systems port 443 outgoing, you'll have to add the [certificate authorities](datto-troubleshooting.md) to get Datto paired with the backup agent.

## Windows Server
The Datto agent installer will pre-install incoming and outgoing rules in Windows Server firewall.

By default, the incoming port is open to every device on the same network.

**Lock the Datto port down**

- Open **Windows Defender Firewall with Advanced Security** with elevated permissions
- Select **Inbound rules** in the left menu
- Double-click the **Datto Windows Agent In** rule
  - Select the **Scope** tab
  - Under *Remote IP address*, tick **These IP addressess**
    - Add your Datto appliance IP
    - Repeat the same, but for **Outbound** rules if you whitelist outgoing traffic

## Linux-based Servers with CSF firewall
[ConfigServer Firewall](https://www.configserver.com/cp/csf.html) running on any Linux-based distro:

In my example, the Datto appliance is `172.16.4.50`

- Allow TCP traffic only to/from the client machine and Datto appliance by whitelisting on `/etc/csf/csf.allow`
  ```bash
  # datto in
  tcp|in|d=25566:25669|s=172.16.4.50
  # datto out
  tcp|out|d=3260:3262|d=172.16.4.50
  ```
  - Run `csf -r` to activate
  - KB for [ports used](https://help.datto.com/s/article/KB204953800#System)
  - [Supported Distros](https://help.datto.com/s/article/KB204953800#Supporte) Ubuntu 20.04.4 LTS (Focal Fossa) isn't listed, but appears to do successful backups (restore testing still required, at the time of writing)
