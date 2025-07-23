# Changing Priority of Wifi & Wired Interfaces

I had difficulty keeping settings for my network interfaces' priorities functional - the settings were visible in the GUI, but didn't actually "work."

Utilizing nmcli got them to stick:

1. Show available interfaces
  ```bash
  nmcli c
  ```

2. Show priority for a specified connection:
  ```bash
  nmcli -f ipv4.route-metric c show "ssid_name"
  ```
  > ipv4.route-metric:                      -1

3. Adjust priority (lower number = higher priority):
  ```bash
  nmcli c mod "ssid_name" ipv4.route-metric 20
  ```

Repeat to adjust priorty for other interfaces.

## Setting Up a Second Wired Interface to Work Off a Dongle
This works only if you have a PCI network card + an external dongle (or multiple dongles).

In the GUI, setup a new wired interface.  These appear to be stored in `/etc/NetworkManager/system-connections` and even though the priority appears to be stored correctly, it does not seem to be obeyed until nmcli is ran against the connection.

The important bit to keep the PCI & dongles' interfaces from replacing one another:
- Be sure to set **Restrict to device** via the GUI (this seems to be obeyed)
