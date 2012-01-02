echo "Mounting rootfs readwrite..."
/sbin/busybox mount -t rootfs -o remount,rw rootfs

echo "Remounting partitions with speed tweaks..."
for k in $(/sbin/busybox mount | busybox grep relatime | busybox cut -d " " -f3)
do
    sync
    /sbin/busybox mount -o remount,noatime,nodiratime $k
done

echo "Trying to remount EXT4 partitions with speed tweaks if any..."
for k in $(/sbin/busybox mount | grep ext4 | cut -d " " -f3)
do
  sync;
  if /sbin/busybox [ "$k" = "/system" ]; then
    /sbin/busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
  elif /sbin/busybox [ "$k" = "/dbdata" ]; then
    /sbin/busybox mount -o remount,noauto_da_alloc,barrier=1,nodelalloc,commit=40 $k;
  elif /sbin/busybox [ "$k" = "/data" ]; then
    /sbin/busybox mount -o remount,noauto_da_alloc,barrier=1,commit=40 $k;
  elif /sbin/busybox [ "$k" = "/cache" ]; then
    /sbin/busybox mount -o remount,noauto_da_alloc,barrier=0,commit=40 $k;
  fi;
done

echo "MOUNT: Check mounted partitions: "
/sbin/busybox mount|grep /system
/sbin/busybox mount|grep /data
/sbin/busybox mount|grep /dbdata
/sbin/busybox mount|grep /cache

#--------------------------------------------------------------------
echo
echo "LMK tweaks"
# Lowmemorykiller/ADJ settings (o:2560,4096,6144,10240,11264,12288)
# old: ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14080;ADJ14=15360;ADJ15=17920;
# new: 6,9,20,30,60,70 Mb 
ADJ0=1536;ADJ1=2304;ADJ2=5120;ADJ7=7680;ADJ14=15360;ADJ15=17920;

echo "LMK: Setting APP ADJs..."
setprop ro.FOREGROUND_APP_MEM "$ADJ0"
setprop ro.HOME_APP_MEM "$ADJ1"
setprop ro.VISIBLE_APP_MEM "$ADJ1"
setprop ro.PERCEPTIBLE_APP_MEM "$ADJ2"
setprop ro.HEAVY_WEIGHT_APP_MEM "$ADJ2"
setprop ro.SECONDARY_SERVER_MEM "$ADJ2"
setprop ro.BACKUP_APP_MEM "$ADJ2"
setprop ro.HIDDEN_APP_MEM "$ADJ7"
setprop ro.CONTENT_PROVIDER_MEM "$ADJ14"
setprop ro.EMPTY_APP_MEM "$ADJ15"

echo "LMK: Setting minfree values..."  
echo "$ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15" > /sys/module/lowmemorykiller/parameters/minfree
echo "0,1,2,7,14,15" > /sys/module/lowmemorykiller/parameters/adj

echo "LMK: Check used values:"
echo -n "LMK: FOREGROUND_APP_MEM: ";getprop ro.FOREGROUND_APP_MEM
echo -n "LMK: HOME_APP_MEM: ";getprop ro.HOME_APP_MEM
echo -n "LMK: VISIBLE_APP_MEM: ";getprop ro.VISIBLE_APP_MEM
echo -n "LMK: PERCEPTIBLE_APP_MEM: ";getprop ro.PERCEPTIBLE_APP_MEM
echo -n "LMK: HEAVY_WEIGHT_APP_MEM: ";getprop ro.HEAVY_WEIGHT_APP_MEM
echo -n "LMK: SECONDARY_SERVER_MEM: ";getprop ro.SECONDARY_SERVER_MEM
echo -n "LMK: BACKUP_APP_MEM: ";getprop ro.BACKUP_APP_MEM
echo -n "LMK: HIDDEN_APP_MEM: ";getprop ro.HIDDEN_APP_MEM
echo -n "LMK: CONTENT_PROVIDER_MEM: ";getprop ro.CONTENT_PROVIDER_MEM
echo -n "LMK: EMPTY_APP_MEM: ";getprop ro.EMPTY_APP_MEM
echo -n "LMK: /sys/module/lowmemorykiller/parameters/minfree: ";cat /sys/module/lowmemorykiller/parameters/minfree
echo -n "LMK: /sys/module/lowmemorykiller/parameters/adj: ";cat /sys/module/lowmemorykiller/parameters/adj
echo "LMK: Check ADJs:"
getprop|grep ADJ

