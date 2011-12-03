# CPU governor
echo "CPU: Setting CPU governor..."
CONFFILE="midnight_cpu_gov.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep ONDEMAND /system/etc/$CONFFILE`" ]; then
        echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        CONFFILE2="midnight_cpu_gov_ond_up.conf" 
        govstep=0;stepup=85;
        if /sbin/busybox [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [ondemand] Calculated manual UP_THRESHOLD: $govstep"
            if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [ondemand] Not overriding preset";let stepup=stepup;else let stepup=govstep;fi
            echo "$stepup" > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold
        fi
    elif /sbin/busybox [ "`grep CONSERVATIVE /system/etc/$CONFFILE`" ]; then
        echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        #echo 15000 >  /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
        CONFFILE2="midnight_cpu_gov_cons_up.conf"
        govstep=0;stepup=60;stepdown=45;
        if /sbin/busybox [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+1;fi
            if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+2;fi
            if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+3;fi
            if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+4;fi
            if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+6;fi
            if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+7;fi
            if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+8;fi
            if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+9;fi
            if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [conservative] Calculated manual UP_THRESHOLD: $govstep"
            if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [conservative] Not overriding preset";let stepup=stepup;else let stepup=govstep;fi
            echo "$stepup" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold
        fi
        govstep=0;
        CONFFILE2="midnight_cpu_gov_cons_down.conf"
        if /sbin/busybox [ -f /system/etc/$CONFFILE2 ];then
            if /sbin/busybox [ "`grep 001$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+1;fi
            if /sbin/busybox [ "`grep 002$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+2;fi
            if /sbin/busybox [ "`grep 003$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+3;fi
            if /sbin/busybox [ "`grep 004$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+4;fi
            if /sbin/busybox [ "`grep 005$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+5;fi
            if /sbin/busybox [ "`grep 006$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+6;fi
            if /sbin/busybox [ "`grep 007$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+7;fi
            if /sbin/busybox [ "`grep 008$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+8;fi
            if /sbin/busybox [ "`grep 009$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+9;fi
            if /sbin/busybox [ "`grep 010$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+10;fi
            if /sbin/busybox [ "`grep 020$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+20;fi
            if /sbin/busybox [ "`grep 030$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+30;fi
            if /sbin/busybox [ "`grep 040$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+40;fi
            if /sbin/busybox [ "`grep 050$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+50;fi
            if /sbin/busybox [ "`grep 060$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+60;fi
            if /sbin/busybox [ "`grep 070$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+70;fi
            if /sbin/busybox [ "`grep 080$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+80;fi
            if /sbin/busybox [ "`grep 090$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+90;fi
            if /sbin/busybox [ "`grep 100$ /system/etc/$CONFFILE2`" ]; then let govstep=govstep+100;fi
            echo "CPU: [conservative] Calculated manual DOWN_THRESHOLD: $govstep"
            if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE2`" ]; then 
                echo "CPU: [conservative] Not overriding preset";let stepdown=stepdown;else let stepdown=govstep;fi
            echo "$stepdown" > /sys/devices/system/cpu/cpu0/cpufreq/conservative/down_threshold
        fi
    else
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    fi
else
    echo "Using default settings..."
fi

# Max. CPU frequency
echo "Setting CPU max freq..."
CONFFILE="midnight_cpu_max.conf"
echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep MAX_1200 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 1.2Ghz [arm/int voltages: 1310/1100mV]..."
        echo "1200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/busybox [ "`grep MAX_1000 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 1Ghz [stock voltages]..."
        echo "1000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/busybox [ "`grep MAX_800 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 800Mhz [stock voltages]..."
        echo "800000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    elif /sbin/busybox [ "`grep MAX_400 /system/etc/$CONFFILE`" ]; then
        echo "CPU: Setting max frequency 400Mhz [stock voltages]..."
        echo "400000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    fi
fi

uv100=0; uv200=0; uv400=0; uv800=0; uv1000=0; uv1200=0; uv1300=0;
# Undervolting presets
echo "UV: Setting undervolting presets..."
CONFFILE="midnight_cpu_uv.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep CPU_UV_0$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=0; uv200=0; uv100=0;
         echo "UV: using preset #0"
    elif /sbin/busybox [ "`grep CPU_UV_1$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=25; uv200=25; uv100=50;
         echo "UV: using preset #1"
    elif /sbin/busybox [ "`grep CPU_UV_2$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=25; uv200=50; uv100=50;
         echo "UV: using preset #2"
    elif /sbin/busybox [ "`grep CPU_UV_3$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=25; uv200=50; uv100=100;
         echo "UV: using preset #3"
    elif /sbin/busybox [ "`grep CPU_UV_4$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=100; uv100=100;
         echo "UV: using preset #4"
    elif /sbin/busybox [ "`grep CPU_UV_5$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=75; uv200=100; uv100=125;
         echo "UV: using preset #5"
    elif /sbin/busybox [ "`grep CPU_UV_6$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=100; uv100=125;
         echo "UV: using preset #6"
    elif /sbin/busybox [ "`grep CPU_UV_7$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=50; uv200=125; uv100=125;
         echo "UV: using preset #7"
    elif /sbin/busybox [ "`grep CPU_UV_8$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=25; uv400=100; uv200=125; uv100=150;
         echo "UV: using preset #8"
    elif /sbin/busybox [ "`grep CPU_UV_9$ /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=0; uv800=50; uv400=100; uv200=125; uv100=150;
         echo "UV: using preset #9"
    elif /sbin/busybox [ "`grep CPU_UV_10 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=0; uv1000=15; uv800=50; uv400=50; uv200=100; uv100=125;
         echo "UV: using preset #10"
    elif /sbin/busybox [ "`grep CPU_UV_11 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=5; uv1000=25; uv800=50; uv400=75; uv200=125; uv100=150;
         echo "UV: using preset #11"
    elif /sbin/busybox [ "`grep CPU_UV_12 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=10; uv1000=15; uv800=50; uv400=75; uv200=125; uv100=150;
         echo "UV: using preset #12"
    elif /sbin/busybox [ "`grep CPU_UV_13 /system/etc/$CONFFILE`" ]; then
         uv1300=0; uv1200=15; uv1000=25; uv800=50; uv400=75; uv200=125; uv100=150;
         echo "UV: using preset #13"
    elif /sbin/busybox [ "`grep CPU_UV_14 /system/etc/$CONFFILE`" ]; then
         uv1300=5; uv1200=10; uv1000=15; uv800=50; uv400=75; uv200=125; uv100=175;
         echo "UV: using preset #14"
    elif /sbin/busybox [ "`grep CPU_UV_15 /system/etc/$CONFFILE`" ]; then
         uv1300=10; uv1200=15; uv1000=25; uv800=75; uv400=100; uv200=150; uv100=175;
         echo "UV: using preset #15"
    else
         uv1300=0; uv1200=0; uv1000=0; uv800=0; uv400=0; uv200=0; uv100=0;
         echo "UV: no matching preset found, using default preset #0"
    fi
fi

echo "UV: Values after preset parsing: $uv1200, $uv1000, $uv800, $uv400, $uv200, $uv100"

set_manual_uv() {
    FREQ=$1
    ORIGUV=$2
    CF="midnight_cpu_uv_$1.conf"
    uv=0
    if /sbin/busybox [ -f /system/etc/$CF ];then
        uv=0
        if /sbin/busybox [ "`grep 005$ /system/etc/$CF`" ]; then uv=$(($uv+5));fi
        if /sbin/busybox [ "`grep 010$ /system/etc/$CF`" ]; then uv=$(($uv+10));fi
        if /sbin/busybox [ "`grep 020$ /system/etc/$CF`" ]; then uv=$(($uv+20));fi
        if /sbin/busybox [ "`grep 030$ /system/etc/$CF`" ]; then uv=$(($uv+30));fi
        if /sbin/busybox [ "`grep 040$ /system/etc/$CF`" ]; then uv=$(($uv+40));fi
        if /sbin/busybox [ "`grep 050$ /system/etc/$CF`" ]; then uv=$(($uv+50));fi
        if /sbin/busybox [ "`grep 060$ /system/etc/$CF`" ]; then uv=$(($uv+60));fi
        if /sbin/busybox [ "`grep 070$ /system/etc/$CF`" ]; then uv=$(($uv+70));fi
        if /sbin/busybox [ "`grep 080$ /system/etc/$CF`" ]; then uv=$(($uv+80));fi
        if /sbin/busybox [ "`grep 090$ /system/etc/$CF`" ]; then uv=$(($uv+90));fi
        if /sbin/busybox [ "`grep 100$ /system/etc/$CF`" ]; then uv=$(($uv+100));fi
        echo "UV: Calculated manual UV for $FREQ Mhz: $uv"
        echo "UV: Original UV for $FREQ Mhz mv: $ORIGUV"
        if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CF`" ]; then 
            echo "UV: Not overriding preset for $FREQ Mhz, returning $ORIGUVmv...";
            return $ORIGUV;
        else
            echo "UV: Returning calculated $uv mV..."
            return $uv;
        fi
    fi
    echo "UV: Not manual config for $FREQ Mhz, skipping..."
    return $ORIGUV
}

set_manual_uv 100 $uv100; uv100=$?
set_manual_uv 200 $uv200; uv200=$?
set_manual_uv 400 $uv400; uv400=$?
set_manual_uv 800 $uv800; uv800=$?
set_manual_uv 1000 $uv1000; uv1000=$?
set_manual_uv 1200 $uv1200; uv1200=$?

# if screenstate scaling enabled we have to adjust/remove
# UV for 400Mhz max idle frequency to not get sleep of death...
#echo "UV: Checking if screenstate scaling enabled..."
#CONFFILE="midnight_misc.conf"
#if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
#    if /sbin/busybox [ "`grep SCREENSTATE /system/etc/$CONFFILE`" ]; then
#        echo "UV: Screenstate scaling script activated, setting UV/400Mhz to +-0..."
#        uv400=0;
#    fi
#fi
 
echo "UV: Setting undervolting values: $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 mV"
echo $uv1200 $uv1000 $uv800 $uv400 $uv200 $uv100 > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

# debug log
echo -n "CPU: Check governor: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
if /sbin/busybox [ -e /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold ];then
    echo -n "CPU: Check governor conservative up_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/conservative/up_threshold
    echo -n "CPU: Check governor conservative down_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/conservative/down_threshold
fi
if /sbin/busybox [ -e /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold ];then
    echo -n "CPU: Check governor ondemand up_thr: ";cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold
fi
echo -n "CPU: Check max frequency: ";cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo -n "CPU: Check UV values: ";cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

