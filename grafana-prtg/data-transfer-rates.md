# Data Transfer Rates
Pulling the data transfer rates from an SNMP sensor was mildly tricky, as its currently only documented in the plugin's Github issues tracker.

- The measurement rates (set in **Visualization** > Unit for Graphs) are in [kilobits](https://kb.paessler.com/en/topic/75876-bandwidth-unit-and-measurement) (v4.0.3) or **bytes/sec** (v4.0.4) (see **Notes** below)
- The **Multiplier** option in the PRTG plugin had to be set to eiter `.01`, `.139`, `.1349` or `0.000008` to display a correct reading

Screenshot of the **Query** values:
![Transfer Rate](img/transfer-rate.png)

Screenshot of the **Visualization** measurement values:
![Measurement Values](img/visualization-measurement.png)


## Notes
- From v4.0.3 to v4.0.4, the calulcations vary *greatly*, so you'll have to compare PRTG to your charts to see what multiplier works best for you
- In v4.0.4, using kilobits (as documented by PRTG) gave wildly incorrect values from what v4.0.3 offered, using **bytes/sec** with a different multiplier gave more accurate results
