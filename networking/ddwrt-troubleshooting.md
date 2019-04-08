# DD-WRT Troubleshooting

### Initial Setup
For Linksys WRT devices, flashing the latest **factory-to-ddwrt.bin** for an initial install does *not* work.  After a 'successful upgrade,' after the router reboots, I'm back in the Linksys dashboard seeing the stock firmware still in place.

Why:
- Linksys are turds and do a size check of the firmware being installed
- Newer DD-WRT images are around 39MB
- The threshold appears to be set around 30-32MB

Fix:
- Use an older image of DD-WRT
- I had success with [r35244](https://dd-wrt.com/support/other-downloads/?path=betas%2F2018%2F03-05-2018-r35244%2F) (30MB)

Once **factory-to-ddwrt.bin** successfully loads, head back in and flash the latest firmware to get yourself up to date.

No ill effects from upgrading from a 2018 (or older) to a 2019 image.
