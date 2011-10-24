#!/sbin/ext/busybox sh

/sbin/ext/busybox cp /data/user.log /data/user.log.bak
/sbin/ext/busybox rm /data/user.log
exec >>/data/user.log
exec 2>&1

echo $(date) USER INIT START from /sbin/boot
if cd /sbin/boot >/dev/null 2>&1 ; then
    for file in * ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
        echo ""
    done
fi
echo $(date) USER INIT DONE from /sbin/boot
        
read sync < /data/sync_fifo
rm /data/sync_fifo
