# Lowmemorykiller/ADJ settings (o:2560,4096,6144,10240,11264,12288)
echo "LMK tweaks"
CONFFILE="midnight_lmk.conf"
# old: ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14080;ADJ14=15360;ADJ15=17920;
# new: 6,9,13,48,60,70 Mb 
ADJ0=1536;ADJ1=2304;ADJ2=3328;ADJ7=12288;ADJ14=15360;ADJ15=17920;
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    echo "LMK: Setting preset..."
    if /sbin/busybox [ "`grep LMK0 /system/etc/$CONFFILE`" ]; then
        ADJ0=1536;ADJ1=2304;ADJ2=3328;ADJ7=12288;ADJ14=15360;ADJ15=17920;
        echo "LMK: using preset #0"
    elif /sbin/busybox [ "`grep LMK1 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=3072;ADJ2=4096;ADJ7=6144;ADJ14=7168;ADJ15=8192;
        echo "LMK: using preset #1"
    elif /sbin/busybox [ "`grep LMK2 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=7168;ADJ14=9216;ADJ15=10752;
        echo "LMK: using preset #2"
    elif /sbin/busybox [ "`grep LMK3 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=6144;ADJ7=9216;ADJ14=12288;ADJ15=14336;
        echo "LMK: using preset #3"
    elif /sbin/busybox [ "`grep LMK4 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11264;ADJ7=12288;ADJ14=14336;ADJ15=17408;
        echo "LMK: using preset #4"
    elif /sbin/busybox [ "`grep LMK5 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=14336;ADJ14=17408;ADJ15=22528;
        echo "LMK: using preset #5"
    elif /sbin/busybox [ "`grep LMK6 /system/etc/$CONFFILE`" ]; then
        ADJ0=2048;ADJ1=4096;ADJ2=11776;ADJ7=15872;ADJ14=18944;ADJ15=24576;
        echo "LMK: using preset #6"
    else
        ADJ0=1536;ADJ1=2304;ADJ2=3328;ADJ7=12288;ADJ14=15360;ADJ15=17920;
        echo "LMK: no matching preset found, using default preset #0"
    fi
fi
echo "LMK: after preset parsing (pages): $ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15"
echo "LMK: after preset parsing (Mb): $(($ADJ0/256)),$(($ADJ1/256)),$(($ADJ2/256)),$(($ADJ7/256)),$(($ADJ14/256)),$(($ADJ15/256))"

set_manual_lmk() {
    SLOT=$1
    ORIGVAL=$2
    lmkval=0; 
    CF="midnight_lmk_$SLOT.conf"
    if /sbin/busybox [ -f /system/etc/$CF ];then
        if /sbin/busybox [ "`grep 001$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+1));fi
        if /sbin/busybox [ "`grep 002$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+2));fi
        if /sbin/busybox [ "`grep 003$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+3));fi
        if /sbin/busybox [ "`grep 004$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+4));fi
        if /sbin/busybox [ "`grep 005$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+5));fi
        if /sbin/busybox [ "`grep 006$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+6));fi
        if /sbin/busybox [ "`grep 007$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+7));fi
        if /sbin/busybox [ "`grep 008$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+8));fi
        if /sbin/busybox [ "`grep 009$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+9));fi
        if /sbin/busybox [ "`grep 010$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+10));fi
        if /sbin/busybox [ "`grep 020$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+20));fi
        if /sbin/busybox [ "`grep 030$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+30));fi
        if /sbin/busybox [ "`grep 040$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+40));fi
        if /sbin/busybox [ "`grep 050$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+50));fi
        if /sbin/busybox [ "`grep 060$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+60));fi
        if /sbin/busybox [ "`grep 070$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+70));fi
        if /sbin/busybox [ "`grep 080$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+80));fi
        if /sbin/busybox [ "`grep 090$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+90));fi
        if /sbin/busybox [ "`grep 100$ /system/etc/$CF`" ]; then lmkval=$(($lmkval+100));fi
        echo "LMK: Manual lmk $SLOT Mb: $lmkval"
        lmkval=$(($lmkval*1000/4*1024/1000))
        echo "LMK: Calculated manual lmk $SLOT: $lmkval"
        echo "LMK: Original lmk $SLOT: $ORIGVAL"
        if /sbin/busybox [ "`grep NOOVERRIDE$ /system/etc/$CF`" ]; then 
            echo "LMK: Not overriding preset, returning $ORIGVAL...";
            RETURNVAL=$ORIGVAL
            return $ORIGVAL
        fi
        echo "LMK: Overriding preset, returning $lmkval"
        RETURNVAL=$lmkval
        return $lmkval
    
    fi
    echo "LMK: No manual setting for $SLOT, returning $ORIGVAL..."
    RETURNVAL=$ORIGVAL
    return "$ORIGVAL"
}    

set_manual_lmk "slot1" $ADJ0; ADJ0=$RETURNVAL 
set_manual_lmk "slot2" $ADJ1; ADJ1=$RETURNVAL
set_manual_lmk "slot3" $ADJ2; ADJ2=$RETURNVAL
set_manual_lmk "slot4" $ADJ7; ADJ7=$RETURNVAL
set_manual_lmk "slot5" $ADJ14; ADJ14=$RETURNVAL
set_manual_lmk "slot6" $ADJ15; ADJ15=$RETURNVAL

echo "LMK: after manual parsing (pages): $ADJ0,$ADJ1,$ADJ2,$ADJ7,$ADJ14,$ADJ15"
echo "LMK: after manual parsing (Mb): $(($ADJ0/256)),$(($ADJ1/256)),$(($ADJ2/256)),$(($ADJ7/256)),$(($ADJ14/256)),$(($ADJ15/256))"

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
