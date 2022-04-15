# Removing the Channel from a Time Series Graph
On a time series graph (with data pulled from the PRTG datasource plugin), the graph legend is like so:


    *Sensor Name: Channel*



The **: Channel**  is repeated for *every* device on the graph.. I'm not yet sure if this is intended behavior, or a bug, but aside from adding a toggle (which would require editing a few files) - the next simplest step is to manually remove it.  

**(When you update the plugin, you'd have to redo the change, again.)**

This setting is controlled by the following script:
- (Windows installs) `C:\Program Files\GrafanaLabs\grafana\data\plugins\jasonlashua-prtg-datasource\dist\datasource.js`
- (Linux installs) `/var/lib/grafana/plugins/jasonlashua-prtg-datasource/dist/datasource.js`

Change:
```javascript
if (target.options.includeSensorName) {
  alias = item.sensor_raw + ": " + alias;
}
```

To:
```javascript
if (target.options.includeSensorName) {
  alias = item.sensor_raw;
}
```

Then, refresh your map.  (Logging out or restarting the Grafana server isn't necessary.)

Your map legend should now look much cleaner, with only the device name listed:

Sensor Name1

Sensor Name2
