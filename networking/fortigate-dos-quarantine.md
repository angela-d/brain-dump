# Fortigate DoS Quarantine Setup
By default, the DoS policy doesn't actually "block" the attackers for hitting thresholds - it blocks the requests they make; only *after* the threshold is met.

After those requests close, they're able to make new ones.

To make good use of the denial of service filtering features, you'll want to enable quarantines on each policy to essentially put the attacker in jail for hitting a threshold.

1. First, go to **Policy & Objects > IPv4 Dos Policy**  and create one if it doesn't exist
 - Incoming interface: your "public" interface
 - Source: all
 - Destination: all
 - Services: all

2. A page full of toggles will appear, tune to your needs and experiment before setting anything super low, or hit the Fortinet forums to see examples of others' rules.

3. The quarantine options don't appear in the GUI, so you'll need to go into the CLI to set them. (Download a backup of your rules, then you'll have a nice set of example commands, too)

4. Open your backup and search for `config firewall DoS-policy` - this is the section you'll be editing.  Here's an example of the commands you'll need to run:
```bash
config firewall DoS-policy
edit 1
config anomaly
edit "icmp_flood"
set quarantine attacker
set quarantine-expiry 10m
next
end
end
```
The above modifies the `"icmp_flood"` rule and injects the quarantine options.  The `next` and `end` command finish out the code block, so the Fortigate knows to save it.  `edit 1` corresponds to the rule you want to modify from the DoS Policy page (you can have multiple rule sets).  If you download a new copy, you'll see some new lines added to the icmp_flood entry:
```text
edit "icmp_flood"
    set status enable
    set log enable
    set action block
    set quarantine attacker
    set quarantine-expiry 10m
    set threshold 50
next
```

## Customizations
- To see what options are available in edit mode, simply type `?` and the Fortigate will show what commands are at your disposal
- `set quarantine-expiry 10m` can be: `<###d##h##m>    duration (minimum 0d0h1m)` - note that `60m` will fail; you must do `1h`, instead
- To modify an existing quarantine threshold, simply re-run the command with a new value

## Viewing the Quarantine
In the GUI, you can access the DoS quarantine under **Monitor > Quarantine Monitor**
- To remove any good guys mistankenly filtered, just select > delete (at the top)
- See below to add preceeding rules to whitelist trustworthy services you want to allow to probe your system with greater packet allocations (deleting from the quarantine is note a 'whitelist')

## Worth Considering
- If an offsite third-party monitoring tool uses ICMP or other means to track your system, you'll want to prefix a rule to whitelist them

- If you use any chatty services like Filewave, you will want to ensure you have a preceding rule above any strict thresholds (instead of having just a rule 1, make the chatty service the focus of rule 1 with a much higher threshold than anything set in rule 2) - rule 2 should then be a catchall with reduced thresholds for *all* -- anything not met by rule 1 will hit rule 2 and get thumped out.

Take note of the edit number (edit 1 or edit 2) if you start adding multiple rules.

## Enable Email Alerts
To optionally receive notifications for these attempts, in the GUI, go to: **Log & Report > Email Alert Settings** and toggle *Intrusion detected*
