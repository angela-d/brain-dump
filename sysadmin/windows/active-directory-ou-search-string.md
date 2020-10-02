# Obtain the Active Directory OU Search String
For LDAP authentication, a quick and easy way to obtain the LDAP search string.

1. Open a cmd prompt
2. Run the following:
```text
dsquery user -name John*
```

This will return pre-formatted OU strings for all users matching `John`:
```text
"CN=John Smith,OU=Management,OU=People,DC=example,DC=com"
"CN=Johnny Smith,OU=IT,OU=People,DC=example,DC=com"
```


## Search by Active Directory Attributes
1. Open a cmd prompt
2. Run the following:
```powershell
dsquery * -filter "(&(objectClass=Computer)(objectCategory=Computer)(sAMAccountName=asset-tag123$))" -attr sAMAccountName distinguishedName
```
Returns:
```text
sAMAccountName    distinguishedName
ASSET-TAG123$     CN=asset-tag123,OU=Computers,OU=Computer_Assets,DC=example,DC=com
```

### To see other options offered by the `dsquery` tool:
```text
dsquery /?
```
