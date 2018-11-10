# Adding a Forward Lookup Zone in Active Directory Integrated DNS
FQDN = Fully qualified domain name (not an ip)

Start > search **DNS**

- Expand the primary domain in the tree
- Right-click on Forward Lookup Zone > New Zone

A New Zone Wizard will launch.

In the Zone Type, select the type of zone applicable to the project at hand. (Secondary zone for outward-facing domains with DNS managed by a third party.)

- Enter the FQDN of the domain
- Choose the appropriate type of updates for the project

Once that is complete, add an A record by going to the **Forward Lookup Zones** folder and navigate to the newly added FQDN.
- Right click the FQDN just added > New Host (A or AAAA)
- Enter the prefix of the domain and IP

Done.
