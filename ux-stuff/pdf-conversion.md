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
