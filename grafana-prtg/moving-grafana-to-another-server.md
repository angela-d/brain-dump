# Moving Grafana to Another Server
Easy as dragging files.

1. Stop the Grafana server
2. Copy the files from the old server to their new spots (same folder structure as the original)
3. Start the Grafana server

## Windows Systems
Copy the following folders from `C:\Program Files\GrafanaLabs\grafana`:
- `conf`
- `data`

## Linux-based Systems
Copy the following from `/var/lib/grafana`:
- `grafana.db`
- `plugins/` (your plugins folder)

From `/etc/grafana/`:
- `grafana.ini`
