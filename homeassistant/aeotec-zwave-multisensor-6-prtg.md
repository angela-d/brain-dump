# Connect a Z-Wave Multisensor 6 Device in Home Assistant to PRTG
Use PRTG to monitor a Z-Wave Multisensor 6 device.  This assumes you already have a PRTG sensor group that you wish to add these sensors to, as well as have the Z-Wave devices active in Home Assistant.

![aeotec multisensor 6](aeotec-multisensor-6.png)

## Initial Setup
API tokens in Home Assistant expire 10 years from the date of issue (or until there's a breaking change, of course.)
1. Get an API token from Home Assistant: `http://your-home-assistant-url:8123/profile`
  - Under **Long-Lived Access Tokens** > Create token
  - Name the token appropriately to what it'll be used for
  - Immediately copy the token as its not stored in a recoverable place in Home Assistant
  - After you have your token, you can get the API path by clicking the device on the Home Assistant > Overview > (on a default dashboard) click the device you want the entity info for:
  - ![z wave dash](z-wave-dash.png)
  - Settings wheel > under **Entity ID**: `sensor.aeon_labs_zw100_multisensor_6_temperature`

## Test the API
Run the following in a terminal that has curl access
```bash
curl -X GET \
 http://your-home-assistant-url:8123/api/states/states/sensor.aeon_labs_zw100_multisensor_6_temperature \
 -H 'Authorization: Bearer YOUR_TOKEN_FROM_HA_PROFILE'
```
You should get all of your entities returned for `sensor.aeon_labs_zw100_multisensor_6_temperature`

## Setup a Sensor for PRTG
Now that you've confirmed your API token gets the info you want, you can create a sensor on PRTG.

1. Find the group/device you want to add the sensor to, click + (toward center of the page)
2. Find the **HTTP XML/REST Value** sensor type > click it
3. Enter values for your new sensor:
  - Name, ie: `Room XX Temperature`
  - URL: `http://your-home-assistant-url:8123/api/states/sensor.aeon_labs_zw100_multisensor_6_temperature` (or whichever sensor you're targeting)
  - XML Node (and optional property): `state`
  - Content Type in Header: Enable
  - HTTP Headers: `X:GET|Authorization: Bearer YOUR_TOKEN_FROM_HA_PROFILE`
  - Scanning Interval: `60 seconds`
  - Create

## Customizing the New PRTG Sensor
After you get your first successful read, now you can customize it.

The HTTP XML/REST Value sensor is one of the heavier types for PRTG, so it's probably a good idea to seldom check it, unless you have multiple probes or need a lesser frequency threshold.
1. Settings > Scanning Interval > `5 minutes`
2. Under Unit String > change from **#** to `%` > Save
3. Back on the sensor page, click the wheel icon beside the percentage readouts
4. Under Lookups and Limits > select `Enable alerting based on limits`
  - Set your preferred upper/lower limits in which PRTG will trigger errors or warnings depending on the value read of this sensor.
