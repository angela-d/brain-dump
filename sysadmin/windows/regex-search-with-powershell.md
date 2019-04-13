# Regex Searches with Powershell

Make a `findthis.txt` file containing words you want to search:

```powershell
POST
payment
```

Run the following in a Powershell terminal:
```powershell
Get-Content .\current.log | Select-String -Pattern (Get-Content .\findthis.txt) > results.txt
```

- current.log is the target file you're going to search
- findthis.txt is your list of regex variables you're targeting
- results.txt is an extraction of your matches
