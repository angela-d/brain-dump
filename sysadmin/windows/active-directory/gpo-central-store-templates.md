# Group Policy Objects Central Store
What's a Central Store
- Without one, you have to update/copy group policy templates in *each* DC, singularly
- **With** a central store, you plop GPOs in one spot, Active Directory will propagate to every member DC

## Create a Central Store for GPOs
This should only need to be done once.  After it exists, you just throw your new GPOs in it and they'll maneuver through your domain controllers automatically.
1. Log onto a domain controller
2. Navigate to `C:\Windows\SYSVOL\sysvol\your_domain\Policies`
3. While inside the **Policies** directory, create the folder `PolicyDefinitions`
4. Inside **PolicyDefinitions**, create the folder `en-US`

## Verifying the Central Store
To verify the central store is working, pick a GPO > Edit > navigate to: **Computer Configuration** > **Policies** > **Administrative Templates** It should now say the definitions are retrieved from the central store.

## Adding Custom GPO Templates
If you're adding new Microsoft-based templates, don't add them all to the DC, as they are bloated with things that are likely not needed.

Vendors (Microsoft, Google, Mozilla, etc) will offer these in their knowledgebase downloads, usually; I'll cite [Administrative Template files (ADMX/ADML) and Office Customization Tool for Microsoft 365 Apps for enterprise, Office 2019, and Office 2016](https://www.microsoft.com/en-us/download/details.aspx?id=49030) in my example.

1. Click download
2. You'll land on a page with two .exe for 32-bit and 64-bit, use the one for your system (likely admintemplates_x64_5089-1000_en-us.exe)
3. Run the .exe from Microsoft > on the prompt window, create a new folder on your desktop called "Office2016-ADMX"
4. Extract to that location
5. Go into the **Office2016-ADMX** folder on your desktop, you’ll see a list of files > pick out the GPOs you need and add them to your central store location (C:\Windows\SYSVOL\sysvol\your_domain\Policies)

File Type | Where to Put It
------------ | -------------
.admx (template settings) | C:\Windows\SYSVOL\sysvol\your_domain\Policies\PolicyDefinitions
.adml (template language) | C:\Windows\SYSVOL\sysvol\your_domain\Policies\PolicyDefinitions\en-US
