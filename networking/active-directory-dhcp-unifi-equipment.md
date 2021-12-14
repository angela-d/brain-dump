# Active Directory DHCP with Unifi Controller / Ubiquiti Access Points
Steps taken to get Active Directory DHCP working with Ubiquiti equipment.

**My Setup**
- Fortigate firewall
- Unifi Controller / Ubiquiti wifi access points
- Active Directory DHCP server

## Pre-requisites
If you don't already have them, add the [DHCP](https://activedirectorypro.com/configure-dhcp-server/) and [NPS / Network Policy Server](https://nolabnoparty.com/en/setup-nps-for-radius-authentication-in-active-directory/) roles on your Windows Server.

**On the Windows Server with NPS:**

- Under RADIUS Clients and Servers > Radius Clients:
  - Right-click > New > Add the range of your APs, for example: `172.16.30.0/24`
    - Any new AP you bring online will automatically be recognized as a Radius client, now.

- Add your VLAN policy to the NPS server - [WiFi Nigel](http://wifinigel.blogspot.com/2014/03/microsoft-nps-as-radius-server-for-wifi_18.html) has a nice tutorial - when your Active Directory users attempt to authenticate to wifi, this will place them on their designated VLAN.

## Setup the VLAN on Your Network
For me, this involved doing so on the [Fortigate](fortigate/dhcp-relay-active-directory-dc.md) *and* setting the DHCP server as a **relay**.

## Set the VLAN for any pre-configured trunk profiles
For wifi, I have "trunks" set up:

- Settings > Advanced Features > Add a Port Profile
  - Add your VLAN here, the interface is self-explanatory

- Settings > Advanced Features > select `Trunk-Wireless` (or whatever yours is named)
  - Under **Tagged Networks**, append your new VLAN

- Settings > Advanced Features > select `Trunk-Switches` (or whatever yours is named)
  - Under **Tagged Networks**, append your new VLAN

## Inform the Unifi Controller of the Radius Server
From the controller:

- Settings > Advanced Features > **Add New RADIUS Profile**
  - Name your profile
  - Toggle **Enable Wireless** to force wifi users to authenticate via the Radius server
  - Toggle Radius Settings below
  - Under **Authentication Servers** specify the server IPs (FQDNs do not work, at the time of writing), as well as the shared secret you created earlier


Add the Radius profile to your wifi network:

- Settings > WiFi
  - Scroll to **Radius Profile** and select the Radius profile you named from the previous steps
