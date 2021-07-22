# Zero Trust Domain Admins
Not everyone on staff needs domain admin privileges.

In most cases, the elevated permissions aren't necessary; so "break glass" type accounts should be used.

## Local Administrator
Because there's always the risk of weird DC or propagation issues, it's wise to have a local admin account that's there in case it's needed, but is never used day to day.

1. **As administrator/domain admin:**

  - Search for Computer Management > Local Users and Groups > Users
  - Right-click > New User... (something long, impossible to guess/brute-force/alphanumeric, etc)
  - After the user is created, double-click it > Member Of tab > Add.. > administrators > Remove Users > Apply > OK
  - Tick Password Never Expires
  - Logout > logon as the user you just created (make sure remote access works, too)
  - Search > Notepad > Run as Administrator: if the UAC does not prompt for a password, you are good to go and ready to disable the built-in administrator.

2. **Disable the default, builtin administrator**

  - Search for Computer Management > Local Users and Groups > Users
  - Select Administrator > right-click > Properties:
  - un-tick User must change password at next logon (if checked)
  - tick account is disabled


3. Lock this user's credentials away in a safe and/or password manager; only for use outside of the scope not provided by AD delegation, as referenced below.

## Delegated Active Directory Management
As a domain admin:
- Create a security group for users to perform only password resets / other menial AD tasks; repeat as necessary
- Add the users (preferably *not* everyday accounts; but special-purpose accounts) you want to delegate to, to this group
- Right-click on the organization unit/OU you want this group to have access to modify > Delegate > select permissions to grant

There's more granular control outside of the wizard, see auditing notes on how to view/modify these permissions.

## Auditing/Modifying Existing Permissions
1. Open **Active Directory Users and Computers**
2. Navigate to the OU you want to check
3. Right-click > Properties > select the Security tab
4. Click the Advanced button (which group is selected doesn't matter)
5. The **Permissions** tab lists everything the user/group is allowed to do in this OU

  - To modify:
  - Select the user/group you want to adjust > Edit

## RSAT for Non-Windows Users
Users should not be using domain controllers to do non-administrative tasks like changing passwords, creating users (use scripts!), etc.

Microsoft released a free, handy tool called **Remote Server Administration Tools (RSAT) for Windows** that can be run on Windows 10/Windows Server and allow MacOS or Linux users to manage Active Directory over RDP.

Ideally, putting the [RSAT AD Component](https://docs.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/remote-server-administration-tools) on a Windows 10 / Windows Server VM and *only* using it for AD management.

1. Create a Windows Server 2019 (or above)
2. Allow Remote Access > select your security group(s) created earlier
3. Open Server Manager > Add roles and features:
  - Installation type: Role-based
  - Skip past Server Roles (no changes)
  - Under **Features**, select: Role Administration Tools > AD DS and AD LDS Tools
  - Finish the wizard (no restart necessary)
4. To manage AD, RDP into the VM you created for this purpose as one of your users in the security groups modified; open **Active Directory Users and Computers**
