# Plank Dock as a Service
Adding Plank dock to startup via the desktop GUI doesn't govern it if the dock crashes or gets killed.

With a systemd user service, systemd can restart it without any user intervention.

## Setup the systemd User Environment
If you aren't already using *user* systemd services, create the necessary directory schema (as your **user**, *not* root/sudo):
```bash
mkdir -p ~/.config/systemd/user/
```

Make the systemd unit file:
```bash
pico ~/.config/systemd/user/plank.service
```

Put the following in the unit file:
```bash
[Unit]
Description=Plank background service
ConditionPathExists=/usr/bin/plank
After=gdm.service

[Service]
Restart=on-failure
RestartSec=5s
TasksMax=18402
ExecStart=/usr/bin/plank

[Install]
WantedBy=default.target
```
(If you don't use Gnome, replace `After=gdm.service` with a desktop service relevant to your desktop environment.)

That's it!

Now, enable the new service to auto-start on boot (after the desktop environment):
```bash
systemctl enable --user plank
```

Start it for this session (without needing to logout):
```bash
systemctl --user start plank
```
Done!

### Test the service
To see what will occur if something happens to the user service; figure out what the process ID is:
```bash
ps aux | egrep [p]lank
```
- The process ID will be the numeric value in the second column:
  ```text
  angela     85037  0.1  0.9 431204 73144 ?        Ssl  23:25   0:01 /usr/bin/plank
  ```
- Kill it:
  ```bash
  kill -9 85037
  ```
    - 5 seconds after the process kill, Plank should re-appear

### Worth Noting
When Plank runs as a service, anything you launch from will run as a subprocess of Plank.

If you use resource-hungry things like Vivaldi/other Chrome-based browsers, you might hit the tasks limit and Plank will subsequently crash.

By default, `systemctl --user status plank` shown the following:
```text
Tasks: 192 (limit: 9201)
```

The only time I experienced issues with crashes was while using Vivaldi, so I duplicated the task limit to **18402**, as you can see in the unit config, above.  I did not see any such crashes while using Firefox ESR in the same manner as Vivaldi.

Without any applications launched from Plank, its at about 5 tasks:
```bash
angela@debian$ ~: systemctl --user status plank
```
```text
● plank.service - Plank background service
     Loaded: loaded (/home/angela/.config/systemd/user/plank.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-03-08 07:39:12 CST; 8h ago
   Main PID: 2265 (plank)
      Tasks: 5 (limit: 18402)
     Memory: 624.8M
        CPU: 1h 8min 20.779s
     CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/plank.service
             └─2265 /usr/bin/plank
```
