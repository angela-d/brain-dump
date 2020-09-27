# Installing Wireshark on Debian 10

```bash
apt install wireshark
```

You shouldn't run Wireshark as root or sudo, so give your user elevate permissions to Wireshark, by adding them to the `wireshark` group (some feature components of Wireshark require elevation)
```bash
usermod -a -G wireshark angela
```

Adjust `dumpcap` permissions, so your user (`wireshark` group members) have capability to capture packets on your network card
```bash
chgrp wireshark /usr/bin/dumpcap
chmod 750 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
```

Now you can launch Wireshark from your user's desktop by clicking it's app icon
