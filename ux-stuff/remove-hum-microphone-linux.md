# Removing Microphone Hum or Buzzing on Linux Desktop
Pulseaudio in Debian doesn't appear to have noise cancellation on, by default.  Pretty much necessary for the overly aggressive sound in Google Meets.

I attempted to add this to `~/.config/pulse/default.pa` and Pulseaudio would crash each reboot; it appears to have to be done in the defaults of `/etc/pulse/`

First, backup:
```bash
cp /etc/pulse/default.pa /etc/pulse/default.pa.bak
```

The default back up is there, in case something goes wrong:
```text
root [~]: ls -l /etc/pulse
total 28
-rw-r--r-- 1 root root 1201 Jun 18  2017 client.conf
-rw-r--r-- 1 root root 2305 May  7  2018 daemon.conf
-rw-r--r-- 1 root root 4998 Apr 15 14:45 default.pa
-rw-r--r-- 1 root root 4929 Apr 15 14:45 default.pa.bak
-rw-r--r-- 1 root root 2046 Jun 18  2017 system.pa
```

Stop Pulseaudio (run as your user, not root/sudo):
```bash
pulseaudio -k
```
Worth noting: Any applications dependent on sound will lose it, until they too, are restarted.

Edit default.pa:
```bash
pico /etc/pulse/default.pa
```

Append the following, to the bottom of the file:
```bash
# noise canceling
.ifexists module-echo-cancel.so
load-module module-echo-cancel aec_method=webrtc
.endif
```

In some cases you can restart Pulseaudio and load the module, without requiring a reboot (Run as user, not root/sudo):
```bash
pactl load-module module-echo-cancel
pulseaudio --start
```

After a reboot, I had to go to system Settings and select the new input profile that was created:
![Sound profile](img/sound-profile.png)

## Auto-set the Sound Profile to Persist Reboots
List available input sources (the one currently set to default will be prefixed with a `*`):
```bash
pacmd list-sources | grep -e 'index:' -e device.string -e 'name:'
```

Set the profile so it defaults to this after reboot:
```bash
pico /etc/pulse/default.pa
```

Append into the initial conditional statement, like so:
```bash
# noise canceling
.ifexists module-echo-cancel.so
load-module module-echo-cancel aec_method=webrtc
# choose the noice canceling input profile, by default
set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo.echo-cancel
.endif
```

If it hasn't improved noticeably, the [Arch wiki](https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting) has a thorough list of arguments that can be appended to `aec_args`.
