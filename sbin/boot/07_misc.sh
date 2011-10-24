/sbin/ext/busybox mount -t rootfs -o remount,rw rootfs;
# Screen color settings
echo "Setting video driver options..."
CONFFILE="midnight_gfx.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep COLD /system/etc/$CONFFILE`" ]; then
      echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi

    if /sbin/ext/busybox [ "`grep WARM /system/etc/$CONFFILE`" ]; then
      echo 2 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi
fi

CONFFILE="midnight_misc.conf"
echo "Setting misc. options..."
if [ -f /system/etc/$CONFFILE ];then
    # enable logger (LOGCAT) 
    if /sbin/ext/busybox [ "`grep ANDROIDLOGGER /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading logger.ko..."
      insmod /lib/modules/logger.ko
    else
      rm /lib/modules/logger.ko
    fi

    # enable CIFS module loading 
    if /sbin/ext/busybox [ "`grep CIFS /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading cifs.ko..."
      insmod /lib/modules/cifs.ko
    else
      rm /lib/modules/cifs.ko
    fi
    
    # enable TUN module loading 
    if /sbin/ext/busybox [ "`grep TUN /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading tun.ko..."
      insmod /lib/modules/tun.ko
    else
      rm /lib/modules/tun.ko
    fi

    # enable IPv6 privacy
    if /sbin/ext/busybox [ "`grep IPV6PRIVACY /system/etc/$CONFFILE`" ]; then
      echo "IPv6: setting use_tempaddr = 2 ..."
      echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
    fi
fi
/sbin/ext/busybox mount -t rootfs -o remount,ro rootfs;
echo "Checking loaded modules:"
lsmod
