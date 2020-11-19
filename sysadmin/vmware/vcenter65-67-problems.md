# vCenter 6.5 to 6.7 Upgrade Failures
Summer of 2020 my vCenter certificates were due to expire, so I renewed all of them prior to their expiry - only to find out after that expiry date, I did not actually renew *all* of them.

I had run into a problem relating to the SSL certificate bug (that was "fixed" by running a script and series of commands)

It appears this fix wasn't as thorough as I'd thought.  Or, operator error and the preceding success messages after running the tool were false-positives?

In any event, all of the certificates I interacted with on a regular basis were updated and active, nothing but the BACKUP certs shown as expired, so I thought this was good to go - until I attempted to upgrade vCenter to 6.7

- Running the ISO installer for upgrade deployed successfully, but:
- Upon starting phase 2 of the upgrade: certificate mismatch, pointing to a monolithic KB and nothing specifically relative to what I was seeing
- Download the log bundle from the upgrader by hitting the LOGS button
- Run `grep "mismatch" -R ./` in the root of the log bundle directory after extracting
```text
./var/log/vmware/upgrade/upgrade-source-requirements.log ERROR __main__ FAILED: Found upgrade requirements mismatches.
./var/log/vmware/upgrade/CollectRequirements_com.vmware.vmafd ERROR vmafdupgrade.certificateValidator Endpoint certificate machine_ssl_cert mismatch found.
...
 vmafd:CollectRequirements: ERROR vmafdupgrade.certificateValidator Endpoint certificate machine_ssl_cert mismatch found.
./var/log/vmware/upgrade/requirements-upgrade-runner.log INFO upgrade.states.component_states vmafd:CollectRequirements: ERROR vmafdupgrade.certificateValidator Endpoint certificate machine_ssl_cert mismatch found.
...
```

The fix: [ls_ssltrust_fixer_p2.py script](ls_ssltrust_fixer_p2.py)
1. Copy [ls_ssltrust_fixer_p2.py](ls_ssltrust_fixer_p2.py) to `/usr/lib/vmidentity/tools/scripts`
2. Run `python ls_ssltrust_fixer_p2.py -f scan` to check for mismatches
3. Run `python ls_ssltrust_fixer_p2.py -f fix` to fix found mismatches

After running the fix (and commencing the upgrade), the vCenter upgrade was successful.
