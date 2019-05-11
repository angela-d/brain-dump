# Extension could not be verified for use in Firefox and has been disabled


### To turn this "feature" off (in ESR, may/may not work in other Firefox versions)
Not necessarily recommended for types that install random extensions
- Open `about:config` in the address bar.
- Find `xpinstall.signatures.required` and double-click to set it to **false**


### Less writes to SSD
Probably won't do a whole lot in the presence of adblockers, but why not
- Extend `browser.sessionstore.interval` from 15000 to a greater number like `1800000` / 30mins

Disable disk cache
- `browser.cache.disk.enable` to false
- `browser.cache.memory.enable` to true
