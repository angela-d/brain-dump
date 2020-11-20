# Upgrading VMware ESXi without Update Manager

**This is for VMware's basic images, not vendor-specific images like Dell EMCs**.

 [According to this Dell rep](https://www.dell.com/community/PowerEdge-OS-Forum/R620-R610-patching-dell-esxi-5-5-to-dell-esxi-6-0u3/td-p/5148907) you can use VMware's repositories for Dell servers.

 [My notes](vmware-esxi-custom-image-upgrade.md) on custom image upgrades.

## First, offload VMs to another host, a reboot will be required.

Enable SSH in ESXi:
- Host > Manage > Services > TSM-SSH > select > Start

Now login to the CLI via your terminal (Replace `192.168.1.2` for your ESXi address):
```bash
ssh root@192.168.1.2
```

Check what version is currently running:
```bash
vmware -vl
```

> VMware ESXi 6.5.0 build-8294253
>
> VMware ESXi 6.5.0 Update 2

Allow outgoing connections in the local firewall
```bash
esxcli network firewall ruleset set -e true -r httpClient
```

Get a list of available profiles we can update to
```bash
esxcli software sources profile list --depot=https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
```

*No verbose output, will take a bit to grab the info from VMware's servers.*

- Copy/paste the output into a spreadsheet so you can sort to get the latest you're willing to upgrade to.. the output is mixed order.  In LibreOffice: Data > Sort > tick Descending

Do a dry run to see what will happen (I chose *ESXi-6.5.0-20181103001* from the profile output as what I'm going to update to.)
```bash
esxcli software profile update -d https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml -p ESXi-6.5.0-20181103001-standard --dry-run
```

Go for the real update and hope for the best..
```bash
esxcli software profile update -d https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml -p ESXi-6.5.0-20181103001-standard
```

*Once again, no verbose output.. leave it and let it do it's thing.*

Once it's done, you'll see the empty prompt return in your CLI:
> [root@vmware:~]

Lock it back down and disallow outbound requests, once again
```bash
esxcli network firewall ruleset set -e false -r httpClient
```

Reboot for changes to take effect
```bash
reboot
```

Step away for a few moments and give it time to boot up.

Once it's back up, log back into ESXi's SSH to ensure the build has updated:
> [root@vmware:~] vmware -vl
>
> VMware ESXi 6.5.0 build-10719125
>
> VMware ESXi 6.5.0 Update 2

or

```bash
uname -a
```

> VMkernel vmware 6.5.0 #1 SMP Release build-10719125 Nov  4 2018 15:44:22 x86_64 x86_64 x86_64 ESXi

Confirm on [VMware's site](https://docs.vmware.com/en/VMware-vSphere/6.5/rn/esxi650-201811001.html) the build is what you wanted.

***
Unexpected issues sometimes happen:

##  [Errno 28] No space left on device

There's a high likelihood you're *not* out of space, eventhough you get this poorly-worded "error."

In the ESXI GUI:

Under **Navigator** > Host > Manage > (under the **System** tab) > Swap

- Make sure Swap is **Enabled**
- If **Datastore** is none, tick *Edit Settings* and select a datastore for a swap file to be created if the upgrade needs additional RAM
- Local swap enabled: **Yes**
- Host cache enabled: **Yes**
- Save settings

Re-submit your upgrade command.
