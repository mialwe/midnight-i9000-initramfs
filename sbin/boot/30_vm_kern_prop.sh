CONFFILE="midnight_misc.conf"
echo "Setting misc. options..."
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep NOTWEAKS /system/etc/$CONFFILE`" ]; then
        echo "Midnight tweaks disabled, nothing to do."
        exit
    else
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

        # readded 2011/12/17, testing, from Thunderbolt/Pikachu01
        echo 400000 > /proc/sys/kernel/sched_latency_ns;
        echo 100000 > /proc/sys/kernel/sched_wakeup_granularity_ns;
        echo 200000 > /proc/sys/kernel/sched_min_granularity_ns;

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
        
    fi
fi
