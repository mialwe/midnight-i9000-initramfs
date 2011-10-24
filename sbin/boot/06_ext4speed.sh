echo "Remounting partitions with speed tweaks..."
for k in $(busybox mount | busybox grep relatime | busybox cut -d " " -f3)
do
    echo "MOUNT: remounting $k noatime..."
    sync
    busybox mount -o remount,noatime,nodiratime $k
done

echo "Trying to remount EXT4 partitions with speed tweaks if any..."
for k in $(busybox mount | grep ext4 | cut -d " " -f3)
do
  sync;
  if [ "$k" = "/system" ]; then
    busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
  elif [ "$k" = "/dbdata" ]; then
    busybox mount -o remount,noauto_da_alloc,barrier=1,nodelalloc,commit=40 $k;
  elif [ "$k" = "/data" ]; then
    busybox mount -o remount,noauto_da_alloc,barrier=1,commit=40 $k;
  elif [ "$k" = "/cache" ]; then
    busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
  fi;
done

echo "MOUNT: Check mounted partitions: "
mount|grep /system
mount|grep /data
mount|grep /dbdata
mount|grep /cache
