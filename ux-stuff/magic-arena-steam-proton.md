# Magic: The Gathering Arena Not Working on Linux

For the longest time I could not get MTG Arena to work on my Linux laptop - it would get past the login screen and end on the error "You have lost your connection to the server"

Logs for the game were of little help:

```text
[0] DETAILED LOGS: DISABLED
[0] Startup Timestamp: 10/1/2024 8:14:13 PM
[0] Loaded embedded metadata
[0] Initializing Steam
[0] Steam status: Available
[0] CredentialLoginContext created
[0] Environment set to Prod, AWS
[0] Version: 2024.41.10.6837 / 2024.41.10.6837.1094853 / 
[1] WwiseUnity: Wwise(R) SDK Version 2023.1.3 Build 8471.
[1] WwiseUnity: Setting Plugin DLL path to: Z:/storage/steam/steamapps/common/MTGA/MTGA_Data\Plugins\x86_64
[1] WwiseUnity: Sound engine initialized successfully.
[3] [TaskLogger]Steam AuthToken retrieved.
[200] [AssetBundleProvisioner] using default bundle provisioner
[201] [TaskLogger][Accounts - Startup] Player has rememberMe ID (refresh token) saved. Attempting fast login.
[257] Connecting to Front Door: frontdoor-mtga-production-2024-41-10-1.w2.mtgarena.com:30010
[257] [UnityCrossThreadLogger]Client.TcpConnection.ProcessFailure
[257] [UnityCrossThreadLogger]Client.TcpConnection.ProcessFailure {"SocketError":"Error looking up error string","function":"ProcessFailure"}
[258] [UnityCrossThreadLogger]Got non-message event: Wizards.Arena.TcpConnection.TcpClosedEvent
```

For most installs, you'll find this log in: `~/.local/share/steam/common/MTGA/MTGA_Data/Logs/Logs/`

## Fix

I disabled ipv6 at grub; modifying `/etc/default/grub`:

From:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 quiet"
```

To:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```

Then:
```bash
update-grub
```

- Reboot
- Launch Steam -> MTGA

ipv6 is not disabled by default on any distro to my knowledge, it's usually something you have to go out of your way to do.

I also opted to disable the Intel pstate driver, which is also set in the same config option:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=disable"
```

and use [autocpufreq](https://github.com/AdnanHodzic/auto-cpufreq)'s acpi driver in lieu.  If you're on an Intel-based machine, research the pstate driver and see if disabling would be applicable for your use-case.