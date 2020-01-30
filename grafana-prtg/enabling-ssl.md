# Enable SSL on the Grafana Server
The following instructions are for a Windows-based install of Grafana.

At some point, you're logging into Grafana with a password.  Even on a private network, there could be other devices listening and waiting to grab your credentials that are  trasmitting in plain text.  It's a wise idea to use SSL and encrypt the transmission of your password, since it's quite easy to do.

It is also assumed you have an existing SSL cert on PRTG; if you don't, you can use [Let's Encrypt](https://github.com/angela-d/letsencrypt-intranet-automation).

- The server config is located at `C:\Program Files\GrafanaLabs\grafana\conf\custom.ini`

If **custom.ini** doesn't exist, simply duplicate **defaults.ini** and name the new copy **custom.ini**, Grafana will pick it up once the Grafana service is restarted.

By default, Grafana installs itself as a **localhost** address, to use the SSL on an internal network, it is assumed you've already adjusted your internal DNS server to respond to something like `grafana.example.com` at the IP address of the server Grafana runs on (and that you already have a wildcard SSL cert from Let's Encrypt running on PRTG on the same machine Grafana resides on).

## Under the [server] Section of custom.ini
Find:
```bash
protocol = http
```

Change to:
```bash
protocol = https
```

Find:
```bash
domain = localhost
```

Change to (adjust to suit):
```bash
domain = grafana.example.com
```

Find:
```bash
cert_file =
cert_key =
```

Change to (the path of the SSL cert that PRTG uses):
```bash
cert_file = "C:\Program Files (x86)\PRTG Network Monitor\cert\prtg.crt"
cert_key = "C:\Program Files (x86)\PRTG Network Monitor\cert\prtg.key"
```

Go into `services.msc` on the Windows host and locate the Grafana service > right-click > restart

You should now find you previous access to the http version of Grafana error out - you can now find it at: `https://grafana.example.com:3000`

### SSL Padlock Warning
If you previously uploaded images under your http connection, you'll note that Grafana still loads them as http *and* under the previous address you were accessing Grafana from (resulting in broken images).

To fix it:

Simply edit that object and change the URL prefix to `https://grafana.example.com:3000`
