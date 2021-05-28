# PDF Conversion on Linux
**pdftk** (PDF Toolkit) is an awesome program to manipulate and convert PDF files easily. (In Debian sid, it looks to have transitioned to pdftk-java)

Install it
```bash
apt install pdftk
```

Convert png files to pdf first, using the **convert** package:
```bash
convert p2.png p2.pdf
```

Once the files are in PDF format, they can be merged together, to become one PDF document:
```bash
pdftk p1.pdf p2.pdf output mergedpages.pdf
```

Split a pdf:
```bash
pdftk sourcefile.pdf cat 3-7 output destinationfile.pdf
```

## Troubleshooting
When trying to convert a png to pdf:
> convert-im6.q16: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/408.

### Fix
```bash
pico /etc/ImageMagick-7/policy.xml
```

Find:
```bash
<policy domain="coder" rights="none" pattern="PDF" />
```

Change to:
```bash
<policy domain="coder" rights="read|write" pattern="PDF" />
```

### Cause
Apparently this was a [security vulnerability](https://www.kb.cert.org/vuls/id/332928/) patch for ghostscript 9.24; if running anything later:
```bash
gs --version
```
> 9.27

You could also simply remove the entire batch of `rights="none"` from `/etc/ImageMagick-7/policy.xml`
