# Find Datastore by ID in ESXI
When I did a re-scan of the VMware hosts, PRTG no longer reports the "friendly" datastore name, but the UUID.

For example: 5b753e3e-d28d7814-7cc9-a4badb17efd2


To track down (and label them), first enable SSH on the ESXI host by logging into the host directly (outside of vCenter):
- Host > Manage > Services > TSM-SSH > right-click > Start

Login via CLI/terminal:
```bash
ssh root@esxihost.example.com
```

To find the corresponding VM name, run:
```bash
esxcli storage filesystem list | grep -i 5b753e3e-d28d7814-7cc9-a4badb17efd2
```

You'll see:
```text
/vmfs/volumes/5b753e3e-d28d7814-7cc9-a4badb17efd2  LinuxVM         5b753e3e-d28d7814-7cc9-a4badb17efd2     true  VMFS-6
```

With `LinuxVM` being the friendly name of the datastore.

Be sure to disable SSH on the ESXI host when done.
