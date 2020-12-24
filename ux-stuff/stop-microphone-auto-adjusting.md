# Stop the Microphone from Auto-Adjusting on Linux
On my Debian system, after [fixing the microphone hum](remove-hum-microphone-linux.md) I started to get complaints from meeting participants that my mic volume would suddenly drop or turn down.

As root/sudo, modify `/usr/share/pulseaudio/alsa-mixer/paths/analog-input-internal-mic.conf`:
- Find
```bash
[Element Internal Mic Boost]
```
- Change **volume = merge** to:
```bash
volume = zero
```

- Find
```bash
[Element Int Mic Boost]
```
- Change **volume = merge** to:
```bash
volume = zero
```

On some systems, `zero` doesn't do anything as a value, but the "percentage" value of `100`, instead, should work.

Reload the alsa config
```bash
alsa force-reload
```
