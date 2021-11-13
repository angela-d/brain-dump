# Linux Printers
A script to automatically add authentication-based printer queues to Linux-based systems (for client-side use with printer server setups that use something like Papercut).

## Pre-requisites
Get the PPD for non-generic printing.

Note that this is almost never necessary for home printing; you can normally just upload the PPD along with naming your queue and that's it; this setup is more complex because it's being automated.

1. Go to [Open Printing](https://openprinting.org/printers/manufacturer/KONICA+MINOLTA) and download the closest sounding match your system
  You can see which ones I took by looking at the 5th argument of the **printList** lines with the queue names.
2. Go to https://localhost:631/ and add a test printer (if prompt for logins, it's asking for your *root*/admin user name and password)
3. When prompt for PPD upload, throw your Konica Minolta in there (repeat, if necessary)
4. Run `lpinfo -m | grep -i konica` to see your drivers; here's one of mine:
  ```bash
  lsb/usr/OpenPrinting-KONICA_MINOLTA/KONICA_MINOLTA/KONICA_MINOLTA-C252_PS_P-Postscript-KONICA_MINOLTA-en.ppd.gz KONICA MINOLTA C252 PS/P , Postscript-KONICA_MINOLTA 20130226 (OpenPrinting LSB 3.2)
  ```

5. These are accessible from:
  ```bash
  /opt/OpenPrinting-KONICA_MINOLTA/ppds/KONICA_MINOLTA/
  ```
  - Note that argument 5: `$5` is referenced like so:
  ```bash
  PPD_PATH="/opt/OpenPrinting-KONICA_MINOLTA/ppds/KONICA_MINOLTA/$5-Postscript-KONICA_MINOLTA-en.ppd.gz"
  ```
  and
  ```bash
  "KONICA_MINOLTA-500_420_360_PS_P"
  ```

6. If any of yours are different than mine, change them to suit.

## Setup
Run the **linuxprinters** script in your terminal and follow the prompt.
- You'll be asked for your Active Directory username, this will pre-associate you to Papercut's queue
- Subsequent prompts will inform whether or not the queues were successfully installed

### Caveat
LPD printing has been deprecated in CUPS, so this isn't a long-term solution!