#--------------------------------------------------------------------
echo
echo "VM: setting VM tweaks..."
echo "0" > /proc/sys/vm/swappiness                   # Not really needed as no /swap used...
echo "2000" > /proc/sys/vm/dirty_writeback_centisecs # Flush after 20sec. (o:500)
echo "2000" > /proc/sys/vm/dirty_expire_centisecs    # Pages expire after 20sec. (o:200)
echo "55" > /proc/sys/vm/dirty_background_ratio      # flush pages later (default 5% active mem)
echo "80" > /proc/sys/vm/dirty_ratio                 # process writes pages later (default 20%)  
echo "5" > /proc/sys/vm/page-cluster
echo "0" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/panic_on_oom
echo "0" > /proc/sys/vm/overcommit_memory
        
echo -n "VM: check vm/swappiness :";cat /proc/sys/vm/swappiness                   
echo -n "VM: check vm/dirty_writeback_centisecs :";cat /proc/sys/vm/dirty_writeback_centisecs
echo -n "VM: check vm/dirty_expire_centisecs: ";cat /proc/sys/vm/dirty_expire_centisecs    
echo -n "VM: check vm/dirty_background_ratio: ";cat /proc/sys/vm/dirty_background_ratio
echo -n "VM: check vm/dirty_ratio :";cat /proc/sys/vm/dirty_ratio       
echo -n "VM: check vm/page-cluster: ";cat /proc/sys/vm/page-cluster
echo -n "VM: check vm/laptop_mode: ";cat /proc/sys/vm/laptop_mode
echo -n "VM: check vm/oom_kill_allocating_task: ";cat /proc/sys/vm/oom_kill_allocating_task
echo -n "VM: check vm/panic_on_oom: ";cat /proc/sys/vm/panic_on_oom
echo -n "VM: check vm/overcommit_memory: ";cat /proc/sys/vm/overcommit_memory

echo
echo "SETPROP: setting prop tweaks..."
setprop debug.sf.hw 1
setprop debug.sf.nobootanimation 0;
setprop wifi.supplicant_scan_interval 180;
setprop windowsmgr.max_events_per_sec 76;
setprop ro.ril.disable.power.collapse 1;
setprop ro.telephony.call_ring.delay 1000;
setprop mot.proximity.delay 150;
setprop ro.mot.eri.losalert.delay 1000;
setprop debug.performance.tuning 1
setprop video.accelerate.hw 1

echo -n "debug.sf.hw: ";getprop debug.sf.hw
echo -n "debug.sf.nobootanimation: ";getprop debug.sf.nobootanimation
echo -n "wifi.supplicant_scan_interval: ";getprop wifi.supplicant_scan_interval
echo -n "windowsmgr.max_events_per_sec: ";getprop windowsmgr.max_events_per_sec
echo -n "ro.ril.disable.power.collapse: ";getprop ro.ril.disable.power.collapse
echo -n "ro.telephony.call_ring.delay: ";getprop ro.telephony.call_ring.delay
echo -n "mot.proximity.delay: ";getprop mot.proximity.delay
echo -n "ro.mot.eri.losalert.delay: ";getprop ro.mot.eri.losalert.delay
echo -n "debug.performance.tuning: ";getprop debug.performance.tuning
echo -n "video.accelerate.hw: ";getprop video.accelerate.hw

echo
echo "KERNEL: setting kernel tweaks..."
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features

echo 500 512000 64 2048 > /proc/sys/kernel/sem; 

echo 1000000 > /proc/sys/kernel/sched_latency_ns;
echo 100000 > /proc/sys/kernel/sched_wakeup_granularity_ns;
echo 500000 > /proc/sys/kernel/sched_min_granularity_ns;

