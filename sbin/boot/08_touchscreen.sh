echo "Setting touchscreen tweaks values..."
CONFFILE="midnight_touch.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep TOUCH_PLUS1 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS1..."
        echo 7035 > /sys/class/touch/switch/set_touchscreen     # sensitivity orig:tchthr 40
        echo 8002 > /sys/class/touch/switch/set_touchscreen     # touch register duration orig:tchdi 2
        echo 11002 > /sys/class/touch/switch/set_touchscreen    # min. motion orig: movhysti 3
        echo 13040 > /sys/class/touch/switch/set_touchscreen    # motion filter orig: movfilter 46
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    elif /sbin/ext/busybox [ "`grep TOUCH_PLUS2 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS2..."
        echo 7025 > /sys/class/touch/switch/set_touchscreen
        echo 8002 > /sys/class/touch/switch/set_touchscreen
        echo 11001 > /sys/class/touch/switch/set_touchscreen
        echo 13030 > /sys/class/touch/switch/set_touchscreen
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    elif /sbin/ext/busybox [ "`grep TOUCH_PLUS3 /system/etc/$CONFFILE`" ]; then
        echo "Setting preset PLUS3..."
        echo 7015 > /sys/class/touch/switch/set_touchscreen
        echo 8002 > /sys/class/touch/switch/set_touchscreen
        echo 11000 > /sys/class/touch/switch/set_touchscreen
        echo 13020 > /sys/class/touch/switch/set_touchscreen
        echo 14005 > /sys/class/touch/switch/set_touchscreen       
    fi
else 
    echo "Touchcreen config file not set, nothing to do..."
fi
