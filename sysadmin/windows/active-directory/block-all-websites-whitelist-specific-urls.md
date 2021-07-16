# Block All Websites, Except those Whitelisted Firefox GPO
Using [Firefox GPO Templates](https://github.com/mozilla/policy-templates)

My notes are based on a **Computer** policy, it may be applicable for User-based policies, but not tested.

## GPO Policy
Blacklist policy:

- Path:
  ```powershell
  Computer Configuration / Policies / Administrative Templates / Mozilla / Firefox / Blocked websites
  ```

- Value:
  ```powershell
  <all_urls>
  ```


Whitelist policy:
- Path:
  ```powershell
  Computer Configuration / Policies / Administrative Templates / Mozilla / Firefox / Exceptions to blocked websites
  ```

- Value:
  ```powershell
  http://example.com/*
  https://example.com/*
  ```

If this is for a kiosk policy, at the time of writing, Microsoft Edge doesn't offer this capability, so the only option is to block all (until Microsoft has a comparable GPO): [Block Microsoft Edge](block-microsoft-edge.md)
