# Troubleshooting the Grafana-PRTG Plugin
Taking note of issues I run into!

## Values Don’t Quite Match Up
Check the timing in the top right (of the dashboard).

Set the quick range to Last 5 Minutes. Make sure that the Value Stat is set to **Current** (under *Visualization*), as it defaults to Average


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
