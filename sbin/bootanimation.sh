#!/sbin/busybox_disabled sh
# play android bootanimation.zip if it exists, if not play samsungani
if [ -f /system/bin/bootanimation ];
then
	if [ -f /data/local/bootanimation.zip ] || [ -f /system/media/bootanimation.zip ];
	then
		exec /system/bin/bootanimation
	else
		exec /system/bin/samsungani
	fi
else
	exec /system/bin/samsungani
fi

