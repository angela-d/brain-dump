# Block Microsoft Edge via GPO
Useful for kiosk computers that don't need unfettered web access.

## Computer GPO
My notes are specifically for computer-based policies; may work similarly as a user policy, but not tested.

1. Create a new GPO in the OU you'd like to disable Microsoft Edge in
2. GPO Path: `Computer Configuration / Policies / Windows Settings / Security Settings / Software Restriction Policies / Additional Rules`
  - In **Additional Ruless**, right-click > New Path Rule
  - Path:
  ```powershell
  C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
  ```
  - Security Level:
  ```powershell
  Disallowed
  ```
  - Description:
  ```powershell
  Block Edge
  ```

  That's it!

### Worth Noting
I originally set this as a firewall rule (which worked beautifully) until it was applied to a 20H2 machine.

Not sure if it's a bug or an override on that particular machine, but worth mentioning:

- GPO Path:
  ```powershell
  Computer Configuration / Security Settings / Windows Firewall with Advanced Security / Outbound Rules
  ```

**Default / web app path rule**

- Name:
  ```powershell
  Block Edge Outgoing
  ```
- Action:
  ```powershell
  Blocked
  ```

- Click to the **Programs and Services** tab
  - [x] All programs that meet the specified conditions
  - Under **Services** > Settings
  	- [x] Apply to service with this service short name
      ```powershell
      msedge
      ```

**System app path rule**

- Name:
  ```powershell
  Block Edge System App Outgoing
  ```
- Action:
  ```powershell
  Blocked
  ```

- Click to the **Programs and Services** tab
  - [x] All programs that meet the specified conditions
  - Under **Services** > Settings
  	- [x] Apply to service with this service short name
      ```powershell
      MicrosoftEdgeCP
      ```
