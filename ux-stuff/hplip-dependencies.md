# Dependency Problems with HPLIP in Debian 10.7
hplip and hplip-gui are both in Debian's repositories for buster, but upon running `hp-check`, it noted missing dependencies (and wouldn't print), that appeared to be already installed. (Generating a list and simply running `apt install missing_dependency_name` yielded things like: **cups is already the newest version (2.2.10-6+deb10u4).**)

Worth noting:
> Ubuntu often has dependency issues with HPLIP based on my clicks around the web while researching this problem.  The below steps should work for other supported distros, too.

## Scroll Past for the Fix - Troubleshooting Overview:
1. I decided to install the latest version, via backports:
```bash
apt -t buster-backports install hplip-gui
```
(`hplip` is a dependency of hplip-gui and will be installed, too) -- the same dependency problems surfaced, even though the version was a minor point release away from HP's Sourceforge version.

2. I gave the [Sourceforge](https://developers.hp.com/hp-linux-imaging-and-printing) installation method, a shot
  - After the run script downloads, make it executable: `chmod +x hplip*.run`
  - Run it: `./hplip*.run`
    - Follow the prompts
    - Finally, most of the dependencies are resolved! But...
    ```text
    error: A required dependency 'pyqt4-dbus (PyQt 4 DBus - DBus Support for PyQt4)' is still missing.
error: A required dependency 'pyqt4 (PyQt 4- Qt interface for Python (for Qt version 4.x))' is still missing.
error: Installation cannot continue without these dependencies.
error: Please manually install this dependency and re-run this installer.
```
Take note that pyqt4 is not in Debian's repos.  This app works perfectly fine in Qt5, so I'm unsure of why they chose this requirement.  Doing a check for something *greater* than the minimum version would make more sense, here; rather than a hard stop at the 'last' supported version.

3. Disable Qt4 in the config:
```bash
pico /etc/hp/hplip.conf
```
...it was already disabled:
```text
qt3=no
qt4=no
qt5=yes
```

## The Fix
Compile the run script and *disable qt4* at install time!
1. Run `ls -l` and you'll see a directory with read permissions for your root/sudo user was created, launch sudo/root and then `cd` into that directory
2. Run the makefile with qt4 disabled (this picks you up where it left off before complaining about dependencies):
```bash
./configure --prefix=/usr --enable-qt5 --disable-qt4
```
3. Make it:
```bash
make
```
4. Now, install:
```bash
make install
```
Printing now works!

### Do You Repeat all of this Nonsense for Updates?
No, if you accepted:
> Would you like to have this installer install the hplip specific policy/profile (y=yes*, n=no, q=quit) ? y

The app should be self-updating.  This setting is also accessible from the GUI:
1. Open HP Device Manager app
2. Configure > Preferences
3. Click the System Tray Icon tab
 -  [x] Check and notify HPLIP updates
