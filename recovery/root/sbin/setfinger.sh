#!/sbin/sh
busybox mount -t ext4 -o ro /dev/block/bootdevice/by-name/system /system
setprop ro.build.fingerprint $(busybox grep '^ro.build.fingerprint' /system/build.prop|busybox cut -b 22-)
busybox umount /system
