# Locating the USB Mount Point in Linux

In a CLI terminal:
```bash
mount -v | grep "^/" | awk '{print "\nPartition identifier: " $1  "\n Mountpoint: "  $3}'
```

Returns the following:
```text
Partition identifier: /dev/sda4
 Mountpoint: /

Partition identifier: /dev/sda5
 Mountpoint: /var

Partition identifier: /dev/sda7
 Mountpoint: /home

Partition identifier: /dev/sda1
 Mountpoint: /boot/efi

Partition identifier: /dev/sdb2
 Mountpoint: /storage

Partition identifier: /dev/sdc1
 Mountpoint: /media/angela/usbdrive
```
