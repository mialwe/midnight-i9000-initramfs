#!/sbin/sh
cd $1
/sbin/busybox md5sum *img > nandroid.md5
return $?
