#!/sbin/busybox_disabled sh
# Logging
/sbin/busybox_disabled cp /data/user.log /data/user.log.bak
/sbin/busybox_disabled rm /data/user.log
exec >>/data/user.log
exec 2>&1

echo
echo "*****************************************************************"
echo "Entering initramfs post-init.sh..."
echo "Welcome to Midnight initramfs post-init.sh, "
echo "nice to see you here :) Let's see if everything worked..."
echo "******************************************************************"
echo

# Remount rootfs rw
  /sbin/busybox_disabled mount rootfs -o remount,rw

##### Early-init phase #####

# Screen color settings
echo "Setting video driver options..."
CONFFILE="midnight_gfx.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep COLD /system/etc/$CONFFILE`" ]; then
      echo 1 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi

    if /sbin/busybox [ "`grep WARM /system/etc/$CONFFILE`" ]; then
      echo 2 > /sys/devices/virtual/misc/speedmodk_mdnie/color_temp
    fi
fi

CONFFILE="midnight_misc.conf"
echo "Setting misc. options..."
if [ -f /system/etc/$CONFFILE ];then
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
fi

echo "Remounting partitions with speed tweaks..."
# remount all partitions with noatime
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep relatime | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,noatime $k
  done

echo "Trying to remount EXT4 partitions with speed tweaks if any..."
# remount ext4 partitions with optimizations
  for k in $(/sbin/busybox_disabled mount | /sbin/busybox_disabled grep ext4 | /sbin/busybox_disabled cut -d " " -f3)
  do
        sync
        /sbin/busybox_disabled mount -o remount,commit=20 $k
  done
  
##################################
# MIDNIGHT ADDITIONS
##################################
  echo "Setting VM tweaks..."
  echo "0" > /proc/sys/vm/swappiness                   # Not really needed as no /swap used...
  echo "2000" > /proc/sys/vm/dirty_writeback_centisecs # Flush after 20sec. (o:500)
  echo "2000" > /proc/sys/vm/dirty_expire_centisecs    # Pages expire after 20sec. (o:200)
  echo "10" > /proc/sys/vm/dirty_background_ratio      # flush pages later (default 5% active mem)
  echo "25" > /proc/sys/vm/dirty_ratio                 # process writes pages later (default 20%)  

# prop modifications
  echo "Setting prop tweaks..."
  setprop debug.sf.hw 1
  setprop debug.sf.nobootanimation 0;
  setprop wifi.supplicant_scan_interval 180;
  setprop windowsmgr.max_events_per_sec 180;
  setprop ro.ril.disable.power.collapse 1;
  setprop ro.telephony.call_ring.delay 1000;
  setprop mot.proximity.delay 150;
  setprop ro.mot.eri.losalert.delay 1000;
  
# kernel tweak
echo "Setting kernel tweak #1 (SLEEPERS)..."
  #mount -t debugfs none /sys/kernel/debug
  echo "NO_NORMALIZED_SLEEPER" > /sys/kernel/debug/sched_features
  echo "NO_NEW_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
  echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
  echo 500 512000 64 2048 > /proc/sys/kernel/sem; 

# reduce IO overhead
echo "Reducing IO overhead..."
  for k in $(/sbin/busybox_disabled ls -1 /sys/block/stl*) $(/sbin/busybox_disabled ls -1 /sys/block/mmc*);
  do
    echo "0" > $k/queue/iostats
  done

