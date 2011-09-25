#!/sbin/busybox_disabled sh
rm -r /data/midnight/dir.txt
touch /data/midnight/dir.txt
ls -l "$1"|awk '{print $7"  \t"$4" Byte"}' > /data/midnight/dir.txt
