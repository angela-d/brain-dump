# Unifi STUN Error
I ran into an issue where the Unifi controller wasn't connecting via [STUN](https://help.ui.com/hc/en-us/articles/115015457668-UniFi-Troubleshooting-STUN-Communication-Errors).

## Problem
Each device in the controller had the following alert:
> This device is not able to connect to the internal STUN server on your Controller. Please check if the device is able to reach the STUN server on port 3478


## Fix
Assessing firewall logs:
- Source port: 3478
- Destination port: Range of UDP ports

New firewall rule:
- Source: `Unifi Controller`
- Destination: `172.28.60.0/24` (range of the Ubiquiti devices)
- Source Port: `UDP 3478`
- Destination: `UDP Range: 33102-60730` (start and end ports may vary - these were just the min/max when checking the logs)

Almost instantly they started connecting on STUN, properly.
