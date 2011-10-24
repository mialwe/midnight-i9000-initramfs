# CPU governor
echo "CPU: Setting CPU governor..."
CONFFILE="midnight_cpu_gov.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep ONDEMAND /system/etc/$CONFFILE`" ]; then
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        CONFFILE2="midnight_cpu_gov_ond_up.conf" 
        govstep=0;stepup=85;
        if [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [ondemand] Calculated manual UP_THRESHOLD: $govstep"
            if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [ondemand] Not overriding preset";let stepup=stepup;else let stepup=govstep;fi
            echo "$stepup" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold
        fi
    elif /sbin/ext/busybox [ "`grep CONSERVATIVE /system/etc/$CONFFILE`" ]; then
        echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 15000 >  /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
        CONFFILE2="midnight_cpu_gov_cons_up.conf"
        govstep=0;stepup=60;stepdown=45;
        if [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+1;fi
            if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+2;fi
            if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+3;fi
            if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+4;fi
            if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+6;fi
            if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+7;fi
            if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+8;fi
            if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+9;fi
            if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [conservative] Calculated manual UP_THRESHOLD: $govstep"
            if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [conservative] Not overriding preset";let stepup=stepup;else let stepup=govstep;fi
            echo "$stepup" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold
        fi
        govstep=0;
        CONFFILE2="midnight_cpu_gov_cons_down.conf"
        if [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+1;fi
            if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+2;fi
            if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+3;fi
            if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+4;fi
            if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+6;fi
            if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+7;fi
            if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+8;fi
            if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+9;fi
            if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [conservative] Calculated manual DOWN_THRESHOLD: $govstep"
            if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [conservative] Not overriding preset";let stepdown=stepdown;else let stepdown=govstep;fi
            echo "$stepdown" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/down_threshold
        fi
    else
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo 80000 > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
    fi
else
    # cons default, adjust sr
    echo 80000 > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
fi

# Max. CPU frequency
echo "Setting CPU max freq..."
CONFFILE="midnight_cpu_max.conf"
echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep MAX_1200 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 1.2Ghz [arm/int voltages 1310/1100mV]..."
        echo "1200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/ext/busybox [ "`grep MAX_1000 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 1Ghz [stock voltages]..."
        echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/ext/busybox [ "`grep MAX_800 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 800Mhz [stock voltages]..."
        echo "800000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/ext/busybox [ "`grep MAX_400 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 400Mhz [stock voltages]..."
        echo "400000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    fi
fi
#sleep 3
#insmod /lib/modules/cpufreq_stats.ko

uv100=0; uv200=0; uv400=0; uv800=0; uv1000=0; uv1200=0; uv1300=0;
# Undervolting presets
echo "UV: Setting undervolting presets..."
CONFFILE="midnight_cpu_uv.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep CPU_UV_0$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=0; uv200=0; uv100=0;
    elif /sbin/ext/busybox [ "`grep CPU_UV_1$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=25; uv200=25; uv100=50;
    elif /sbin/ext/busybox [ "`grep CPU_UV_2$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=25; uv200=50; uv100=50;
    elif /sbin/ext/busybox [ "`grep CPU_UV_3$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=25; uv200=50; uv100=100;
    elif /sbin/ext/busybox [ "`grep CPU_UV_4$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=100; uv100=100;
    elif /sbin/ext/busybox [ "`grep CPU_UV_5$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=75; uv200=100; uv100=125;
    elif /sbin/ext/busybox [ "`grep CPU_UV_6$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=100; uv100=125;
    elif /sbin/ext/busybox [ "`grep CPU_UV_7$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=125; uv100=125;
    elif /sbin/ext/busybox [ "`grep CPU_UV_8$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=100; uv200=125; uv100=150;
    elif /sbin/ext/busybox [ "`grep CPU_UV_9$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=50; uv400=100; uv200=125; uv100=150;
    elif /sbin/ext/busybox [ "`grep CPU_UV_10 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=15; uv800=50; uv400=50; uv200=100; uv100=125;
    elif /sbin/ext/busybox [ "`grep CPU_UV_11 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=5; uv1000=25; uv800=50; uv400=75; uv200=125; uv100=150;
    elif /sbin/ext/busybox [ "`grep CPU_UV_12 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=10; uv1000=15; uv800=50; uv400=75; uv200=125; uv100=150;
    elif /sbin/ext/busybox [ "`grep CPU_UV_13 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=15; uv1000=25; uv800=50; uv400=75; uv200=125; uv100=150;
    elif /sbin/ext/busybox [ "`grep CPU_UV_14 /system/etc/$CONFFILE`" ]; then
         uv1300=5; uv1200=10; uv1000=15; uv800=50; uv400=75; uv200=125; uv100=175;
    elif /sbin/ext/busybox [ "`grep CPU_UV_15 /system/etc/$CONFFILE`" ]; then
         uv1300=10; uv1200=15; uv1000=25; uv800=75; uv400=100; uv200=150; uv100=175;
    else
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=0; uv200=0; uv100=0;
    fi
fi

echo "UV: Checking if screenstate scaling enabled..."
CONFFILE="midnight_misc.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep SCREENSTATE /system/etc/$CONFFILE`" ]; then
        echo "UV: Screenstate scaling script activated, setting UV/400Mhz to +-0..."
        uv400=0;
    fi
fi

echo "UV: Values after preset parsing: $uv1200, $uv1000, $uv800, $uv400, $uv200, $uv100"

# Manual undervolting values
CONFFILE="midnight_cpu_uv_100.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV mv: $uv"
    echo "UV: Original UV 100Mhz mv: $uv100"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv100=$uv100;else uv100=$uv;fi
fi

CONFFILE="midnight_cpu_uv_200.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV 200Mhz mv: $uv"
    echo "UV: Original UV 200Mhz mv: $uv200"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv200=$uv200;else uv200=$uv;fi
fi

CONFFILE="midnight_cpu_uv_400.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV 400Mhz mv: $uv"
    echo "UV: Original UV 400Mhz mv: $uv400"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv400=$uv400;else uv400=$uv;fi
fi

CONFFILE="midnight_cpu_uv_800.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV 800Mhz mv: $uv"
    echo "UV: Original UV 800Mhz mv: $uv800"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv800=$uv800;else uv800=$uv;fi
fi

CONFFILE="midnight_cpu_uv_1000.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV 1000Mhz mv: $uv"
    echo "UV: Original UV 1000Mhz mv: $uv1000"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv1000=$uv1000;else uv1000=$uv;fi
fi    

CONFFILE="midnight_cpu_uv_1200.conf"
if [ -f /system/etc/$CONFFILE ];then
    uv=0
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+5));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then uv=$(($uv+100));fi
    echo "UV: Calculated manual UV 1200Mhz mv: $uv"
    echo "UV: Original UV 1200Mhz mv: $uv1200"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "UV: Not overriding preset";uv1200=$uv1200;else uv1200=$uv;fi
fi    
echo "UV: Setting undervolting values: $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 mV"
echo $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

# debug log
echo -n "CPU: Check governor: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
if [ -e /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold ];then
    echo -n "CPU: Check governor conservative up_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold
    echo -n "CPU: Check governor conservative down_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/conservative/down_threshold
fi
if [ -e /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold ];then
    echo -n "CPU: Check governor ondemand up_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold
fi
echo -n "CPU: Check max frequency: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo -n "CPU: Check UV values: ";cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
echo -n "CPU Check sampling rate: ";cat /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
