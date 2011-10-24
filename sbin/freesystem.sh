#!/sbin/sh
rm -f /data/midnight/dir.txt
touch /data/midnight/dir.txt
df 2>/dev/null | grep "/system" | grep -o -E " [0-9](.*)" | sed 's/ */ /g' | cut -d " " -f 4 > /data/midnight/dir.txt
if [ -s /data/midnight/dir.txt ];then return 0;fi;
return 1
