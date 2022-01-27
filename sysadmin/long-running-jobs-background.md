# Prevent Long Running SSH Jobs from Getting Lost if Wifi Disconnects
If you're on a terminal session running a long command, you don't want a sudden loss of connectivity to break your transfer.

## The Right Way
Start the command with the preceeding **nohup**:
```bash
nohup cp /lots_of_files /lots_of_files_destination
```
nohup will ignore hangups of the terminal session.

## Last Resort
If you forgot to precede with nohup, you can still save the session and force it into the background:
1. Press **Cntrl + Z** to suspend the running process
  - You'll see something like:
  ```text
  [1]+  Stopped                 cp -av /lots_of_files /lots_of_files_destination
  ```
  - **1** is your job ID
2. Run:
  ```bash
  disown -h %1
  ```
  which will detach the process from your terminal session
3. Run:
  ```bash
  bg
  ```
  to push the process into the background
4. Type `exit` to exit the terminal session (if there's an output stream, just type over it)

SSH back in under a new session and you should see it still going:
```bash
ps aux | grep cp
```
> angela      5121  6.3  0.0   8460  1716 ?        D    Jan24  12:07 cp -av /lots_of_files /lots_of_files_destination

Caveat: If done incorrectly, it can take several minutes for the original session to die.

There are other ways to do this; a common suggestion is `screen` - this is just the way I chose to do it.

## Compare Progress
If your content's destination is being moved from one volume to another, the easiest way to check without having to wait for a calculation is to run `df` with the human-readable flag:
```bash
df -h
```
- Run every few minutes and if you see the new volume growing, that's an indicator the background process didn't get lost.
