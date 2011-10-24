# mount system and rootfs r/w
/sbin/ext/busybox mount -o remount,rw /system;
/sbin/ext/busybox mount -t rootfs -o remount,rw rootfs;

# make sure we have /system/xbin
/sbin/ext/busybox mkdir -p /system/xbin

# if symlinked busybox in /system/bin or /system/xbin, remove them
echo "Checking for busybox symlinks..."
if /sbin/ext/busybox [ -h /system/bin/busybox ]; then
    /sbin/ext/busybox rm -rf /system/bin/busybox;
fi
if /sbin/ext/busybox [ -h /system/xbin/busybox ]; then
    /sbin/ext/busybox rm -rf /system/xbin/busybox;
fi


echo "Checking for real busybox..."
# if real busybox in /system/bin, move to /system/xbin
if /sbin/ext/busybox [ -f /system/bin/busybox ]; then
    echo "Real busybox binary found, moving to /system/xbin..."
    /sbin/ext/busybox rm -rf /system/xbin/busybox
    /sbin/ext/busybox mv /system/bin/busybox /system/xbin/busybox
else
    echo "No real busybox binary found, nothing to do..."
fi;

echo "Checking /system/xbin for busybox..."
if [ -f /system/xbin/busybox ];then
    echo "/system/xbin/busybox found, nothing to do..."
else
    echo "/system/xbin/busybox not found, installing recovery busybox to /system/xbin/busybox..."
    /sbin/ext/busybox cp /sbin/recovery /system/xbin/busybox
    /sbin/ext/busybox chown 0.0 /system/xbin/busybox
    /sbin/ext/busybox chmod 4755 /system/xbin/busybox
fi    

# place wrapper script
echo "Copying busybox-wrapper script to /sbin/busybox..."
/sbin/ext/busybox cp /sbin/ext/busybox-wrapper /sbin/busybox;

# mount system and rootfs r/o
/sbin/ext/busybox mount -t rootfs -o remount,ro rootfs;
/sbin/ext/busybox mount -o remount,ro /system;