# Add patched liblights for backlight notification
  echo "BLN..."
  sync
  echo "BLN: Remounting /system rw..." 
  /sbin/busybox_disabled  mount -o rw,remount /dev/block/stl9 /system
  bln_file='lights.s5pc110.so'
  bln_src="/res/misc/$bln_file"
  bln_trg="/system/lib/hw/$bln_file"
  bln_bkp="/system/lib/hw/$bln_file.orig"
  if [ -d /sys/class/misc/backlightnotification ]; then
      echo "BLN: Kernel supports backlightnotification"
      if [ ! -f $bln_bkp ]; then
        echo "BLN: liblights backup not found, copying to /system/lib/hw/liblights.s5pc110.so.orig..." 
        /sbin/busybox cp $bln_trg $bln_bkp
      fi
      echo "BLN: Copying bln patched liblights from neldar..."
      /sbin/busybox cp $bln_src $bln_trg
      /sbin/busybox chown 0.0 $bln_trg && /sbin/busybox chmod 644 $bln_trg
  fi
  echo "BLN: Remount /system ro..."
  /sbin/busybox_disabled mount -o ro,remount /dev/block/stl9 /system  

# internal/external sdcard readahead tweak (0:128)
echo "Setting READ_AHEAD..."
CONFFILE="midnight_rh.conf"
if [ -f /system/etc/$CONFFILE ];then
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
fi

# CPU governor
echo "Setting CPU governor..."
CONFFILE="midnight_cpu_gov.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep ONDEMAND /system/etc/$CONFFILE`" ]; then
      echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    elif /sbin/busybox [ "`grep CONSERVATIVE /system/etc/$CONFFILE`" ]; then
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    else
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    fi
fi

# Max. CPU frequency
echo "Setting CPU max freq..."
CONFFILE="midnight_cpu_max.conf"
rmmod cpufreq_stats
echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
if [ -f /system/etc/$CONFFILE ];then
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
fi
sleep 1
insmod /lib/modules/cpufreq_stats.ko

