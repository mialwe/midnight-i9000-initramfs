CONFFILE="midnight_misc.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep SCREENSTATE /system/etc/$CONFFILE`" ]; then
        echo "Screenstate scaling script activated, proceeding..."
    else
        echo "Screenstate scaling script disabled, exiting..."
        exit 0    
    fi    
else
    echo "Screenstate scaling script disabled, exiting..."
    exit 0
fi

echo "CPU: Setting screenstate scaling CPU governor..."
SCREENSTATE_DEBUG=
# get current governor set up previously
AWAKE_GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
AWAKE_MAXFREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
AWAKE_UP=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/up_threshold`
AWAKE_SR=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/sampling_rate`        
if [ $AWAKE_GOVERNOR = "conservative" ];then
    AWAKE_DOWN=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/down_threshold`
else
    AWAKE_DOWN=
fi

echo "SCALING: Initial AWAKE GOV: $AWAKE_GOVERNOR"  
echo "SCALING: Initial AWAKE MAX: $AWAKE_MAXFREQ" 
echo "SCALING: Initial AWAKE UP: $AWAKE_UP" 
echo "SCALING: Initial AWAKE SR: $AWAKE_SR" 
echo "SCALING: Initial AWAKE DOWN: $AWAKE_DOWN" 

# define SLEEPING values...
SLEEP_GOVERNOR="conservative"
SLEEP_MAXFREQ=400000
echo "Starting screenstate scaling loop..."        
(while [ 1 ]; 
do
    AWAKE=`cat /sys/power/wait_for_fb_wake`;
    if [ $AWAKE = "awake" ]; then
        echo $AWAKE_GOVERNOR > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo $AWAKE_MAXFREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        echo $AWAKE_UP > /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/up_threshold
        echo $AWAKE_SR > /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/sampling_rate        
        if [ $AWAKE_GOVERNOR = "conservative" ];then
            echo $AWAKE_DOWN > /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/down_threshold
        fi
        echo 2000 > /proc/sys/vm/dirty_expire_centisecs;
        echo 2000 > /proc/sys/vm/dirty_writeback_centisecs;
        echo 100000 > /proc/sys/kernel/sched_latency_ns
        echo 500000 > /proc/sys/kernel/sched_wakeup_granularity_ns
        echo 750000 > /proc/sys/kernel/sched_min_granularity_ns
        if [ $SCREENSTATE_DEBUG ];then
            echo -n "AWAKE gov: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
            echo -n "AWAKE max: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
            echo -n "AWAKE up: ";cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/up_threshold
            echo -n "AWAKE sr: ";cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/sampling_rate        
            if [ $AWAKE_GOVERNOR = "conservative" ];then
                echo -n "AWAKE down: ";cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/down_threshold
            fi
            echo -n "AWAKE expire: ";cat /proc/sys/vm/dirty_expire_centisecs;
            echo -n "AWAKE writeback: ";cat /proc/sys/vm/dirty_writeback_centisecs;
        fi
    fi
    sleep 3;
 
    SLEEP=`cat /sys/power/wait_for_fb_sleep`;
    if [ $SLEEP = "sleeping" ]; then    
        # get current governor set up previously
        AWAKE_GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
        AWAKE_MAXFREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
        AWAKE_UP=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/up_threshold`
        AWAKE_SR=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/sampling_rate`        
        if [ $AWAKE_GOVERNOR = "conservative" ];then
            AWAKE_DOWN=`cat /sys/devices/system/cpu/cpufreq/$AWAKE_GOVERNOR/down_threshold`
        fi
        echo $SLEEP_GOVERNOR > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo $SLEEP_MAXFREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        echo 10000 > /proc/sys/vm/dirty_expire_centisecs;
        echo 10000 > /proc/sys/vm/dirty_writeback_centisecs;
        echo 3 > /proc/sys/vm/drop_caches
        echo 75 > /sys/devices/system/cpu/cpufreq/conservative/up_threshold
        echo 35 > /sys/devices/system/cpu/cpufreq/conservative/down_threshold
        echo 500000 > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate        
        echo 10000000 > /proc/sys/kernel/sched_latency_ns;
        echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns;
        echo 4000000 > /proc/sys/kernel/sched_min_granularity_ns;
        if [ $SCREENSTATE_DEBUG ];then
            echo -n "SLEEP gov: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
            echo -n "SLEEP max: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
            echo -n "SLEEP up: ";cat /sys/devices/system/cpu/cpufreq/$SLEEP_GOVERNOR/up_threshold
            echo -n "SLEEP sr: ";cat /sys/devices/system/cpu/cpufreq/$SLEEP_GOVERNOR/sampling_rate        
            if [ $AWAKE_GOVERNOR = "conservative" ];then
                echo -n "SLEEP down: ";cat /sys/devices/system/cpu/cpufreq/$SLEEP_GOVERNOR/down_threshold
            fi
            echo -n "SLEEP expire: ";cat /proc/sys/vm/dirty_expire_centisecs;
            echo -n "SLEEP writeback: ";cat /proc/sys/vm/dirty_writeback_centisecs;
        fi
    fi    
    sleep 3;    
done &);
