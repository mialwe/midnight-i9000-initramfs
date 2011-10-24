# Lowmemorykiller/ADJ settings (o:2560,4096,6144,10240,11264,12288)
echo "LMK tweaks"
CONFFILE="midnight_lmk.conf"
ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14080;ADJ14=15360;ADJ15=20480;
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep LMK0 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14080;ADJ14=15360;ADJ15=20480;
    elif /sbin/ext/busybox [ "`grep LMK1 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=3072;ADJ2=4096;ADJ7=6144;ADJ14=7168;ADJ15=8192;
    elif /sbin/ext/busybox [ "`grep LMK2 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=7168;ADJ14=9216;ADJ15=10752;
    elif /sbin/ext/busybox [ "`grep LMK3 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=9216;ADJ14=12288;ADJ15=14336;
    elif /sbin/ext/busybox [ "`grep LMK4 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11264;ADJ7=12288;ADJ14=14336;ADJ15=17408;
    elif /sbin/ext/busybox [ "`grep LMK5 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14336;ADJ14=17408;ADJ15=22528;
    elif /sbin/ext/busybox [ "`grep LMK6 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=15872;ADJ14=18944;ADJ15=24576;
    else
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14080;ADJ14=15360;ADJ15=20480;
    fi
fi

# Manual lowmemorykiller values
CONFFILE="midnight_lmk_slot1.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot1 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot1: $lmkval"
    echo "LMK: Original lmk slot1: $ADJ0"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ0=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot2.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot2 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot2: $lmkval"
    echo "LMK: Original lmk slot2: $ADJ1"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ1=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot3.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot3 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot3: $lmkval"
    echo "LMK: Original lmk slot3: $ADJ2"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ2=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot4.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot4 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot4: $lmkval"
    echo "LMK: Original lmk slot4: $ADJ7"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ7=$lmkval;
    fi
fi
    
CONFFILE="midnight_lmk_slot5.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot5 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot5: $lmkval"
    echo "LMK: Original lmk slot5: $ADJ14"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ14=$lmkval;
    fi
fi

CONFFILE="midnight_lmk_slot6.conf"
if [ -f /system/etc/$CONFFILE ];then
    lmkval=0
    if /sbin/ext/busybox [ "`grep 001$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+1));fi
    if /sbin/ext/busybox [ "`grep 002$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+2));fi
    if /sbin/ext/busybox [ "`grep 003$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+3));fi
    if /sbin/ext/busybox [ "`grep 004$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+4));fi
    if /sbin/ext/busybox [ "`grep 005$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+5));fi
    if /sbin/ext/busybox [ "`grep 006$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+6));fi
    if /sbin/ext/busybox [ "`grep 007$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+7));fi
    if /sbin/ext/busybox [ "`grep 008$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+8));fi
    if /sbin/ext/busybox [ "`grep 009$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+9));fi
    if /sbin/ext/busybox [ "`grep 010$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+10));fi
    if /sbin/ext/busybox [ "`grep 020$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+20));fi
    if /sbin/ext/busybox [ "`grep 030$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+30));fi
    if /sbin/ext/busybox [ "`grep 040$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+40));fi
    if /sbin/ext/busybox [ "`grep 050$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+50));fi
    if /sbin/ext/busybox [ "`grep 060$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+60));fi
    if /sbin/ext/busybox [ "`grep 070$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+70));fi
    if /sbin/ext/busybox [ "`grep 080$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+80));fi
    if /sbin/ext/busybox [ "`grep 090$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+90));fi
    if /sbin/ext/busybox [ "`grep 100$ /system/etc/$CONFFILE`" ]; then lmkval=$(($lmkval+100));fi
    echo "LMK: Manual lmk slot6 Mb: $lmkval"
    lmkval=$(($lmkval*1000/4*1024/1000))
    echo "LMK: Calculated manual lmk slot6: $lmkval"
    echo "LMK: Original lmk slot6: $ADJ15"
    if /sbin/ext/busybox [ "`grep NOOVERRIDE$ /system/etc/$CONFFILE`" ]; then 
        echo "LMK: Not overriding preset";
    else 
        echo "LMK: Overriding preset"
        ADJ15=$lmkval;
    fi
fi
echo "LMK: Calculated values: $ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15"
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