# readded 2011/12/17, testing, from Thunderbolt/Pikachu01
#echo 400000 > /proc/sys/kernel/sched_latency_ns;
#echo 100000 > /proc/sys/kernel/sched_wakeup_granularity_ns;
#echo 200000 > /proc/sys/kernel/sched_min_granularity_ns;

# readded 2011/12/13, testing, from Thunderbolt/Pikachu01
#echo 600000 > /proc/sys/kernel/sched_latency_ns;
#echo 100000 > /proc/sys/kernel/sched_wakeup_granularity_ns;
#echo 200000 > /proc/sys/kernel/sched_min_granularity_ns;

# Midnight original
#echo 100000 > /proc/sys/kernel/sched_latency_ns
#echo 500000 > /proc/sys/kernel/sched_wakeup_granularity_ns
#echo 750000 > /proc/sys/kernel/sched_min_granularity_ns

echo 0 > /proc/sys/kernel/panic_on_oops
echo 0 > /proc/sys/kernel/panic

# have to re-check those...
#echo 2048 > /proc/sys/kernel/msgmni 
#echo 64000 > /proc/sys/kernel/msgmax
#echo 268435456 > /proc/sys/kernel/shmmax

echo -n "KERNEL: check sched_latency_ns: ";cat /proc/sys/kernel/sched_latency_ns
echo -n "KERNEL: check sched_wakeup_granularity_ns: "; cat /proc/sys/kernel/sched_wakeup_granularity_ns
echo -n "KERNEL: check sched_min_granularity_ns: ";cat /proc/sys/kernel/sched_min_granularity_ns
echo -n "KERNEL: check sleepers: ";cat /sys/kernel/debug/sched_features
echo -n "KERNEL: check semaphores: ";cat /proc/sys/kernel/sem

echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes
echo 30 > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 0 > /proc/sys/net/ipv4/tcp_timestamps

#--------------------------------------------------------------------
 echo
# Screen color settings
# echo 3 > /sys/class/misc/rgbb_multiplier/brightness_multiplier lowered brightness
# echo 3609991042 > /sys/class/misc/rgbb_multiplier/blue_multiplier Midnight default
# echo 3999991042 > /sys/class/misc/rgbb_multiplier/blue_multiplier colder
# echo 4285991042 > /sys/class/misc/rgbb_multiplier/blue_multiplier even colder :)

echo "Setting video driver options..."
echo -n "Initial R: ";cat /sys/class/misc/rgbb_multiplier/red_multiplier
echo -n "Initial G: ";cat /sys/class/misc/rgbb_multiplier/green_multiplier
echo -n "Initial B: ";cat /sys/class/misc/rgbb_multiplier/blue_multiplier

echo 1559970880 > /sys/class/misc/rgbb_multiplier/red_multiplier
echo 1349744960 > /sys/class/misc/rgbb_multiplier/green_multiplier
echo 2556528160 > /sys/class/misc/rgbb_multiplier/blue_multiplier

#echo 2259970880 > /sys/class/misc/rgbb_multiplier/red_multiplier
#echo 2249744960 > /sys/class/misc/rgbb_multiplier/green_multiplier
#echo 2556528160 > /sys/class/misc/rgbb_multiplier/blue_multiplier

echo -n "Adjusted R: ";cat /sys/class/misc/rgbb_multiplier/red_multiplier
echo -n "Adjusted G: ";cat /sys/class/misc/rgbb_multiplier/green_multiplier
echo -n "Adjusted B: ";cat /sys/class/misc/rgbb_multiplier/blue_multiplier

