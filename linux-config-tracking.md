# Track Linux Config Changes with Git command-line

These instructions are distro agnostic, but written with Debian-based systems in mind (if running a CentOS-based distro, replace apt syntax for yum/dnf)

**Make a backup of the directory you'll be messing with.**

Make sure Git is installed; if not, install it
```bash
apt update && apt install git -y
```

- Navigate to the directory that has the config you wish to track, something like /etc
```bash
cd /etc
```

- Initialize a Git repository so we can start tracking our files
```bash
git init
```

Add your user info (tracks who made what commit; this is kind of useless if changes are only made locally, but do it anyway).  You only need to run these two commands once, during initial setup of the repository.
```bash
git config user.email "angela@example.com"
git config user.name "angela"
```

Note: add the `--global` flag if you want this to be a universal user on all Git repos on this machine.  Otherwise, you'll need to set the user per each repository (directory).

To see what Git is going to be tracking, you can run
```bash
git status
```

We probably don't want to track *everything* in /etc, so let's make a .gitignore file and throw everything in it, to start:
```bash
ls -A1 >> .gitignore
```
Now, Git tracks nothing in /etc.

Open `.gitignore` and delete the entries you *do* want to track > Save when done

Make a test file in a directory you've removed (whitelisted; for my test, I've whitelisted the */etc/xdg/* directory): `touch xdg/test.test && git status` to see the new pending change

You'll see output similar to:
```bash
root@debian:/etc# touch xdg/test.test && git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	xdg/

nothing added to commit but untracked files present (use "git add" to track)
```
Also self-explanatory; "No commits yet" means you've already commited your changes; hence the "new file" listing above.

To commit *everything* you've modified
```bash
git add .
```

OR, optionally, just one directories changes you modified (leave the rest un-commited)
```bash
git add xdg/*
```
Record a concise comment about why you made this change:
```bash
git commit -m "Add xdg changes"
```

...to submit all changes in the xdg/ directory.  Git supports globbing (wildcards), you can also omit the * and specify a singular file to narrow down what file is committed.

If a contained file matches something *else* in your .gitingore, like *systemd* you'll receive a warning from Git, like:

```bash
The following paths are ignored by one of your .gitignore files:
xdg/systemd
Use -f if you really want to add them.
```
How to handle it is fairly self-explanatory.  To see your new commit, run

```bash
git status
```
Which returns something like:
```bash
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   xdg/autostart/at-spi-dbus-bus.desktop
	new file:   xdg/autostart/gnome-initial-setup-copy-worker.desktop
	new file:   xdg/autostart/gnome-initial-setup-first-login.desktop
	new file:   xdg/autostart/gnome-keyring-pkcs11.desktop
	new file:   xdg/autostart/gnome-keyring-secrets.desktop
	new file:   xdg/autostart/gnome-keyring-ssh.desktop
	new file:   xdg/autostart/gnome-software-service.desktop
  ...
```
## Reviewing changes

```bash
git show --name-status
```
Will return something like:
```bash
commit d9daceec69f8c2c531b43852dd7b256a4f06f21b (HEAD -> master)
Author: angela <angela@example.com>
Date:   Sat Aug 25 14:22:20 2018 -0500

    Add xdg changes

A       xdg/autostart/at-spi-dbus-bus.desktop
A       xdg/autostart/gnome-initial-setup-copy-worker.desktop
A       xdg/autostart/gnome-initial-setup-first-login.desktop
A       xdg/autostart/gnome-keyring-pkcs11.desktop
A       xdg/autostart/gnome-keyring-secrets.desktop
A       xdg/autostart/gnome-keyring-ssh.desktop
A       xdg/autostart/gnome-software-service.desktop
A       xdg/autostart/gnome-welcome-tour.desktop
A       xdg/autostart/nautilus-autostart.desktop
A       xdg/autostart/nm-applet.desktop
A       xdg/autostart/orca-autostart.desktop
A       xdg/autostart/org.gnome.DejaDup.Monitor.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.A11ySettings.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Clipboard.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Color.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Datetime.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.DiskUtilityNotify.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Housekeeping.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Keyboard.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.MediaKeys.desktop
A       xdg/autostart/org.gnome.SettingsDaemon.Mouse.desktop
```
A = added, M = modified, D = deleted



You don't have to submit this as a remote repository (ie to Github, Bitbucket, etc.) Git works just fine locally.

However, if you'd like to give users access to modify config files without granting access to the server, Git is a fantastic way to allow them to collaborate without elevated access.  They can submit the changes to your Git repo, once you approve of their work, simply navigate to `/etc` and run:

```bash
git pull
```
to pull their changes and apply to the config.

### Making a remotely hosted repo
If your config has sensitive data like passwords, you may want to forgo remote hosting, irregardless if the repo is private or not.

The easiest way to provision a remote repo is to use the provider's GUI, which will ensure no duplicates or conflicts will arise.  If you use the CLI to create a remote repo, you run the risk of conflicts.

Once your remote repository is initialized, they'll provide you with a https or ssh URL, pick one and attach it to the local repo. (If you opt for SSH, make sure the local machine has your private key installed.)

```bash
git remote add origin [your remote git URL].git
```

Send it off (only run this command once, when you make your first push.  For subsequent pushes, `git push` will suffice)
```bash
git push --set-upstream origin master
```

### Branches (Modifiable versions that can stray from the master branch)
master = parent of the repository

branches = copies of the parent repo that can be changed and later merged into master, or kept entirely separate

Create a branch locally
```bash
git checkout -b branchname
```

Create it remotely (if using a remote repo) - note the --set-upstream flag only needs to be ran once, for a new repository.  For subsequent pushes, `git push` will suffice.
```bash
git push --set-upstream origin branchname
```

See what branch you're working in (worth checking anytime you want to make branch-specific changes, to ensure you're in the correct one)
```bash
git branch
```

Done editing and want to commit your work?
```bash
git add .
```

Leave a concise comment
```bash
git commit -m "Comment about changes"
```

Send to the remote repository
```bash
git push origin branchname
```

### Revision Snapshots

Useful for making points in time, like version numbers.  Unlike branches, tags *cannot* be modified, they're literal snapshots.
```bash
git tag v1.0
```
Now merge to it:
```bash
git push origin v1.0
```

### When something goes wrong
Haven't committed yet, but wish to undo your changes?
```bash
git checkout
```
Undoes all local changes (you will lose any edits in this directory)

***
**Undo a commit (pre-push)**

If you ran `git add .` and files you did not want getting sent to the repo came through, you can undo the entire commit:

```bash
git reset --hard HEAD^
```
'HEAD' (capitalized) is the most current part of the branch - the recent commit object and parent of the next commit.

`git reset --hard HEAD^` undoes all local changes (you will lose any edits in this directory)
***

**Deleting committed pushes from the repository**

Remove the commit

```bash
git reset --hard [long-string commit hash; last good commit]
```

Reset the head

```bash
git push origin HEAD --force
```

Run on all affected repositories

***
**Remove a tag snapshot**

```bash
git tag -d tagname
```

Now, remove it remotely

```bash
git push --delete origin tagname
```
