# Removing the Channel from the Bar Gauge
On a bar gauge graph (with data pulled from the PRTG datasource plugin), the graph legend is like so:

Which is:
*Device: Channel*

Device | Graph Bar
-------|-------
Linux VM: Free Memory | //////////////////
Windows VM: Free Memory | //////////

The **: Free Memory** (channel) is repeated for *every* device on the map.. I'm not yet sure if this is intended behavior, or a bug, but aside from adding a toggle (which would require editing a few files) - the next simplest step is to manually remove it.  

**(When you update the plugin, you'd have to redo the change, again.)**

This setting is controlled by the following script:
- (Windows installs) `C:\Program Files\GrafanaLabs\grafana\data\plugins\jasonlashua-prtg-datasource\dist\datasource.js`
- (Linux installs) `/var/lib/grafana/plugins/jasonlashua-prtg-datasource/dist/datasource.js`

Change:
```javascript
if (_.keys(devices).length > 1 || target.options.includeDeviceName) {
  alias = item.device + ": " + alias;
}
```

To:
```javascript
if (_.keys(devices).length > 1 || target.options.includeDeviceName) {
  alias = item.device;
}
```

Then, refresh your map.  (Logging out or restarting the Grafana server isn't necessary.)

Your map legend should now look much cleaner, with only the device name listed:

Device | Graph Bar
-------|-------
Linux VM | //////////////////
Windows VM | //////////
