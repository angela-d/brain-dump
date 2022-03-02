# NPS / Network Policy Server Post-Setup
Some important to-do's must take place after setting up the network policy server.

While setup is very straight-forward, the overall maintenance and health is not.

For some reason, **Accounting** only rotates NPS logs *after the disk is full*.  Which should be never..

## Partition and Re-Assign Logging Destination
Open partition manager:

1. Shrink the disk NPS lives on
    - I made my new parition 1024MB

2. Open NPS > Accounting
3. Change the logging destination from `C:\Windows\System32\Logfiles` to **the parition created in step 1**

## Cleanup
If you let the defaults grow for too long, those log files become obnoxiously huge.

While they can be deleted without restarting anything (Event Viewer does not need to be restarted), it's probably best to not delete the latest one, until the date has aged and logs started storing to the new partition.

- Delete any aged `IN2202.log` type-named log (IN**YYMM**.log) and earlier - compare timestamps and leave the current one until you're certain it's no longer being written to
