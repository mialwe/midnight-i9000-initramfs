echo "Mounting rootfs readwrite..."
/sbin/busybox mount -t rootfs -o remount,rw rootfs
 
# Screen color settings
echo "Setting video driver options..."
CONFFILE="midnight_gfx.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep COLD /system/etc/$CONFFILE`" ]; then
      echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi

    if /sbin/busybox [ "`grep WARM /system/etc/$CONFFILE`" ]; then
      echo 2 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi
fi

CONFFILE="midnight_misc.conf"
echo "Setting misc. options..."
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then

    # enable IPv6 privacy
    if /sbin/busybox [ "`grep IPV6PRIVACY /system/etc/$CONFFILE`" ]; then
      echo "Setting various IPv4/IPv6 security enhancements..."
      echo 0 > /proc/sys/net/ipv4/ip_forward
      echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
      echo 2 > /proc/sys/net/ipv6/conf/all/use_tempaddr
      echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
      echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
      echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
      #echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all      

      echo -n "    ip_forward :";cat /proc/sys/net/ipv4/ip_forward
      echo -n "    rp_filter :";cat /proc/sys/net/ipv4/conf/all/rp_filter
      echo -n "    use_tempaddr :";cat /proc/sys/net/ipv6/conf/all/use_tempaddr
      echo -n "    accept_source_route :";cat /proc/sys/net/ipv4/conf/all/accept_source_route
      echo -n "    send_redirects :";cat /proc/sys/net/ipv4/conf/all/send_redirects
      echo -n "    icmp_echo_ignore_broadcasts :";cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
      #echo -n "    icmp_echo_ignore_all :";cat /proc/sys/net/ipv4/icmp_echo_ignore_all      
    fi

    # enable logger (LOGCAT) 
    if /sbin/busybox [ "`grep ANDROIDLOGGER /system/etc/$CONFFILE`" ]; then
      echo "MODULE: logger.ko loaded by init.rc, doing nothing..."
      #insmod /lib/modules/logger.ko
    else
      echo "MODULE: logger.ko disabled, unloading..."
      rmmod logger.ko
      rm /lib/modules/logger.ko
    fi

    # enable CIFS module loading 
    if /sbin/busybox [ "`grep CIFS /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading cifs.ko..."
      insmod /lib/modules/cifs.ko
    else
      rm /lib/modules/cifs.ko
    fi
    
    # enable TUN module loading 
    if /sbin/busybox [ "`grep TUN /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading tun.ko..."
      insmod /lib/modules/tun.ko
      echo "Disabling IPv4 rp_filter for VPN..."
      echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
      echo -n "    rp_filter :";cat /proc/sys/net/ipv4/conf/all/rp_filter
    else
      rm /lib/modules/tun.ko
    fi
    
#    if /sbin/busybox [ "`grep TOUCH /system/etc/$CONFFILE`" ]; then
#        echo "Setting touchscreen enhancements..."
#        echo 7035 > /sys/class/touch/switch/set_touchscreen     # sensitivity orig:tchthr 40
#        echo 8002 > /sys/class/touch/switch/set_touchscreen     # touch register duration orig:tchdi 2
#        echo 11002 > /sys/class/touch/switch/set_touchscreen    # min. motion orig: movhysti 3
#        echo 13040 > /sys/class/touch/switch/set_touchscreen    # motion filter orig: movfilter 46
#        echo 14005 > /sys/class/touch/switch/set_touchscreen      
#    fi

fi
echo "Checking loaded modules:"
lsmod

# Touchscreen sensitivity
echo
echo "Setting touchscreen tweaks..."
CONFFILE="midnight_touch.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep TOUCH_PLUS1 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS1..."
        echo 7035 > /sys/class/touch/switch/set_touchscreen     # sensitivity orig:tchthr 40
        echo 8002 > /sys/class/touch/switch/set_touchscreen     # touch register duration orig:tchdi 2
        echo 11002 > /sys/class/touch/switch/set_touchscreen    # min. motion orig: movhysti 3
        echo 13040 > /sys/class/touch/switch/set_touchscreen    # motion filter orig: movfilter 46
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    elif /sbin/busybox [ "`grep TOUCH_PLUS2 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS2..."
        echo 7027 > /sys/class/touch/switch/set_touchscreen
        echo 8001 > /sys/class/touch/switch/set_touchscreen
        echo 11001 > /sys/class/touch/switch/set_touchscreen
        echo 13030 > /sys/class/touch/switch/set_touchscreen
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    elif /sbin/busybox [ "`grep TOUCH_PLUS3 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS3..."
        echo 7020 > /sys/class/touch/switch/set_touchscreen
        echo 8001 > /sys/class/touch/switch/set_touchscreen
        echo 11001 > /sys/class/touch/switch/set_touchscreen
        echo 13020 > /sys/class/touch/switch/set_touchscreen
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    fi
else 
    echo "Touchcreen config file not set, nothing to do..."
fi

echo "Mounting rootfs readonly..."
/sbin/busybox mount -t rootfs -o remount,ro rootfs 
