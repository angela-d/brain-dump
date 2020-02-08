# Troubleshooting the Grafana-PRTG Plugin
Taking note of issues I run into!

## Values Don’t Quite Match Up
Check the timing in the top right (of the dashboard).

Set the quick range to Last 5 Minutes. Make sure that the Value Stat is set to **Current** (under *Visualization*), as it defaults to Average

***

## l is undefined
I encountered this when I added a device to a group that was running a graph.

**Cause:**
- (In PRTG) Device/Sensor Settings > Scanning Interval: 4 hours

**Why it Caused the Map to Return as Undefined:**
- The dashboard (Grafana) is set to pull data from the last 6 hours

**Fix:**
- Adjust either the PRTG scanning interval or how long the dashboard goes back
- Changes won't be immediate; log out of the dashboard/clear cookies and/or trigger a sensor scan on PRTG (click the two arrows or the chevron > Scan Now)

Not sure why this didn't gracefully fail and grey out the particular sensor object.. bug in either the plugin/Grafana, perhaps.  Though its worth noting on the TV Display (Pi that runs throughout the night), I *did* see a similar object greyed out on the same graph during the morning.

The instance that prompted me to take note of this was triggered while adding new devices and viewing on my PC, so plausibly a cache bug.  I suspect the same warning appeared on the Pi, but no one was around to see it.  By the time it was seen, the cache was created?  Not enough info to submit a bug report, yet.

***

## Query > Metrics > Can Only Select *
I ran into this a few times, it seems the API refresh gets hung up (or caching interferes).  Haven't noticed a pattern as to why or what gets done to cause it, yet.

Things to look for:
- Date format of the user accesing PRTG's API from Grafana has to have their date format (in their PRTG profile) set to `MM/DD/YYYY HH:MM:SS (AM/PM)`
- Make sure the *correct* group is being called (search the **Group** in PRTG and see if the device appears in the results, if it doesn't, move it to the group)
- Log out of Grafana and log back in
- After devices are moved to other groups, **log out** every time
- CSP warnings in Firefox (portions of the javascript stopped loading as a result of this trigger, logging out and logging back in seemed to correct itself)

Also useful:
- Sometimes it takes a while for the sensors to appear, simply tabbing or clicking to other fields can trigger the pull-downs to populate (I've found it takes a few seconds of doing this, sometimes - not sure if it is the trigger of the form updating, or simply entertainment while waiting for the dynamic refresh...)
- Disable caching via the browser console:
  - Right-click on a blank part of the page > Inspect element > click the `...` in the far right of the console window > Settings > check **Disable HTTP Cache (when toolbox is open)** and leave the console open while testing

- Read the console messages in this same window (under the console tab)
