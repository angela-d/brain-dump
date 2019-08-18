# SSH File Transfer from MacOS to a Linux Desktop
For easy data transfer over command-line.

## On the Mac
See if SSH is enabled by running the following in a terminal:
```bash
sudo systemsetup -getremotelogin
```

> Remote Login: Off

Enable it:
```bash
sudo systemsetup -setremotelogin on && sudo systemsetup -getremotelogin
```

> Remote Login: On

If you want to disable it, later on:
```bash
sudo systemsetup -setremotelogin off
```
***
## On the Linux Machine
If you want to pull files from a Mac machine to a Linux machine (assuming both source & destination's SSH runs on port 22.. if not, specify the port as `-p 123`):

Grab a file from the Mac:
```bash
scp -r localadmin@mojave.local:/Users/localadmin/Desktop/macapp.app ~/Desktop
```

Because .app's are essentially just folders, scp would initially throw: `not a regular file` -  use the recursive `-r` flag to pull it over.

Send to the Mac from Linux:
```bash
scp ~/Desktop/test.sh localadmin@mojave.local:/Users/localadmin/Desktop
```
