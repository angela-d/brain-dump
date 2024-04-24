# Disable Secure Time Seeding

> Windows feature that resets system clocks based on random data
>
> [source](https://arstechnica.com/security/2023/08/windows-feature-that-resets-system-clocks-based-on-random-data-is-wreaking-havoc/)

I wasn't able to locate an existing GPO for this setting, but given the havoc it's wreaked for those that ran into this unfortunate "feature," it's worth disabling and revert to trusty old NTP for time verification.

## Make a Custom GPO Targeting the Registry Key

1. Check your existing value: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config`

    - Value Name: `UtilizeSslTimeData`
    - Value Type: `REG_DWORD`
        - If `1` is present, this "feature" is active

2. Disable UtilizeSslTimeData feature:

    - Move a testing machine that has this feature active to a testing OU
    - Inside the testing OU, right-click > Create a GPO in this domain, and link it here
    - Name it
    - Right-click on the newly-created GPO, navigate to the following: Computer Configration > Preferences > Windows Settings > Registry
    - In the right-pane, right-click > New > Registry Item
    - Set your object like so:
    ![registry gpo](/img/disable-secure-time-seeding-gpo.png)

3. Wait up to 90 minutes and check your testing machine's GPO to ensure the registry key has been flagged to 0

    - Depoloy to your domain controller's GPO OU