#--------------------------------------------------------------------
echo
CONFFILE="midnight_misc.conf"
echo "Setting misc. options..."
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then

    # enable IPv6 privacy
    if /sbin/busybox [ "`grep IPV6PRIVACY /system/etc/$CONFFILE`" ]; then
      echo "Setting various IPv4/IPv6 security enhancements..."
      echo 0 > /proc/sys/net/ipv4/ip_forward
      echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
      echo 2 > /proc/sys/net/ipv6/conf/all/use_tempaddr
      echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
      echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
      echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
      #echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all      

      echo -n "    ip_forward :";cat /proc/sys/net/ipv4/ip_forward
      echo -n "    rp_filter :";cat /proc/sys/net/ipv4/conf/all/rp_filter
      echo -n "    use_tempaddr :";cat /proc/sys/net/ipv6/conf/all/use_tempaddr
      echo -n "    accept_source_route :";cat /proc/sys/net/ipv4/conf/all/accept_source_route
      echo -n "    send_redirects :";cat /proc/sys/net/ipv4/conf/all/send_redirects
      echo -n "    icmp_echo_ignore_broadcasts :";cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
      #echo -n "    icmp_echo_ignore_all :";cat /proc/sys/net/ipv4/icmp_echo_ignore_all      
    fi

    # enable logger (LOGCAT) 
    if /sbin/busybox [ "`grep ANDROIDLOGGER /system/etc/$CONFFILE`" ]; then
      echo "MODULE: logger.ko loaded by init.rc, doing nothing..."
      #insmod /lib/modules/logger.ko
    else
      echo "MODULE: logger.ko disabled, unloading..."
      rmmod logger.ko
      rm /lib/modules/logger.ko
    fi

    # enable CIFS module loading 
    if /sbin/busybox [ "`grep CIFS /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading cifs.ko..."
      insmod /lib/modules/cifs.ko
    else
      rm /lib/modules/cifs.ko
    fi
    
    # enable TUN module loading 
    if /sbin/busybox [ "`grep TUN /system/etc/$CONFFILE`" ]; then
      echo "MODULE: loading tun.ko..."
      insmod /lib/modules/tun.ko
      echo "Disabling IPv4 rp_filter for VPN..."
      echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
      echo -n "    rp_filter :";cat /proc/sys/net/ipv4/conf/all/rp_filter
    else
      rm /lib/modules/tun.ko
    fi
    
    if /sbin/busybox [ "`grep TOUCH /system/etc/$CONFFILE`" ]; then
        echo "Setting touchscreen enhancements..."
        echo 7027 > /sys/class/touch/switch/set_touchscreen
        echo 8001 > /sys/class/touch/switch/set_touchscreen
        echo 11001 > /sys/class/touch/switch/set_touchscreen
        echo 13020 > /sys/class/touch/switch/set_touchscreen
        echo 14005 > /sys/class/touch/switch/set_touchscreen    
    fi

    if /sbin/busybox [ "`grep OC /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 1.2Ghz [arm/int voltages: 1310/1100mV]..."
        echo "1200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    fi

    if /sbin/busybox [ "`grep ONDEMAND /system/etc/$CONFFILE`" ]; then
        echo "Setting CPU governor: ONDEMAND..."
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    fi

    if /sbin/busybox [ "`grep NOOP /system/etc/$CONFFILE`" ]; then
        echo "Setting IO scheduler: NOOP..."
        STL=`ls -d /sys/block/stl*`;
        BML=`ls -d /sys/block/bml*`;
        MMC=`ls -d /sys/block/mmc*`;
        TFSR=`ls -d /sys/block/tfsr*`;
        for i in $STL $BML $MMC $TFSR; do 
            echo "noop" > "$i"/queue/scheduler;
        done;    
    fi

fi
echo "Checking loaded modules:"
lsmod

#--------------------------------------------------------------------
echo
uv100=0; uv200=0; uv400=0; uv800=0; uv1000=0; uv1200=0;
# Undervolting presets
echo "UV: Setting undervolting presets..."
CONFFILE="midnight_cpu_uv.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep CPU_UV_1$ /system/etc/$CONFFILE`" ]; then
         uv1200=0; uv1000=15; uv800=25; uv400=50; uv200=50; uv100=75;
         echo "UV: using preset #1"
    elif /sbin/busybox [ "`grep CPU_UV_2$ /system/etc/$CONFFILE`" ]; then
         uv1200=15; uv1000=20; uv800=50; uv400=75; uv200=100; uv100=100;
         echo "UV: using preset #2"
    elif /sbin/busybox [ "`grep CPU_UV_3$ /system/etc/$CONFFILE`" ]; then
         uv1200=20; uv1000=25; uv800=50; uv400=75; uv200=100; uv100=125;
         echo "UV: using preset #2"
    fi
fi

echo "UV: Setting undervolting values: $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 mV"
echo $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

# debug log
echo -n "CPU: Check governor: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo -n "CPU: Check max frequency: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo -n "CPU: Check UV values: ";cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

#--------------------------------------------------------------------
echo
echo "IO: Setting sdcard READ_AHEAD..."
echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
echo "1024" > /sys/devices/virtual/bdi/179:8/read_ahead_kb

if /sbin/busybox [ -e /sys/devices/virtual/bdi/default/read_ahead_kb ]; then
    echo "Setting default READ_AHEAD..."
    echo "512" > /sys/devices/virtual/bdi/default/read_ahead_kb;
fi;

echo -n "IO: check READ_AHEAD 179.0: "; cat /sys/devices/virtual/bdi/179:0/read_ahead_kb
echo -n "IO: check READ_AHEAD 179.8: "; cat /sys/devices/virtual/bdi/179:8/read_ahead_kb

# Onenand (stl) read ahead tweaks
echo "IO: Setting onenand tweaks..."
echo "64" > /sys/devices/virtual/bdi/138:9/read_ahead_kb
echo "64" > /sys/devices/virtual/bdi/138:10/read_ahead_kb
echo "64" > /sys/devices/virtual/bdi/138:11/read_ahead_kb 


STL=`ls -d /sys/block/stl*`;
BML=`ls -d /sys/block/bml*`;
MMC=`ls -d /sys/block/mmc*`;
TFSR=`ls -d /sys/block/tfsr*`;


for i in $STL $BML $MMC $TFSR; 
do                            
    echo 0 > $i/queue/rotational;               
    echo 0 > $i/queue/iostats;
    if /sbin/busybox [ -e $i/queue/nr_requests ];then
        echo 8192 > $i/queue/nr_requests
    fi
    if /sbin/busybox [ -e $i/queue/iosched/writes_starved ];then
        echo 1 > $i/queue/iosched/writes_starved
    fi    
    if /sbin/busybox [ -e $i/queue/iosched/fifo_batch ];then
        echo 1 > $i/queue/iosched/fifo_batch
    fi
done;

echo "Recheck values (printing for stl10 only):"
echo -n "IO: Recheck scheduler: "; cat /sys/block/stl10/queue/scheduler
echo -n "IO: Recheck rotational: "; cat /sys/block/stl10/queue/rotational
echo -n "IO: Recheck iostats: "; cat /sys/block/stl10/queue/iostats
if /sbin/busybox [ -e /sys/block/stl10/queue/rq_affinity ];then
    echo -n "IO: Recheck rq_affinity (1): "; cat /sys/block/stl10/queue/rq_affinity                          
fi
if /sbin/busybox [ -e /sys/block/stl10/queue/nr_requests ];then
    echo -n "IO: Recheck nr_requests (8192): ";cat /sys/block/stl10/queue/nr_requests
fi
if /sbin/busybox [ -e /sys/block/stl10/queue/iosched/writes_starved ];then
    echo -n "IO: Recheck writes_starved (1): "; cat /sys/block/stl10/queue/iosched/writes_starved
fi    
if /sbin/busybox [ -e /sys/block/stl10/queue/iosched/fifo_batch ];then
    echo -n "IO: Recheck fifo_batch (1): "; cat /sys/block/stl10/queue/iosched/fifo_batch
fi

#--------------------------------------------------------------------                
echo
# init.d support 
CONFFILE="midnight_misc.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
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
    else
        echo "init.d support disabled..."
    fi
else 
    echo "init.d support disabled..."
fi

#--------------------------------------------------------------------
                
echo
echo "RAM (/proc/meminfo):"
cat /proc/meminfo|grep ^MemTotal
cat /proc/meminfo|grep ^MemFree
cat /proc/meminfo|grep ^Buffers
cat /proc/meminfo|grep ^Cached
echo
echo "Disabling /sbin/busybox, using /system/xbin/busybox now..."
/sbin/busybox_disabled rm /sbin/busybox

echo "Mounting rootfs readonly..."
/sbin/busybox_disabled mount -t rootfs -o remount,ro rootfs;


