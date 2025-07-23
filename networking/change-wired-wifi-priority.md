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
