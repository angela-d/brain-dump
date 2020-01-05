# Canon Pixma TR4520 Printer Driver Setup on Ubuntu
The auto-detect of Canon's TR4520 didn't bring in the necessary drivers for printer operations.  There are several different ways to install it, but this is the method I decided to go with.

## Obtain the driver from [Canon's website](https://www.usa.canon.com/internet/portal/us/home/support/details/printers/inkjet-multifunction/tr-series-inkjet/pixma-tr4520?tab=drivers_downloads)
Or, if the path has changed, I saved the file I used [here](canon-driver/cnijfilter2-5.70-1-deb).

- There is a [shell script](canon-driver/cnijfilter2-5.70-1-deb/install) you can run via CLI (run as your user, not sudo/root)
- Or a [.deb](canon-driver/cnijfilter2-5.70-1-deb/cnijfilter2-5.70-1-deb/packages/cnijfilter2_5.70-1_amd64.deb) - use the .deb if you plan to keep the driver up-to-date


### Install via shell script
- Navigate to the directory in your terminal where *install.sh* resides
- As your regular user (not sudo/root), run it: `./install.sh` and follow through the prompts
- That's it

### -- or --

### Install via .deb package
- Navigate to the directory in your terminal where *cnijfilter2_5.70-1_amd64.deb* resides
- In the terminal, run: `sudo apt install ./cnijfilter2_5.70-1_amd64.deb` (for 64-bit PCs, if you have a 32-bit machine, use the i386 .deb)

The printer should now be ready to use.
