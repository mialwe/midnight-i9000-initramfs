#!/sbin/busybox_disabled sh
rm -r /data/midnight/partitions.txt
touch /data/midnight/partitions.txt
df|grep /system|awk '{print $1 ": " $2 " -> " $3 " used / " $4 " free"}' > /data/midnight/partitions.txt
df|grep /data|awk '{print $1 ": " $2 " -> " $3 " used / " $4 " free"}' >> /data/midnight/partitions.txt
df|grep /dbdata|awk '{print $1 ": " $2 " -> " $3 " used / " $4 " free"}' >> /data/midnight/partitions.txt
df|grep /cache|awk '{print $1 ": " $2 " -> " $3 " used / " $4 " free"}' >> /data/midnight/partitions.txt
