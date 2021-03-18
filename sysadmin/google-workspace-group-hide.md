# Hide Groups from Compose List or Directory in G-Suite / Google Workspace
In G-Suite / Google Workspace, the ability to hide mailinglists or groups is not available in the web GUI.  This option is exposed via API.

The API can be utilized by using [GAM](https://github.com/jay0lee/GAM)

> GAM is a command line tool for Google Workspace (fka G Suite) Administrators to manage domain and user settings quickly and easily.

Since GAM authenticates to your Workspace account, you can install it on any server, but if you're already syncing Active Directory accounts, it makes the most sense to put GAM on the same server as your GADS installation.

## Setup
1. Download the latest GAM from the project [releases](https://github.com/jay0lee/GAM/releases) page
2. During installation, a batch prompt will appear to guide you through setup; you will need to provide your Google Workspace administrator account to authorize the API access via OAuth

During setup, you're first prompt if this is an existing or new install.  The menus are largely straightforward, though the final ones are slightly misleading -- once you get a prompt to "authorize" after you'd already done so, you have to continue through until there are no such further prompts.  There are multiple APIs that have to be authorized.

Failure to properly authorize all APIs will yield [this](https://github.com/jay0lee/GAM/issues/740).

## Virus Detected During Install/Upgrade
This did not occur for me, but worth noting: https://github.com/jay0lee/GAM/issues/1317

> This is a false positive on the part of AV vendors. GAM uses PyInstaller to compile the Python source code into an executable. Unfortunately many malware apps also make use of PyInstaller. AntiVirus vendors don't do the work to distinguish between the two, they just assume that any app using PyInstaller is a virus.

## Hide Groups from the Google Workspace Directory and Compose List
There are two approaches (if you sync users from Active Directory, as well as create standalone groups in G-Suite/Google Workspace).

Additionally, if you go into **Directory** settings, you can *hide* any `*_group@example.com` account by default, from within the GUI dashboard.  This option does *not* affect groups not named in the `*_group@example.com` syntax.

**Hide any type of group/naming syntax of group (G-Suite/Workspace-only groups)**
- For groups that can’t be hidden by OU.  For groups in an AD-managed OU, see below.
  - On the server you have GAM installed to, run the following via `cmd`:
  ```batch
  gam update group groupname@example.com include_in_global_address_list false
  ```
  In most cases, the command will execute successfully and the group will be hidden instantaneously, if it doesn't, re-run the command later.

**Hiding accounts & groups by OU (AD groups/users, not G-Suite/Workspace-only groups) for Directory only**
- By default, all OUs are shown within the directory.
  - From the admin dashboard, search **Directory** > proceed to Settings > expand your domain
  - Click the top-level 'People' OU > tick *Users in a custom directory*

    - I created a list, **Origanization Contacts** and added all people-groups to it (excluding service accounts).  When this is selected, users in these groups are the only users shown in the directory.

  - In order to also hide from Compose, you have to tun the GAM command against a particular group to hide.

## Hide a User
This does not require GAM and can be done from the [web dashboard](https://support.google.com/a/answer/1285988).

## Other Uses with GAM
The [GAM Wiki](https://github.com/jay0lee/GAM/wiki) has a detailed list of other commands available, with examples.

## Browse the Directory
As a user, navigate to your organizations [contacts](https://contacts.google.com) > Directory is on the left menu
