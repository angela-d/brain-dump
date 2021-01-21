# Verify a SHA256 or MD5 Hash on a Downloaded File
When you download applications off the internet, the downloaded files can be tampered with by MITM during dispatch, or at rest if the vendor's network may be intruded.

Download vendors typically offer a string of either a SHA256 or MD5 sum of their package.  If you check your downloaded file against their offered hash, you can be certain the download you received hasn't been tampered with and is in the same state as when the vendor signed off on the release.

## Verifying a Sum
Wait until the package is fully downloaded.  If you attempt to run a sum check on a partial file, you'll have a wildly different sum.

**GNU/Linux Systems**
- SHA256SUM
  - ```bash
  sha256sum FILENAME_OF_DOWNLOADED_FILE
  ```
  - The returned value is the sha256sum to compare.

- MD5
  - ```bash
  md5sum FILENAME_OF_DOWNLOADED_FILE
  ```
  - The returned value is the md5sum to compare.


**Windows**

Certutil is built-in Windows functionality.

1. Open Powershell ISE
2. cd `.\Downloads` to change the terminal to your downloads folder.
3. Run:
```powershell
certutil -hashfile .\FILENAME_OF_DOWNLOADED_FILE SHA256
```
- The returned value is the sha256sum to compare.
