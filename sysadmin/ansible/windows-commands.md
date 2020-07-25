# Ansible Windows Commands
After [setting up Windows hosts](windows-hosts-setup.md), you can use the following commands to run upgrades on Windows without having to use the hideous Windows GUI.

## Test Connection with Ping
```bash
ansible winvms -m win_ping -k
```

Explanation of arguments (also accessible via `man ansible`):
- `winvms` host group set in the yaml config in `~/.ansible/hosts/test.yml`
- `-m` *Lowercase* = module name to execute
- `-k` ask for password (prevents having to store it in a config file)

Successful output:
```text
angela@debian$: ansible winvms -m win_ping -k
SSH password:
windows.example.com | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

```
