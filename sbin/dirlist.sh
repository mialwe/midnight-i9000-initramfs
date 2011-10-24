#!/sbin/sh
rm -r /data/midnight/dir.txt
touch /data/midnight/dir.txt
ls -l $1|awk '{print $7" "$4" Byte"}' > /data/midnight/dir.txt
if [ -s /data/midnight/dir.txt ];then return 0;fi;
return 1
