CONFFILE="midnight_misc.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep NOTWEAKS /system/etc/$CONFFILE`" ]; then
        echo "Midnight tweaks disabled, nothing to do."
        exit
    else
        echo "Remounting partitions with speed tweaks..."
        for k in $(/sbin/busybox mount | busybox grep relatime | busybox cut -d " " -f3)
        do
            sync
            /sbin/busybox mount -o remount,noatime,nodiratime $k
        done

        echo "Trying to remount EXT4 partitions with speed tweaks if any..."
        for k in $(/sbin/busybox mount | grep ext4 | cut -d " " -f3)
        do
          sync;
          if /sbin/busybox [ "$k" = "/system" ]; then
            /sbin/busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
          elif /sbin/busybox [ "$k" = "/dbdata" ]; then
            /sbin/busybox mount -o remount,noauto_da_alloc,barrier=1,nodelalloc,commit=40 $k;
          elif /sbin/busybox [ "$k" = "/data" ]; then
            /sbin/busybox mount -o remount,noauto_da_alloc,barrier=1,commit=40 $k;
          elif /sbin/busybox [ "$k" = "/cache" ]; then
            /sbin/busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
          fi;
        done
    fi
fi
echo "MOUNT: Check mounted partitions: "
/sbin/busybox mount|grep /system
/sbin/busybox mount|grep /data
/sbin/busybox mount|grep /dbdata
/sbin/busybox mount|grep /cache
