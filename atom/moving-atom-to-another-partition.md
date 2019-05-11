# Moving Atom to Another Partition
I moved Atom from my SSD (where the OS is installed) to a mounted partition I use for everything else.

The following will assume your new partition/drive is already mounted at startup in `/etc/fstab` as `/storage` (It can be anything, but that's the hierarchy I used.)

What this does:
- Moves everything from its native placement into a new partition/drive
- Creates a symlink, so any launchers or shortcuts will remain operative


**Before beginning, exit Atom.**

## As Your Non-root User
Prepare the "home" directories on your second drive:
```bash
mkdir /storage/atom &&
mv ~/.atom /storage/atom/.atom &&
ln -s /storage/atom/.atom/ ~/.atom
```
Now the "config":
```bash
mkdir -p /storage/atom/.config &&
mv ~/.config/Atom /storage/atom/.config/Atom &&
ln -s /storage/atom/.config/Atom ~/.config/Atom
```

## As root (or sudo user), run the following
Prepare the elevated directories:
```bash
mkdir -p /storage/atom/usr/share &&
mv /usr/share/atom /storage/atom/usr/share/atom &&
ln -s /storage/atom/usr/share/atom /usr/share/atom
```
