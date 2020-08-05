# AppStream fwupd Bug
While running `apt update`:
```text
AppStream system cache was updated, but problems were found: Metadata files have errors: /var/cache/app-info/xmls/fwupd.xml
Reading package lists... Done
E: Problem executing scripts APT::Update::Post-Invoke-Success 'if /usr/bin/test -w /var/cache/app-info -a -e /usr/bin/appstreamcli; then appstreamcli refresh-cache > /dev/null; fi'
E: Sub-process returned an error code
```

## Fix
Install the expat package
```bash
sudo apt install expat
```

Run it against the problematic file
```bash
xmlwf /var/cache/app-info/xmls/fwupd.xml
```

> /var/cache/app-info/xmls/fwupd.xml:3049:107: not well-formed (invalid token)

Line **3049** probably has a typo; unescaped ampersand most likely.. open nano and jump to line 3049
```bash
sudo nano +3049 /var/cache/app-info/xmls/fwupd.xml
```

The line in question:
```xml
<checksum type="sha1" filename="bc334d8b098f2e91603c5f7dfdc837fb01797bbe-Dell XPS 15 9560&Precision 5520 System BIOS_Ver.1.18.0.cab" target="container">ab33c392b0703946616181deadfd1cbb5b0c6cd4</checksum>
```
and there it is: `...560&Preci...`

- Change `&` to `&amp;` and save.
- You may have this occur on multiple lines - just repeat steps.
- Run `apt update` again and you should be good to go.
- Optionally emove expat if you don't think you'll need it, going forward: `apt remove --purge expat`