uv100=0; uv200=0; uv400=0; uv800=0; uvmaxmhz=0;
# Undervolting presets
echo "UV: Setting undervolting presets..."
CONFFILE="midnight_cpu_uv.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep CPU_UV_0$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=0; uv400=0; uv200=0; uv100=0;
    elif /sbin/busybox [ "`grep CPU_UV_1$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=0; uv400=25; uv200=25; uv100=50;
    elif /sbin/busybox [ "`grep CPU_UV_2$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=25; uv200=50; uv100=50;
    elif /sbin/busybox [ "`grep CPU_UV_3$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=25; uv200=50; uv100=100;
    elif /sbin/busybox [ "`grep CPU_UV_4$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=50; uv200=100; uv100=100;
    elif /sbin/busybox [ "`grep CPU_UV_5$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=75; uv200=100; uv100=125;
    elif /sbin/busybox [ "`grep CPU_UV_6$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=50; uv200=100; uv100=125;
    elif /sbin/busybox [ "`grep CPU_UV_7$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=50; uv200=125; uv100=125;
    elif /sbin/busybox [ "`grep CPU_UV_8$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=25; uv400=100; uv200=125; uv100=150;
    elif /sbin/busybox [ "`grep CPU_UV_9$ /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=0; uv800=50; uv400=100; uv200=125; uv100=150;
    elif /sbin/busybox [ "`grep CPU_UV_10 /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=25; uv800=50; uv400=50; uv200=100; uv100=125;
    elif /sbin/busybox [ "`grep CPU_UV_11 /system/etc/$CONFFILE`" ]; then
         uvmaxmhz=25; uv800=50; uv400=75; uv200=125; uv100=150;
    else
         uvmaxmhz=0; uv800=0; uv400=0; uv200=0; uv100=0;
    fi
fi
echo "UV: Values after preset parsing: $uvmaxmhz $uv800 $uv400  $uv200 $uv100"

# Manual undervolting values
CONFFILE="midnight_cpu_uv_100.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let uv=uv+5;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let uv=uv+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let uv=uv+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let uv=uv+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let uv=uv+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let uv=uv+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let uv=uv+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let uv=uv+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let uv=uv+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let uv=uv+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let uv=uv+100;fi
    echo "UV: Calculated manual UV mv: $uv"
    echo "UV: Original UV 100Mhz mv: $uv100"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";let uv100=uv100;else let uv100=uv;fi
fi

CONFFILE="midnight_cpu_uv_200.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let uv=uv+5;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let uv=uv+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let uv=uv+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let uv=uv+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let uv=uv+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let uv=uv+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let uv=uv+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let uv=uv+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let uv=uv+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let uv=uv+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let uv=uv+100;fi
    echo "UV: Calculated manual UV 200Mhz mv: $uv"
    echo "UV: Original UV 200Mhz mv: $uv200"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";let uv200=uv200;else let uv200=uv;fi
fi

CONFFILE="midnight_cpu_uv_400.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let uv=uv+5;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let uv=uv+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let uv=uv+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let uv=uv+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let uv=uv+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let uv=uv+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let uv=uv+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let uv=uv+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let uv=uv+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let uv=uv+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let uv=uv+100;fi
    echo "UV: Calculated manual UV 400Mhz mv: $uv"
    echo "UV: Original UV 400Mhz mv: $uv400"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";let uv400=uv400;else let uv400=uv;fi
fi

CONFFILE="midnight_cpu_uv_800.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let uv=uv+5;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let uv=uv+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let uv=uv+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let uv=uv+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let uv=uv+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let uv=uv+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let uv=uv+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let uv=uv+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let uv=uv+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let uv=uv+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let uv=uv+100;fi
    echo "UV: Calculated manual UV 800Mhz mv: $uv"
    echo "UV: Original UV 800Mhz mv: $uv800"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";let uv800=uv800;else let uv800=uv;fi
fi

CONFFILE="midnight_cpu_uv_maxmhz.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let uv=uv+5;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let uv=uv+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let uv=uv+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let uv=uv+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let uv=uv+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let uv=uv+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let uv=uv+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let uv=uv+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let uv=uv+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let uv=uv+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let uv=uv+100;fi
    echo "UV: Calculated manual UV maxMhz mv: $uv"
    echo "UV: Original UV maxMhz mv: $uvmaxmhz"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";let uvmaxmhz=uvmaxmhz;else let uvmaxmhz=uv;fi
    echo "UV: Setting undervolting values: $uvmaxmhz $uv800 $uv400 $uv200 $uv100 mV..."
fi    
echo "$uvmaxmhz $uv800 $uv400 $uv200 $uv100" > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table


# Lowmemorykiller/ADJ settings (o:2560,4096,6144,10240,11264,12288)
echo "LMK tweaks"
CONFFILE="midnight_lmk.conf"
ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=14080;ADJ14=15360;ADJ15=20480;
if [ -f /system/etc/$CONFFILE ];then
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
fi

# Manual lowmemorykiller values
CONFFILE="midnight_lmk_slot1.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot1 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot1: $lmkval"
    echo "LMK: Original lmk slot1: $ADJ0"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ0=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot2.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot2 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot2: $lmkval"
    echo "LMK: Original lmk slot2: $ADJ1"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ1=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot3.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot3 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot3: $lmkval"
    echo "LMK: Original lmk slot3: $ADJ2"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ2=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot4.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot4 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot4: $lmkval"
    echo "LMK: Original lmk slot4: $ADJ7"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ7=$lmkval;
    fi
fi
    
CONFFILE="midnight_lmk_slot5.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot5 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot5: $lmkval"
    echo "LMK: Original lmk slot5: $ADJ14"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ14=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot6.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+1;fi
    if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+2;fi
    if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+3;fi
    if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+4;fi
    if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+5;fi
    if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+6;fi
    if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+7;fi
    if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+8;fi
    if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+9;fi
    if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+10;fi
    if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+20;fi
    if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+30;fi
    if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+40;fi
    if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+50;fi
    if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+60;fi
    if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+70;fi
    if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+80;fi
    if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+90;fi
    if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then let lmkval=lmkval+100;fi
    echo "LMK: Manual lmk slot6 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot6: $lmkval"
    echo "LMK: Original lmk slot6: $ADJ15"
    if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        let ADJ15=$lmkval;
    fi
fi

echo "LMK: Setting APP ADJs..."
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

echo "LMK: Setting minfree values..."  
echo "$ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15" > /sys/module/lowmemorykiller/parameters/minfree

# Touchscreen sensitivity
echo "Setting touchscreen tweaks..."
CONFFILE="midnight_touch.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep TOUCH_PLUS1 /system/etc/$CONFFILE`" ]; then
        echo "07035" > /sys/class/touch/switch/set_touchscreen # sensitivity orig:tchthr 40
        echo "08001" > /sys/class/touch/switch/set_touchscreen # touch register duration orig:tchdi 2
        echo "11003" > /sys/class/touch/switch/set_touchscreen # min. motion orig: movhysti 3
        echo "13030" > /sys/class/touch/switch/set_touchscreen # motion filter orig: movfilter 46
    elif /sbin/busybox [ "`grep TOUCH_PLUS2 /system/etc/$CONFFILE`" ]; then
        echo "07030" > /sys/class/touch/switch/set_touchscreen # sensitivity
        echo "08001" > /sys/class/touch/switch/set_touchscreen # touch register duration
        echo "11003" > /sys/class/touch/switch/set_touchscreen # min. motion
        echo "13020" > /sys/class/touch/switch/set_touchscreen # motion filter
    elif /sbin/busybox [ "`grep TOUCH_PLUS3 /system/etc/$CONFFILE`" ]; then
        echo "07025" > /sys/class/touch/switch/set_touchscreen # sensitivity
        echo "08000" > /sys/class/touch/switch/set_touchscreen # touch register duration
        echo "11003" > /sys/class/touch/switch/set_touchscreen # min. motion
        echo "13010" > /sys/class/touch/switch/set_touchscreen # motion filter
    fi
fi

echo "Setting kernel tweaks #2"
# Thanks pikachu01 and zach for better values: http://forum.xda-developers.com/showthread.php?t=1266715
echo 100000 > /proc/sys/kernel/sched_latency_ns
echo 500000 > /proc/sys/kernel/sched_wakeup_granularity_ns
echo 750000 > /proc/sys/kernel/sched_min_granularity_ns
    
# IO scheduler 
echo "Setting IO scheduler tweak..."
CONFFILE="midnight_io_sched.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep IO_SCHED_NOOP /system/etc/$CONFFILE`" ]; then
        SCHEDULER="noop"
    elif /sbin/busybox [ "`grep IO_SCHED_VR /system/etc/$CONFFILE`" ]; then
        SCHEDULER="vr"
    elif /sbin/busybox [ "`grep IO_SCHED_CFQ /system/etc/$CONFFILE`" ]; then
        SCHEDULER="cfq"
    elif /sbin/busybox [ "`grep IO_SCHED_DEADLINE /system/etc/$CONFFILE`" ]; then
        SCHEDULER="deadline"
    fi
fi
echo "Applying IO scheduler settings";
for i in $(ls -1 /sys/block/stl*) $(ls -1 /sys/block/mmc*) $(ls -1 /sys/block/bml*) $(ls -1 /sys/block/tfsr*); do echo $SCHEDULER > $i/queue/scheduler;done;


# END MIDNIGHT ADDITIONS
############################

# Onenand (stl) read ahead tweaks
echo "Setting onenand tweaks..."
  echo "64" > /sys/devices/virtual/bdi/138:9/read_ahead_kb
  echo "64" > /sys/devices/virtual/bdi/138:10/read_ahead_kb
  echo "64" > /sys/devices/virtual/bdi/138:11/read_ahead_kb

##### Post-init phase #####
sleep 12

# init.d support 
CONFFILE="midnight_misc.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep INIT_D /system/etc/$CONFFILE`" ]; then
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
    else
        echo "init.d support disabled..."
    fi
else 
    echo "init.d support disabled..."
fi

# Cleanup busybox
echo "Cleaning busybox..."
  /sbin/busybox_disabled rm /sbin/busybox
  /sbin/busybox_disabled mount rootfs -o remount,ro
echo "Ok, lets start Android... bye."
