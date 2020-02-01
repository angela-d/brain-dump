## Building a Dashboard
Once you have an object set up how you like it, click the Save button in the upper-right corner of the page, or your work may get lost!

The same rule applies when sliding objects across the Dashboard - after a sensor object is created, it will appear instantly on your dashboard.  Once there, you can move it around by hovering and clicking its heading.

**On the left menu:**

*(Basic sensor objects)*

1. **+** > Create > Dashboard (or, if one already exists you want to add to, click the chart-looking button on the top-right)
2. Add Query > Query will have a few options, leave it at PRTG
3. Most board objects will utilize Metrics > Click Groups and you should see your Groups from PRTG load > select one (note that sometimes this section seems to lag, so if something isn’t loading right away, wait or save and come back to it) - try to trial a few singular channels, first; the tables and groups are trickier to get flowing until you become familiar with the plugin
4. Once your Group is active, click onto the Hosts box and you should see a further drilled-down menu of your group objects appear - if you’re building a graph where you want all of the objects to be grouped, select the star ( * )
5. Onto the Sensor field > same deal here
6. Channel will follow suit with the other options
7. As you're clicking around, you should start seeing your values filled in.

**Note that the values seem to default to priority, so you’ll want to pay attention to the values until you're sure the API is returning things correctly.**

**Nothing is returning, at all:**

Run a query test by selecting **Query Inspector** in the Add/Edit Panel > Query window

*(Grouped objects, like alert tables)*

1. **+** > Create > Dashboard (or, if one already exists you want to add to, click the chart-looking button on the top-right)
2. Add Query > Query will have a few options, leave it at PRTG
3. Query mode: Raw > URI: `table.json` > Query String: `content=sensors&columns=device,sensor,status,message,downtimesince&filter_status=4&filter_status=5`
4. Click to Visualizations (right-side graphical menu) > Table Transform: JSON Data > Columns: *[here you click + and specify what data you want to show; it should auto-detect on-click, what’s available for use]*
5. You should start seeing stuff appear in your sample window as you go.

**Rename Columns on Alert Tables**

While still on the **Visualizations** screen:
1. Add/modify any column you want to change
2. To rename the **device** field, under **Apply to columns named:** `device` > **Column Header:** `Device` - you should see the column header as capitalized after clicking the tab button.  Repeat for any other headers you want to change.

**Change Row Colors Based on Status (Tables)**

Option | Value
------------ | -------------
**Apply to columns named** |status_raw
**Thresholds** |`4,5` (warning,error)
**Color Mode** | Row

Experiment with the color pallete inside this table.
