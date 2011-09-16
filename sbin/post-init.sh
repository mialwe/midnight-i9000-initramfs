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
CONFFILE="midnight_gfx.conf"
if /sbin/busybox [ "`grep COLD /system/etc/$CONFFILE`" ]; then
  echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
fi

if /sbin/busybox [ "`grep WARM /system/etc/$CONFFILE`" ]; then
  echo 2 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
fi

CONFFILE="midnight_misc.conf"
# enable logger (LOGCAT) 
if /sbin/busybox [ "`grep ANDROIDLOGGER /system/etc/$CONFFILE`" ]; then
  insmod /lib/modules/logger.ko
else
  rm /lib/modules/logger.ko
fi

# enable IPv6 privacy
if /sbin/busybox [ "`grep IPV6PRIVACY /system/etc/$CONFFILE`" ]; then
  echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
fi

# enable CIFS module loading 
if /sbin/busybox [ "`grep CIFS /system/etc/$CONFFILE`" ]; then
  insmod /lib/modules/cifs.ko
else
  rm /lib/modules/cifs.ko
fi

# remount all partitions with noatime
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep relatime | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,noatime $k
  done

# remount ext4 partitions with optimizations
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep ext4 | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,commit=20 $k
  done
  
##################################
# MIDNIGHT ADDITIONS
##################################
  echo "0" > /proc/sys/vm/swappiness                   # Not really needed as no /swap used...
  echo "2000" > /proc/sys/vm/dirty_writeback_centisecs # Flush after 20sec. (o:500)
  echo "2000" > /proc/sys/vm/dirty_expire_centisecs    # Pages expire after 20sec. (o:200)
  echo "10" > /proc/sys/vm/dirty_background_ratio      # flush pages later (default 5% active mem)
  echo "25" > /proc/sys/vm/dirty_ratio                 # process writes pages later (default 20%)  

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

# internal/external sdcard readahead tweak (0:128)
CONFFILE="midnight_rh.conf"
if /sbin/busybox [ "`grep READAHEAD_4096 /system/etc/$CONFFILE`" ]; then
  echo "4096" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "4096" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
elif /sbin/busybox [ "`grep READAHEAD_3064 /system/etc/$CONFFILE`" ]; then
  echo "3064" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "3064" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
elif /sbin/busybox [ "`grep READAHEAD_2048 /system/etc/$CONFFILE`" ]; then
  echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "2048" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
elif /sbin/busybox [ "`grep READAHEAD_1024 /system/etc/$CONFFILE`" ]; then
  echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "1024" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
elif /sbin/busybox [ "`grep READAHEAD_512 /system/etc/$CONFFILE`" ]; then
  echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
else
  echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
fi

# CPU governor
CONFFILE="midnight_cpu_gov.conf"
if /sbin/busybox [ "`grep ONDEMAND /system/etc/$CONFFILE`" ]; then
  echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
elif /sbin/busybox [ "`grep CONSERVATIVE /system/etc/$CONFFILE`" ]; then
  echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
else
  echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
fi


# Max. CPU frequency
CONFFILE="midnight_cpu_max.conf"
rmmod cpufreq_stats
if /sbin/busybox [ "`grep MAX_1200 /system/etc/$CONFFILE`" ]; then
  echo 1 > /sys/devices/virtual/misc/midnight_cpufreq/oc1200
  echo "1200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
elif /sbin/busybox [ "`grep MAX_1000 /system/etc/$CONFFILE`" ]; then
  echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
elif /sbin/busybox [ "`grep MAX_800 /system/etc/$CONFFILE`" ]; then
  echo "800000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
elif /sbin/busybox [ "`grep MAX_400 /system/etc/$CONFFILE`" ]; then
  echo "400000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi
sleep 1
insmod /lib/modules/cpufreq_stats.ko

# Undervolting values
CONFFILE="midnight_cpu_uv.conf"
if /sbin/busybox [ "`grep CPU_UV_0 /system/etc/$CONFFILE`" ]; then
    echo "0 0 0 0 0" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_1 /system/etc/$CONFFILE`" ]; then
    echo "0 0 25 25 50" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_2 /system/etc/$CONFFILE`" ]; then
    echo "0 25 25 50 50" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_3 /system/etc/$CONFFILE`" ]; then
    echo "0 25 25 50 100" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_4 /system/etc/$CONFFILE`" ]; then
    echo "0 25 50 100 100" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_5 /system/etc/$CONFFILE`" ]; then
    echo "0 25 75 100 125" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_6 /system/etc/$CONFFILE`" ]; then
    echo "0 25 50 100 125" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_7 /system/etc/$CONFFILE`" ]; then
    echo "0 25 50 125 125" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_8 /system/etc/$CONFFILE`" ]; then
    echo "0 25 100 125 150" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_9 /system/etc/$CONFFILE`" ]; then
    echo "0 50 100 125 150" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_10 /system/etc/$CONFFILE`" ]; then
    echo "25 50 50 100 125" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
