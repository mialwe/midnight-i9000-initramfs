#!/sbin/busybox_disabled sh
# Logging
/sbin/busybox_disabled cp /data/user.log /data/user.log.bak
/sbin/busybox_disabled rm /data/user.log
exec >>/data/user.log
exec 2>&1

# Remount rootfs rw
  /sbin/busybox_disabled mount rootfs -o remount,rw

##### Early-init phase #####

# Screen color settings
if /sbin/busybox [ "`/sbin/busybox grep COLD_COLOR /system/etc/speedmodcolor.conf`" ]; then
  echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
fi

if /sbin/busybox [ "`/sbin/busybox grep WARM_COLOR /system/etc/speedmodcolor.conf`" ]; then
  echo 2 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
fi

# Android Logger enable tweak
if /sbin/busybox [ "`grep ANDROIDLOGGER /system/etc/tweaks.conf`" ]; then
  insmod /lib/modules/logger.ko
else
  rm /lib/modules/logger.ko
fi

# IPv6 privacy tweak
if /sbin/busybox [ "`grep IPV6PRIVACY /system/etc/tweaks.conf`" ]; then
  echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
fi

# Enable CIFS tweak
if /sbin/busybox [ "`grep CIFS /system/etc/tweaks.conf`" ]; then
  /sbin/busybox insmod /lib/modules/cifs.ko
else
  /sbin/busybox rm /lib/modules/cifs.ko
fi

# Remount all partitions with noatime
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep relatime | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,noatime $k
  done

# Remount ext4 partitions with optimizations
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep ext4 | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,commit=20 $k
  done
  
# Miscellaneous tweaks
  echo "3000" > /proc/sys/vm/dirty_writeback_centisecs # Speedmod: 2000
  echo "2000" > /proc/sys/vm/dirty_expire_centisecs    # Speedmod: 1000
  echo "0" > /proc/sys/vm/swappiness

################################################################################
# MIDNIGHT ADDITIONS
################################################################################

# Midnight: Diasbled as CONSERVATIVE is used. Speedmod: Ondemand CPU governor tweaks
#  echo "50" > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
#  echo "80000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate

# /proc/sys/vm
# nice, short documentation: http://www.linuxinsight.com/proc_sys_vm_hierarchy.html
# echo "25" > /proc/sys/vm/dirty_ratio
# echo "15" > /proc/sys/vm/dirty_background_ratio
#  echo "5"  > /proc/sys/vm/laptop_mode

# kill the tasks causing full memory
#  sysctl -w vm.oom_kill_allocating_task=1

# more mem to cache fs dentry and inode to save cpu
#  sysctl -w vm.vfs_cache_pressure=10

# prop modifications
  setprop debug.sf.hw 1
  setprop debug.sf.nobootanimation 0
  setprop wifi.supplicant_scan_interval 180
  setprop windowsmgr.max_events_per_sec 180

# kernel tweaks
#  echo "8" > /proc/sys/vm/page-cluster;
#  echo "10" > /proc/sys/fs/lease-break-time;
#  echo "2048" > /proc/sys/kernel/msgmni
#  echo "64000" > /proc/sys/kernel/msgmax
#  echo "268435456" > /proc/sys/kernel/shmmax
#  echo "500 512000 64 2048" > /proc/sys/kernel/sem
  sysctl -w kernel.sched_latency_ns=600000
  sysctl -w kernel.sched_min_granularity_ns=400000
  sysctl -w kernel.sched_wakeup_granularity_ns=400000
  mount -t debugfs none /sys/kernel/debug
  echo NO_NORMALIZED_SLEEPER > /sys/kernel/debug/sched_features

# noop scheduler tweak
#  for i in $(/sbin/busybox_disabled ls -1 /sys/block/stl*) $(/sbin/busybox_disabled ls -1 /sys/block/mmc*)
#  do 
#    echo "248" > $i/queue/nr_requests
#  done

# END MIDNIGHT ADDITIONS
################################################################################

# SD cards (mmcblk) read ahead tweaks
  echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb

# Onenand (stl) read ahead tweaks
  echo "64" > /sys/devices/virtual/bdi/138:9/read_ahead_kb
  echo "64" > /sys/devices/virtual/bdi/138:10/read_ahead_kb
  echo "64" > /sys/devices/virtual/bdi/138:11/read_ahead_kb

##### Post-init phase #####
sleep 12

# Cleanup busybox
  /sbin/busybox_disabled rm /sbin/busybox
  /sbin/busybox_disabled mount rootfs -o remount,ro

# init.d support
echo $(date) USER EARLY INIT START from /system/etc/init.d
if cd /system/etc/init.d >/dev/null 2>&1 ; then
    for file in E* ; do
        if ! cat "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER EARLY INIT DONE from /system/etc/init.d

echo $(date) USER EARLY INIT START from /data/init.d
if cd /data/init.d >/dev/null 2>&1 ; then
    for file in E* ; do
        if ! cat "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER EARLY INIT DONE from /data/init.d

echo $(date) USER INIT START from /system/etc/init.d
if cd /system/etc/init.d >/dev/null 2>&1 ; then
    for file in S* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /system/etc/init.d

echo $(date) USER INIT START from /data/init.d
if cd /data/init.d >/dev/null 2>&1 ; then
    for file in S* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /data/init.d
