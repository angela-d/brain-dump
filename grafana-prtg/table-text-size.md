# Changing Table Text Size in Grafana 
For some reason, font size appears to be hardcoded in Grafana, which makes displaying on TV screens and embedded devices look a bit unappealing.

A workaround to add your custom css is to install the [Boom Theme Plugin](https://grafana.com/grafana/plugins/yesoreyeram-boomtheme-panel/)

1. Add a new visualization and select Boom Theme panel
    - Add New theme
2. Specify your custom CSS, here's mine:
    ```css
    html {
        overflow: scroll;
        overflow-x: hidden;
    }
    ::-webkit-scrollbar {
        width: 0;  /* Remove scrollbar space */
        background: transparent;  /* Optional: just make scrollbar invisible */
    }
    /* Optional: show position indicator in red */
    ::-webkit-scrollbar-thumb {
        background: #FF0000;
    }
    .panel-container {
        background-color: rgba(0,0,0,0.3);
    }
    /* selector used in the table panel */
    [class*="tableContentWrapper"] {
        font-size:1.8em;
    }
    ```
    - Adjust size to suit


## Pick other elements to customize
All browsers have element inspectors now, in my notes I reference Firefox.
1. View your dashboard on a PC and right-click > Insepect element on the area you want to change font size for
2. Use the editor, which will highlight the active areas of the page when you match the CSS classes
3. Use a wildcard selector; Grafana's class naming appears to be dynamic - targeting the static portion of the class should allow the elements to get your overrides