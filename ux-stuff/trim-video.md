# Trim a Video on Linux
Using FFMPEG

- For recording screencaps, I use [Kazam](https://directory.fsf.org/wiki/Kazam) (accessible in Gnome Software)
- For editing out the last few seconds where Kazam records you finishing the screencap, I use [FFMPEG](https://wiki.debian.org/ffmpeg) over command-line


The video below was originally 21 seconds, but I trimmed it down to 14:
```bash
ffmpeg -ss 00:00:00 -t 00:00:14 -i ~/Pictures/Kazam_screencast_00000.mp4 -async 1 -vcodec copy -acodec copy ~/Pictures/trimmedscreencap.mp4
```

trimmedscreencap.mp4 will appear in the `~/Pictures` directory.
