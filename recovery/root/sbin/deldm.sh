#!/sbin/sh
# LazyFlasher installer backend

tmp=/tmp/no-verity-opt-encrypt
zip=/sbin/no-verity-opt-encrypt.zip
console=/proc/$$/fd/$2
# write the location of the console buffer to /tmp/console for other scripts to use
echo "$console" > /tmp/console

ifmiui() {
	mount -t ext4 -o ro /dev/block/bootdevice/by-name/system /system
	if [ -z $(grep '^ro.miui.ui.version.code' /system/build.prop) ];then
		exit
	fi
}

print() {
	echo "ui_print $1" > $console
	echo
}

abort() {
	[ "$1" ] && {
		print "Error: $1"
		print "Aborting..."
	}
	cleanup
	print "Failed to patch boot image!"
	exit 1
}

cleanup() {
	[ "$zip" ] && rm /tmp/console
}

extract() {
	rm -rf "$2"
	mkdir -p "$2"
	unzip -o "$1" -d "$2"
}

setperm() {
	find "$3" -type d -exec chmod "$1" {} \;
	find "$3" -type f -exec chmod "$2" {} \;
}

# Unpack the installer
extract "$zip" "$tmp"

ifmiui

cd "$tmp"

. config.sh

setperm 0755 0755 "$bin"

sh boot-patcher.sh || abort

cleanup

