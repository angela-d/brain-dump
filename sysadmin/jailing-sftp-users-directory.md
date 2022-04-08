# Jailing SFTP Users to a Specific Directory
Users can connect on the SSH port, but not have traditional unfettered access to the server.

Not something I do regularly, so no reason to script.


## How-To
- Log in to the server and su into a root session

Now, set an environment variable that can be reused through multiple commands.

Run the following via CLI:
```bash
JAILDIR=/home/usernametocreate
```

The following will allow chroot to the user's directory and subsequent components; it *has* to be owned by root and un-writable to any other (non-root) user or group:
```bash
chown root:root $JAILDIR
chmod 0755 $JAILDIR
```

Confirm setup, so far, like so:
```bash
ls -ld $JAILDIR
```
Gives output like:
> drwxr-xr-x 3 root root 4096 Apr  7 19:45 /home/usernametocreate

### Does the user need SSH stuff?  If not, skip this! (until the SSH config)
Explanation of flags:
- `-m` - Permission bits
- `c` - character file
- remaining numbers - Major and minor numbers the files point to

```bash
mkdir -p $JAILDIR/dev/
mknod -m 666 $JAILDIR/dev/null c 1 3
mknod -m 666 $JAILDIR/dev/tty c 5 0
mknod -m 666 $JAILDIR/dev/zero c 1 5
mknod -m 666 $JAILDIR/dev/random c 1 8
```

Give them bash and password change capabilities (maybe, depending on use case):
```bash
mkdir -p $JAILDIR/bin
ln -s /bin/bash $JAILDIR/bin/bash
mkdir $JAILDIR/etc
```

## SSH Config
- Modify `/etc/ssh/sshd_config`

- Append the following (for a particular user; adjustment required to whitelist groups instead of individual users)
  - I want to allow this *specific user* password authentication privileges; but retain ssh key enforcement for others
  - This user is only allowed in the specified `ChrootDirectory` and nested directories
```bash
# jailed user - indentation doesnt matter except for readability
Match User usernametocreate
        # allow passwords
        PasswordAuthentication yes
        # jailed user destination
        ChrootDirectory /home/usernametocreate
        # allow sftp login
        ForceCommand internal-sftp
Match all
```
  - Note: The user won't be able to write to `/home/usernametocreate` as-is, I want them to write to something else, like `web`

Create the writable directory for `usernametocreate`:
```bash
mkdir $JAILDIR/web
chmod -R 0700 $JAILDIR/web
```

That's it!

## Whitelist the User at the Firewall
And block everyone else.
1. Get the user's public IP
2. Modify `/etc/csf/csf.allow`
3. Whitelist them for the custom SSH port:
  ```bash
  tcp|in|d=22|s=127.0.0.1
  ```
  - Port should be removed from `/etc/csf/csf.conf` completely
  - `d=` should be the custom ssh port in use; specified in `/etc/ssh/sshd_config`
  - `s=` should be the user's public-facing IP
  - Run `csf -r` to reload firewall rules, after saving
