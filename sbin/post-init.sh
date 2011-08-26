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
if /sbin/busybox [ "`grep COLD /system/etc/tweaks.conf`" ]; then
  echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
fi

if /sbin/busybox [ "`grep WARM /system/etc/tweaks.conf`" ]; then
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
  insmod /lib/modules/cifs.ko
else
  rm /lib/modules/cifs.ko
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
  echo "0" > /proc/sys/vm/swappiness

##################################
# MIDNIGHT ADDITIONS
##################################

  echo "3000" > /proc/sys/vm/dirty_writeback_centisecs # Flush after 30sec.,Speedmod: 2000
  echo "3000" > /proc/sys/vm/dirty_expire_centisecs    # Pages expire after 30sec.,Speedmod: 1000
  echo "10" > /proc/sys/vm/dirty_background_ratio      # flush pages later (default 5% active mem)
  echo "25" > /proc/sys/vm/dirty_ratio                 # process writes pages later (default 20%)  

# kill the tasks causing full memory
  sysctl -w vm.oom_kill_allocating_task=1

# prop modifications
  setprop debug.sf.hw 1
  setprop debug.sf.nobootanimation 0;
  setprop wifi.supplicant_scan_interval 180;
  setprop windowsmgr.max_events_per_sec 180;
  setprop ro.ril.disable.power.collapse 1;
  setprop ro.telephony.call_ring.delay 1000;
  setprop mot.proximity.delay 150;
  setprop ro.mot.eri.losalert.delay 1000;
  
# kernel tweak
  mount -t debugfs none /sys/kernel/debug
  echo NO_NORMALIZED_SLEEPER > /sys/kernel/debug/sched_features

# reduce IO overhead
  for k in $(/sbin/busybox_disabled ls -1 /sys/block/stl*) $(/sbin/busybox_disabled ls -1 /sys/block/mmc*);
  do
    echo "0" > $k/queue/iostats
  done

# Add patched liblights for backlight notification
  sync
  /sbin/busybox_disabled  mount -o rw,remount /dev/block/stl9 /system
  bln_file='lights.s5pc110.so'
  bln_src="/res/misc/$bln_file"
  bln_trg="/system/lib/hw/$bln_file"
  bln_bkp="/system/lib/hw/$bln_file.orig"
  if [ -d /sys/class/misc/backlightnotification ]; then
      if [ ! -f $bln_bkp ]; then
        /sbin/busybox cp $bln_trg $bln_bkp
      fi
      /sbin/busybox cp $bln_src $bln_trg
      /sbin/busybox chown 0.0 $bln_trg && /sbin/busybox chmod 644 $bln_trg
  fi
  /sbin/busybox_disabled mount -o ro,remount /dev/block/stl9 /system  

# internal/external sdcard readahead tweak
if /sbin/busybox [ "`grep READAHEAD /system/etc/tweaks.conf`" ]; then
  echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "2048" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
else
  echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
fi

# END MIDNIGHT ADDITIONS
############################

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

# Midnight: support <number><number><filename>
echo $(date) USER INIT START from /system/etc/init.d
if cd /system/etc/init.d >/dev/null 2>&1 ; then
    for file in [0-9][0-9]* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /system/etc/init.d

echo $(date) USER INIT START from /data/init.d
if cd /data/init.d >/dev/null 2>&1 ; then
    for file in [0-9][0-9]* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /data/init.d
