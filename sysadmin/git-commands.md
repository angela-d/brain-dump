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
