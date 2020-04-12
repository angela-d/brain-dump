# Firefox Disable DoH Trusted Recursive Resolver
Firefox enables this feature by "default" which cripples any DNS filtering you've done on your own networking setup.

To disable the DNS-over-https feature:
- Go to `about:config` in the browser's address bar
- Search for `network.trr.mode` and set to 5, to disable it completely
- Set `doh-rollout.previous.trr.mode` to 5

Setting to 0 instead of 5 should have the same effect.  5 signifies it was user-disabled and 0 indicates off/automatic.
