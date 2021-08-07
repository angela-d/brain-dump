# Troubleshooting with Packet Trace on a Fortigate
These notes are based on the firewall GUI and assume Wireshark is installed on your client machine.

1. In the Fortigate GUI:
  - Network > **Packet Capture** > Create New
  - Select the Interface -- you can drill down results by ticking *Enable Filters*
  - Click OK to start the capture - the Packet Capture page will reload
  - On the criteria you just created, click the **play button** ( > )

2. After a few packets are logged, you'll see a download icon appear.  Click the **square** icon to stop the scan; then download.

3. If you have Wireshark already installed on your client machine, the pcap file will open right in Wireshark and you can assess the packets to determine the cause of any issues.
