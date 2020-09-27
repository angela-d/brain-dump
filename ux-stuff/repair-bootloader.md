# Repairing a Bootloader on a Dual-boot System

There's a lot of different approaches to fix missing or broken bootloaders.  This is my preferred approach.

## Symptoms
- Can no longer boot into a Linux install, but the partition still exists (confirm via Windows' diskpart, or a live USB from a Linux distro > file manager > Other)

## Common Causes
- OS upgrade replaces grub with another bootloader (can be Windows, or another Linux dual-boot system that changes grub)
- Deleting the grub partition (be extra cautious when deleting stuff from mounted drives..!)

## Common Roadblocks
### Windows
Problem:
- For a mangled Windows installation, booting from a Windows iso shows a flashing dash or cursor on a black screen

Fix:
- Most likely a problem with the installation media; how did you make the bootable USB?  
  - In my experience, [Rufus](https://rufus.ie/) is the most reliable way to make bootable USBs for Windows-based systems.
- If this flashing cursor appeared at random with no modifications to present operating systems, it may be symptomatic of a motherboard issue

***
### Linux-based Systems
Problem:
- For a mangled Linux distro, the machine boots into another OS

Fix:
- Boot into BIOS (F2 during the startup splash screen, on most systems) and make sure the system you want is in first order

***

Problem:
- Preferred OS doesn't appear in the BIOS boot order

Fix:
- Repair grub.  The absolute easiest way I've found to fix UEFI-based systems is [boot-repair-disc](https://sourceforge.net/p/boot-repair-cd/home/Home/)*

*For use on a machine that is Windows-based, you'll want to use [Rufus](https://rufus.ie/) to ensure it will be bootable!

***

**boot-repair-disc** is essentially a plug-n-play live environment (it will not overwrite any of your partitions with itself); its only pre-requisite is you'll want to ensure you have an active internet connection.

During the process, boot-repair-disc will prompt you to run a few commands in the terminal (which is conveniently pinned to the taskbar for you).  Then you're done!
