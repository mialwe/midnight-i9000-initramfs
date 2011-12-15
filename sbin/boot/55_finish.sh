echo "Mounting rootfs readwrite..."
/sbin/busybox mount -t rootfs -o remount,rw rootfs
echo
echo "RAM (/proc/meminfo):"
cat /proc/meminfo|grep ^MemTotal
cat /proc/meminfo|grep ^MemFree
cat /proc/meminfo|grep ^Buffers
cat /proc/meminfo|grep ^Cached
echo
echo "Disabling /sbin/busybox, using /system/xbin/busybox now..."
/sbin/busybox_disabled rm /sbin/busybox

echo "Mounting rootfs readonly..."
/sbin/busybox_disabled mount -t rootfs -o remount,ro rootfs;