elif /sbin/busybox [ "`grep CPU_UV_11 /system/etc/$CONFFILE`" ]; then
    echo "25 50 75 125 150" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
else
    echo "0 0 0 0 0" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
fi

# Lowmemorykiller/ADJ settings (o:2560,4096,6144,10240,11264,12288)
# HOME slot == FOREGROUND slot = ADJ 0
CONFFILE="midnight_lmk.conf"
if /sbin/busybox [ "`grep LMK0 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=14080;ADJ14=15360;ADJ15=20480;
elif /sbin/busybox [ "`grep LMK1 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=3072;ADJ2=4096;ADJ7=6144;ADJ14=7168;ADJ15=8192;
elif /sbin/busybox [ "`grep LMK2 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=7168;ADJ14=9216;ADJ15=10752;
elif /sbin/busybox [ "`grep LMK3 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=9216;ADJ14=12288;ADJ15=14336;
elif /sbin/busybox [ "`grep LMK4 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=10752;ADJ14=14336;ADJ15=17408;
elif /sbin/busybox [ "`grep LMK5 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=14336;ADJ14=17408;ADJ15=22528;
elif /sbin/busybox [ "`grep LMK6 /system/etc/$CONFFILE`" ]; then
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=15872;ADJ14=18944;ADJ15=24576;
else
    ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=14080;ADJ14=15360;ADJ15=20480;
fi

setprop ro.FOREGROUND_APP_MEM "$ADJ0"
setprop ro.HOME_APP_MEM "$ADJ0"
setprop ro.VISIBLE_APP_MEM "$ADJ1"
setprop ro.PERCEPTIBLE_APP_MEM "$ADJ1"
setprop ro.HEAVY_WEIGHT_APP_MEM "$ADJ1"
setprop ro.SECONDARY_SERVER_MEM "$ADJ2"
setprop ro.BACKUP_APP_MEM "$ADJ2"
setprop ro.HIDDEN_APP_MEM "$ADJ7"
setprop ro.CONTENT_PROVIDER_MEM "$ADJ14"
setprop ro.EMPTY_APP_MEM "$ADJ15"

  
echo "$ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15" > /sys/module/lowmemorykiller/parameters/minfree

# Touchscreen sensitivity
CONFFILE="midnight_touch.conf"
if /sbin/busybox [ "`grep TOUCH_PLUS1 /system/etc/$CONFFILE`" ]; then
    echo "07040" > /sys/class/touch/switch/set_touchscreen # sensitivity
    echo "08001" > /sys/class/touch/switch/set_touchscreen # touch register duration
    echo "11002" > /sys/class/touch/switch/set_touchscreen # min. motion
    echo "13008" > /sys/class/touch/switch/set_touchscreen # motion filter
elif /sbin/busybox [ "`grep TOUCH_PLUS2 /system/etc/$CONFFILE`" ]; then
    echo "07030" > /sys/class/touch/switch/set_touchscreen # sensitivity
    echo "08000" > /sys/class/touch/switch/set_touchscreen # touch register duration
    echo "11001" > /sys/class/touch/switch/set_touchscreen # min. motion
    echo "13008" > /sys/class/touch/switch/set_touchscreen # motion filter
elif /sbin/busybox [ "`grep TOUCH_PLUS3 /system/etc/$CONFFILE`" ]; then
    echo "07020" > /sys/class/touch/switch/set_touchscreen # sensitivity
    echo "08000" > /sys/class/touch/switch/set_touchscreen # touch register duration
    echo "11001" > /sys/class/touch/switch/set_touchscreen # min. motion
    echo "13008" > /sys/class/touch/switch/set_touchscreen # motion filter
fi

echo "18000000" > /proc/sys/kernel/sched_latency_ns        # orig: 10000000 
echo "3000000" > /proc/sys/kernel/sched_wakeup_granularity_ns # orig: 2000000  
echo "1500000" > /proc/sys/kernel/sched_min_granularity_ns # orig: 2000000

# IO scheduler 
CONFFILE="midnight_io_sched.conf"
if /sbin/busybox [ "`grep IO_SCHED_NOOP /system/etc/$CONFFILE`" ]; then
    SCHEDULER="noop"
elif /sbin/busybox [ "`grep IO_SCHED_VR /system/etc/$CONFFILE`" ]; then
    SCHEDULER="vr"
elif /sbin/busybox [ "`grep IO_SCHED_CFQ /system/etc/$CONFFILE`" ]; then
    SCHEDULER="cfq"
elif /sbin/busybox [ "`grep IO_SCHED_DEADLINE /system/etc/$CONFFILE`" ]; then
    SCHEDULER="deadline"
fi

for i in $(ls -1 /sys/block/stl*) $(ls -1 /sys/block/mmc*) $(ls -1 /sys/block/bml*) $(ls -1 /sys/block/tfsr*); do echo $SCHEDULER > $i/queue/scheduler;done;


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
# end Midnight <n><n><filename> support
