# Fix Inconsistent OTP Issues on Synology

I've encountered the OTP/MFA on a Synology to gradually become inconsistent; OTP would often not work at all.

This appears to be due to the system time slowly falling off.

This small script should fix that by forcefully resynchronizing the time.

## Setup
From the Synology admin:
- Go to Control Panel > Task Scheduler
- Create: `scheduled task` > `user-defined script`
- Under **Task Settings** > paste the script:
```bash
/sbin/ntpdate -u time.nist.gov
```
