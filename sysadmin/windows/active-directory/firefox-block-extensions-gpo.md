# Allow or Block Extension Install via GPO on Firefox
The procedure for Firefox extension whitelisting is a little less straightforward than with Chrome/Edge, due to Firefox's extension IDs.

## Setup
Make sure you have all of the extensions installed to an existing Firefox browser already.
1. Go to `about:support` in your setup browser
2. Under **Extensions** you'll see a list of installed extensions; the **ID** column is what you'll need next
3. GPO: Computer Configuration > Administrative Templates > Mozilla > Firefox > Extensions > Extension Management
  - [x] Enabled
  - Options: *see below*
4. From the [official documentation](https://github.com/mozilla/policy-templates#extensionsettings), plop your extension IDs in the following structure into the **Options** field:
  ```json
  {
  	"*": {
  		"blocked_install_message": "Please contact IT if you wish to install this addon",
  		"install_sources": ["https://addons.mozilla.org/"],
  		"allowed_types": ["theme", "extension"]
  	},
  	"uBlock0@raymondhill.net": {
  		"installation_mode": "force_installed",
  		"install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
  	},
  	"{446900e4-71c2-419f-a6a7-df9c091e268b}": {
  		"installation_mode": "allowed"
  	},
  	"CanvasBlocker@kkapsner.de": {
  		"installation_mode": "allowed"
  	},
  	"CookieAutoDelete@kennydo.com": {
  		"installation_mode": "allowed"
  	},
  	"jid1-BoFifL9Vbdl2zQ@jetpack": {
  		"installation_mode": "allowed"
  	},
  	"ddg@search.mozilla.org": {
  		"installation_mode": "allowed"
  	},
  	"@testpilot-containers": {
  		"installation_mode": "allowed"
  	},
  	"google@search.mozilla.org": {
  		"installation_mode": "allowed"
  	},
  	"support@lastpass.com": {
  		"installation_mode": "allowed"
  	},
  	"{73a6fe31-595d-460b-a920-fcc0f8843232}": {
  		"installation_mode": "allowed"
  	},
  	"jid1-MnnxcxisBPnSXQ@jetpack": {
  		"installation_mode": "allowed"
  	},
  	"uMatrix@raymondhill.net": {
  		"installation_mode": "allowed"
  	}
  }
  ```
  
## Block Installation of Unapproved Extensions, Remove Any Previously Installed
To disallow (and remove) any extension not listed in the JSON, GPO: Computer Configuration > Administrative Templates > Mozilla > Firefox > Extensions > Extensions to Uninstall
  - [x] Enabled
  - Show > Value: `*`

### Worth Noting
When utilizing the **Extension Management** GPO, you don't need *Extensions to Install* when force installing extensions.
