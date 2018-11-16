# Troubleshooting Switches in IOS

Display error counters
```bash
show interfaces counters errors
```

Filter `show interface` to output errors in an overview
```bash
show int | i line|errors
```

Zoom in on total drops for a particular interface
```bash
sh int Gi0/1 | in drop|bits
```

Zoom errors
```bash
show interface Gi0/1 counters errors
```

Reset counters
```bash
clear counters Gi0/5
```
