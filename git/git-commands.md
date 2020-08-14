# Git Commands
I use git almost daily so I don't really need my cheat-sheet anymore, but there are always instances that call for uncommon scenarios.

Taking note of these, so I don't have to dig for them the next time they're needed.

## Delete a Commit from the History (Plus it's contents)
If you committed a mistake to the repo that shouldn't stay in the history; a hard reset can clean it up - providing it's executed rapidly.  If other systems/users have already received this commit, this will cause a mess.

For use in situations where you know nobody pulled, yet:
1. Run `git log` and get the commit hash of the commit you want to return to (delete everything else after)
2. Reset it:
```bash
git reset --hard [commit hash]
```

3. Force push it to the repo:
```bash
git push -f
```

All should be well

***

## Specify an SSH Key During `git push`
This error:
> Pushing to git@bitbucket.org:username/repo.git
>
> Forbidden
>
> fatal: Could not read from remote repository.

typically occurs when Bitbucket doesn't find the key it expects to see. (id_rsa, usually)

- Host = alias for bitbucket.org
- HostName = actual destination for the alias
- IdentityFile = path to your preferred SSH key
- IdentitiesOnly = override sending the wrong key for multiple users/identities (identities are tried in sequence)

In your local `~/.ssh/config`:
```bash
Host bblocal
HostName bitbucket.org
IdentityFile ~/.ssh/keyname
IdentitiesOnly yes
```

In the repo's `.git/config`:
- All spots where you have entries like `git@bitbucket.org:username/repo.git` change `bitbucket.org` to your alias: `bblocal`

### Example
From:
```bash
url = git@bitbucket.org:username/repo.git
pushurl = git@bitbucket.org:username/repo.git
```

To:
```bash
url = git@bblocal:username/repo.git
pushurl = git@bblocal:username/repo.git
```
