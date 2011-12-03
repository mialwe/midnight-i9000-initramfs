echo "Mounting rootfs readwrite..."
/sbin/busybox mount -t rootfs -o remount,rw rootfs

echo "RAM:"
cat /proc/meminfo

echo "Disabling /sbin/busybox, using /system/xbin/busybox now..."
/sbin/busybox_disabled rm /sbin/busybox

echo "Mounting rootfs readonly..."
/sbin/busybox_disabled mount -t rootfs -o remount,ro rootfs;


