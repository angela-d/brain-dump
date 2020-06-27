# Backup a Cisco IOS Image with TFTP
Backup the .bin of the system image and not just the running config.  By design, TFTP is not secure and should not be used on systems that aren't firewalled to UDP port 69 + your chosen transaction ports (see option flags, below) so only approved traffic can send files.

I installed tftpd-hpa to a Debian server, with the intention to at some point automate this, so it isn't dependent on any intervention from me.

## TFTP Setup on a Debian Server (that's been properly firewalled for TFTP)
Install
```bash
apt install tftpd-hpa
```

TFTP did not work out of the box; files have to already exist or be 'touch'ed in order to move around.

Edit the TFTP config and set the `--create` option, so the files can be created during upload.
- `TFTP_OPTIONS` already has a `--secure` option; without this, you would first connect to the server and then set the directory (don't do that)

```bash
pico /etc/default/tftpd-hpa
```

Modify:
```bash
TFTP_OPTIONS="--secure"
```

To:
```bash
TFTP_OPTIONS="--secure --create"
```

Force the server port number (the Transaction ID) to be in the specified range of port numbers:
```bash
TFTP_OPTIONS="--secure --create --port-range 1056:1059"
```

The config on Debian Stretch defaulted to `/srv/tftp` - this is where the files will be dropped.

Change user & group permissions from root to tftp, so TFTP can write to it:
```bash
cd /srv && chown tftp:tftp -R tftp/
```

Restart TFTP:
```bash
service tftpd-hpa restart
```

Make sure it's listening:
```bash
netstat -anu | grep ":69 "
```

If you see:
```text
udp        0      0 0.0.0.0:69              0.0.0.0:*
```

Good to go.

## On a Cisco Switch to Backup
According to Cisco documentation, if the switch doesn't have enough memory to copy the flash memory, it will erase as it backs up - probably wise to check the filesize before flashing and make sure there's enough **free**.

```bash
show flash
```
or
```bash
show bootflash
```

If so, login to the switch:
```bash
copy flash tftp
```

At this point, you'll be prompt for a filename.  It's expecting you to know the existing path; if you don't, run `show flash` and you'll see something like:
```text
# show flash
Directory of flash:/

  2  -rwx     1809168   Sep 24 2004 12:29:37  c3500xl-c3h2s-mz.120-5.WC10.bin
  4  drwx         704   Sep 24 2004 12:30:17  html
 20  -rwx          25   Mar 09 2004 09:32:40  snmpengineid
  5  -rwx         109   Sep 24 2004 12:30:18  info
113  -rwx        2212   Dec 13 2019 12:31:05  vlan.dat
 16  -rwx         109   Sep 24 2004 12:30:18  info.ver
 18  -rwx        6547   Feb 12 2019 16:47:22  config.text
  3  -rwx         319   Sep 24 2004 12:28:25  env_vars
```

**c3500xl-c3h2s-mz.120-5.WC10.bin** is the filename IOS expects to see.

My inputs (source filename will vary):
- Source filename [] = IOS image you want
- Address or name of remote host [] = Your TFTP server
- Destination filename = Filename to create of the IOS image on the TFTP server
```text
switch#copy flash tftp
Source filename []? flash:c3500xl-c3h2s-mz.120-5.WC10.bin
Address or name of remote host []? 172.20.30.1
Destination filename [c3500xl-c3h2s-mz.120-5.WC10.bin.bin]? tc8.bin
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
```

`!!!` is an on-screen progress indicator.  Once it gives you the total files transferred, check the TFTP server for the newly dropped file.

## Local Backups of the Backups
Since I haven't automated this yet and would rather not leave images on an active server, I use scp to grab the files to my desktop; from my local PC:
```bash
scp -r tftpusername@tftphost:/srv/tftp/*.bin ~/Desktop/switch-backups/
```

- And remove the source backups from the TFTP server.

## Optionally Setup the TFTP Restore to Send from Your Desktop
Useful in the event of file restoration; you can copy the restore point directly from the TFTP server.

Note that you need to be on a network accessible/whitelisted to the TFTP server.

In the earlier steps, you `chown` to tftp user, only.  If your SSH user is different (as it should be) you'll need to add your SSH user to the tftp group.

As root/sudo:
```bash
usermod -g tftp youruser
```

At this point, you still can't write to it, as the **tftp** group has no write permissions:
```text
root@yourhost[~]: ls -l /srv/
total 4
drwxr-xr-x 2 tftp tftp 4096 Apr 21 16:54 tftp
```

Give the *group* write permissions to the tftp directory:
```bash
chmod g+rwx /srv/tftp/
```

And now you can write to it:
```text
root@yourhost[~]: ls -l /srv/
total 4
drwxrwxr-x 2 tftp tftp 4096 Apr 21 16:54 tftp
```

From your desktop:
```bash
scp -r /storage/switch-images/filename-to-send.bin youruser@yourhostname:/srv/tftp/
```
- Optionally use a `/storage/switch-images/*.bin` wildcard to copy everything
- Modify the source path if your repo is kept somewhere other than `/storage/switch-images/`

The above will take a copy off of your `/storage/switch-images/` directory and copy the .bin to the TFTP server.


## Troubleshooting
Bug: %Error reading flash:c3750-ipservicesk9-mz.150-2.SE8 (Is a directory)

Problem:
```text
switch#show flash

Directory of flash:/

    2  drwx         256  Feb 28 1993 18:54:22 -06:00  c3750-ipservicesk9-mz.150-2.SE8
  528  -rwx         109  Feb 28 1993 19:05:25 -06:00  info
  530  -rwx        8045  Apr 27 1993 19:15:52 -06:00  config.text
  531  -rwx        2212  May 25 1993 21:33:34 -06:00  vlan.dat
  532  -rwx        1914  Apr 27 1993 19:15:52 -06:00  private-config.text
  533  -rwx        3096  Apr 27 1993 19:15:52 -06:00  multiple-fs

32514048 bytes total (10206208 bytes free)
switch#copy flash tftp
Source filename []? c3750-ipservicesk9-mz.150-2.SE8
Address or name of remote host []? 172.18.1.10
Destination filename [c3750-ipservicesk9-mz.150-2.SE8]? switch.SE8
%Error reading flash:c3750-ipservicesk9-mz.150-2.SE8 (Is a directory)
```

Fix:
```bash
switch#copy flash tftp                
Source filename [c3750-ipservicesk9-mz.150-2.SE8]? c3750-ipservicesk9-mz.150-2.SE8/c3750-ipservicesk9-mz.150-2.SE8.bin
Address or name of remote host []? 172.18.1.10
Destination filename [c3750-ipservicesk9-mz.150-2.SE8.bin]? switch.bin
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
18286080 bytes copied in 58.989 secs (309991 bytes/sec)
````
The "directory" is the .SE8 path and the filename is suffixed by .bin:
`c3750-ipservicesk9-mz.150-2.SE8`/`c3750-ipservicesk9-mz.150-2.SE8.bin`

***

Possible issues causing timeouts:
- Check access control lists (ACL) for `deny` rules: `show access-list`

- [Multiple interface VLANs](http://www.firewall.cx/cisco-technical-knowledgebase/cisco-routers/882-cisco-ip-tftp-source-interface.html):
> To ensure your Cisco router or multi-layer switch uses the correct interface during any tftp session, use the ip tftp source-interface command to specify the source-interface that will be used by the device.

The following example instructs our Cisco 3750 Layer 3 switch to use VLAN 5 interface as the source ip interface for all tftp sessions:
```bash
3750G-Stack(config)# ip tftp source-interface vlan 5
```
---
Failing that (which I ran into, problems with the TID / transaction ID ports being blocked):


- Simply utilizing the `--port-range` option and whitelisting those UDP ranges in the firewall, will fix the issue.
