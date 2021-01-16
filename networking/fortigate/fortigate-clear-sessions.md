# Clear Sessions on a Fortigate Firewall
The [official documentation](https://kb.fortinet.com/kb/viewContent.do?externalId=FD30042) is both sparse and information overload at the same time, lacking the fundamental example of what a properly-formed command needs to look like.

Executing the commands incorrectly will **compound** your filters and even if you get the next command perfect, because of the compounding, it'll never match.

> You do **not** need to reboot the firewall to clear sessions

## Proper Sequence of Filter Commands
For filtering and clearing sessions for sip:
```bash
diagnose sys session filter
diagnose sys session filter dport 5060
diagnose sys session clear
```

1. First sequence will show you the filters are all set to `any`
2. Second sequence sets the filter you're targeting
3. Final filter actually clears any match to the second sequence
4. Repeat the first 3 sequences for any other filters/ports you wish to target

If beginning on a new sequence to target another port, after the `clear` is still showing your original port (for example, 5060) simply logging out of the terminal session and logging back in will clear the filters.
