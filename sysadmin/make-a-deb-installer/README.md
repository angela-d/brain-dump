# Making a Deb Installer
There are many different ways to make .deb packages, most of which are time consuming and prone to error (in my experience).

My preferred method is to use a more manual approach, with a 'skeleton' setup.  This method is not perfect and is only really useful if you want to do quick packages for yourself or to share with others; not for submitting to Debian's apt repository.

If you don't package applications all the time, it's easy to forget:
- What files need to be in a .deb?
- All of my folders are correct, why is debhelper throwing these errors?

## Skeleton Package
In this repo I left **skeleton-package-1.0** - this is setup so all one needs to do is simply fill in appropriate package info and plop the source components where they need to go.


## Requirements
Debian packages used by the .deb builder:
```bash
sudo apt install build-essential devscripts debhelper
```

- Go into **skeleton-package-1.0** and make it about your script (also rename the parent directory from **skeleton-package-1.0** to something that matches your application and version.)

### Manpages
To ensure your formatting isn't jagged up before you generate the deb, while inside the `debian/` directory of the package folder, run:
```bash
man ./skeleton-package.8
```

**What do the numbers mean in the manpage filename?**

skeleton-package.**8** - manpages have their own manpage that list the indicators:
```bash
man man
```

### Build the Package

Go into the **skeleton-package-1.0** directory (as a *normal*, non-sudo/root user) and build:
```bash
debuild -b -uc -us
```

That's it.  If all went well, you'll see **skeleton-package_1.0_all.deb** outside of the **skeleton-package-1.0** directory.

***

## Testing the Package
Install it:
```bash
sudo apt install ./skeleton-package_1.0_all.deb
```
Note: read the installer progress, you'll see:
> Post-install script has ran.

And now run the executable (non-sudo/root users can run, also; as it being housed in `/usr/bin` grants access):
```bash
skeleton-package
```

> You have installed Skeleton Package successfully!

Test the manpage:
```bash
man skeleton-package
```

Uninstall it:
```bash
sudo apt remove --purge skeleton-package
```

Watch, again:
> Post-remove script has ran.
