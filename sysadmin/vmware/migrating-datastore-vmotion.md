# Migrating to a New Datastore without vMotion
After adding a new network storage appliance, live VMs can be migrated while running, without vMotion licensing.

1. Make note of the VMs current host
2. Right-click > Migrate
3. For Migration Type, select **Change both compute resource and storage**
4. For migration destination, select a *different* host than where the datastore originated
