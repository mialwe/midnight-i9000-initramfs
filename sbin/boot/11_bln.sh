echo "Installing backlightnotification lin..."
echo "BLN: Remounting /system rw..." 
/sbin/ext/busybox  mount -o rw,remount /dev/block/stl9 /system
bln_file='lights.s5pc110.so'
bln_src="/res/misc/$bln_file"
bln_trg="/system/lib/hw/$bln_file"
bln_bkp="/system/lib/hw/$bln_file.orig"
if [ -d /sys/class/misc/backlightnotification ]; then
    echo "BLN: Kernel supports backlightnotification"
    if [ -f $bln_bkp ]; then
        echo "BLN: liblights backup found (/system/lib/hw/liblights.s5pc110.so.orig), skipping..."     
    else    
        echo "BLN: liblights backup not found, copying to /system/lib/hw/liblights.s5pc110.so.orig..." 
        /sbin/ext/busybox cp $bln_trg $bln_bkp
    fi
    echo "BLN: Copying bln patched liblights from neldar..."
    /sbin/ext/busybox cp $bln_src $bln_trg
    /sbin/ext/busybox chown 0.0 $bln_trg && /sbin/ext/busybox chmod 644 $bln_trg
fi
echo "BLN: check /system/lib/hw/lights*: ";ls -l /system/lib/hw/lights*
echo "BLN: Remount /system ro..."
/sbin/ext/busybox mount -o ro,remount /dev/block/stl9 /system  
