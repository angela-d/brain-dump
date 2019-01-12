# cPanel Git Deployment

cPanel's version of git adds an "auto-deployment" feature that seems unnecessary, as git natively supports custom hooks.

To essentially bypass having to manually add a list of modified files to *.cpanel.yml* everytime you're ready to push your changes, (so cPanel knows what goes where), you can use the fancy bash flags: `-ru`

From `man cp`:
- `-r` =  **-R, -r, --recursive** - copy directories recursively
- `-u` = **-u, --update** - copy only when the SOURCE file is newer than the destination file or when the destination file is missing

### To use
- Copy my *.cpanel.yml* file into your site's **main** public directory (the stuff that loads when you go to www.example.com)
- Open `.cpanel.yml` and replace **YOUR_USER** for your cPanel username.
- If your directory path differs, adjust accordingly.

Easy.  Now you can use cPanel's git just as easily as self-hosted git.
