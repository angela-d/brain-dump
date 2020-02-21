# Pushing to Multiple Git Repos
Submit code changes to multiple repositories in one swoop, without having to target origins or run sequential commands.

I do not edit any of these repos directly - I maintain the codebase on my desktop and **push** from there.  If you plan to edit & push from various locations (desktop, Github/Bitbucket, intranet, etc), my notes are not tested in such scenarios.

For command-line based git, using `pushurl` in `.git/config`

1. Assuming the repo already exists locally, edit `.git/config` inside that repo
2. Under `[origin]` append any repo you'd like to push to while running `git push`:

before:
```bash
[remote "origin"]
	url = git@github.com:angela-d/brain-dump.git
	fetch = +refs/heads/*:refs/remotes/origin/*
```

after:
```bash
[remote "origin"]
	url = git@github.com:angela-d/brain-dump.git
	fetch = +refs/heads/*:refs/remotes/origin/*
	pushurl = git@github.com:angela-d/brain-dump.git
	pushurl = git@notabug.org:angela/brain-dump.git
```
It is **important** to re-add your 'master' repo (whoever was there, first) as a pushurl, otherwise, you'll find that repo doesn't get any new changes...!

## Push to Intranet Repos, too
This also works for internal repositories not hosted on the web.

Pre-requisites:
- SSH access to the remote server
- Existing git repo, or a git bare directory

First, make sure you load your SSH key, to avoid having to enter/enable password authentication (replace username & intranet IP to suit - this should be the user that has the repo, not root):
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub remoteuser@172.16.4.30
```

Append the remote target to your local `.git/config`:
```bash
pushurl = ssh://remoteuser@172.16.4.30:/home/remoteuser/repodirectory.git/
```
If your SSH port is something other than 22, use a SSH alias, at `~/.ssh/config`:
```text
Host intranetalias
HostName 172.16.4.30
Port 2222
User remoteuser
```
Use the following `pushurl`, instead:
```bash
pushurl = intranetalias:path/to/repodirectory.git/
```

If the repo already exists on the remote target, git will warn you you'll potentially have problems if you continue pushing to it.  You can set the repo to 'update instead,' by running the following in the target machine's repo (destination):
```bash
git config receive.denyCurrentBranch updateInstead
````
^ If the above is a use-case, your git repo path is more likely to be:
```bash
pushurl = intranetalias:path/to/repodirectory/
```
