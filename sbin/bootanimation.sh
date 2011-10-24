#!/sbin/busybox sh
# if dalvik-cache cleared play samsung animation else
# play if exist: bootanimation.zip, bootanimation.bin else
# play samsung animation...

if [ -e /data/dalvik-cache ]; then 
    if [ -f /data/local/bootanimation.bin ]; then
        /data/local/bootanimation.bin
    elif [ -f /data/local/bootanimation.zip ] || [ -f /system/media/bootanimation.zip ]; then
        exec /sbin/bootanimation &
        sleep 12
        kill $!
    else
      /system/bin/samsungani
    fi
else
    /system/bin/samsungani
fi
