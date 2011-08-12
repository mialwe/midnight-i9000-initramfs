#!/sbin/busybox_disabled sh
# play android bootanimation.zip if it exists, if not play samsungani

if [ -f /data/local/bootanimation.bin ]; then
  /data/local/bootanimation.bin
elif [ -f /data/local/bootanimation.zip ] || [ -f /system/media/bootanimation.zip ]; then
	exec /sbin/bootanimation &
    sleep 12
    kill $!
else
  /system/bin/samsungani
fi;
