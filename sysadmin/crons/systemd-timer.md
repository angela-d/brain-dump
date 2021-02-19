# Systemd Timer Instead of Cronjob
Cronjobs are quick and efficient for mostly backend automation or lightweight notifications, but are rather tedious in situations where embedded applications have permissions restrictions or behave weirdly without a full userspace or env import.

**systemd** *user* **services** (with timers) seem to be a nice alternative (for systemd-based Linux distros.)

- systemd user files run *as the user* and don't require sudo or root to setup or run.

## Necessary files
- Timer script
- Service script

1. If `~/.config/systemd/user/` doesn't exist, create it:
  ```bash
  mkdir -p ~/.config/systemd/user/
  ```


2. Create the service file: `myscript.service` in `~/.config/systemd/user/`:
  ```bash
  [Unit]
  Description=Conscise description of this service
  ConditionPathExists=/your/path/to/script

  [Service]
  ExecStart=/your/path/to/script

  [Install]
  WantedBy=default.target
  ```


3. Create the timer file (schedule) for `myscript` as `myscript.timer`:
  ```bash
  [Unit]
  Description=Concise description of this scheduler

  [Timer]
  OnBootSec=2min
  OnUnitActiveSec=5m

  [Install]
  WantedBy=timers.target
  ```

    - **OnBootSec** = how soon to start the service after boot
    - **OnUnitActiveSec** = frequency threshold to re-launch `myscript`


4. Confirm your directory looks like so:
  ```text
  ~/.config/systemd/user/:
  ├── myscript.service
  └── myscript.timer
  ```

5. Activate the service (script) on every startup:

     *One and done command; this won't need to be run again after the timer is active.*

  ```bash
  systemctl --user enable myscript
  ```

6. Set the timer for startup during boot:

     *One and done command; this won't need to be run again after the timer is active.*

  ```bash
  systemctl --user enable myscript.timer
  ```

7. Set the timer for startup during boot:

     *One and done command; this won't need to be run again after the timer is active.*

  ```bash
  systemctl --user enable myscript
  ```

8. Start the service

     *One and done command; this won't need to be run again after the timer is active.*

  ```bash
  systemctl --user start myscript --now
  ```

9. Start the timer:

     *One and done command; this won't need to be run again after the timer is active.*

  ```bash
  systemctl --user start myscript.timer --now
  ```

### That's it!

***

## Modifying the script after the service is active
- Modifying the script doesn't appear to require a restart
- Modifying the *service* or *timer* settings will require a simple restart of a daemon:
  ```bash
  systemctl --user daemon-reload
  ```

## Troubleshooting
systemd user services have the same tools available as system-level services.

- See when the timer is scheduled to run next:
  ```bash
  systemctl --user status myscript.timer
  ```

- Check if everything is going smoothly with the service
  ```bash
  systemctl --user status myscript
  ```
  (note that inactive/dead isn't what you may think; it simply means the service did it's job and went dormant.   The timer will come by and activate it when it's scheduled to.)

- Restart the timer:
  ```bash
  systemctl --user restart myscript.timer
  ```

- Restart the service:
  ```bash
  systemctl --user restart myscript
  ```

- Stop the timer:
```bash
systemctl --user stop myscript.timer
```

- Stop the script:
```bash
systemctl --user stop myscript
```

The [Arch Linux systemd/user wiki](https://wiki.archlinux.org/index.php/Systemd/User) has much greater detail for additional options and features.
