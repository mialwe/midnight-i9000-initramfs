CONFFILE="midnight_misc.conf"
if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
    if /sbin/busybox [ "`grep NOTWEAKS /system/etc/$CONFFILE`" ]; then
        echo "Midnight tweaks disabled, nothing to do."
        exit
    else
        echo "IO: Setting sdcard READ_AHEAD..."
        echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
        echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb

        CONFFILE="midnight_rh.conf"
        if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
            if /sbin/busybox [ "`grep READAHEAD_4096 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 4096kB..."
              echo "4096" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "4096" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_3064 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 3064kB..."
              echo "3064" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "3064" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_2048 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 2048kB..."
              echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "2048" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
              echo "IO: setting READ_AHEAD value 1024kB..."
            elif /sbin/busybox [ "`grep READAHEAD_1024 /system/etc/$CONFFILE`" ]; then
              echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "1024" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_512 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 512kB..."
              echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_256 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 256kB..."
              echo "256" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "256" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_128 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 128kB..."
              echo "128" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "128" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            elif /sbin/busybox [ "`grep READAHEAD_64 /system/etc/$CONFFILE`" ]; then
              echo "IO: setting READ_AHEAD value 64kB..."
              echo "64" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "64" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            else
              echo "IO: setting READ_AHEAD value 512kB..."
              echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
              echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb
            fi
        fi

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
               
        # IO scheduler 
        echo "IO: setting IO scheduler..."
        CONFFILE="midnight_io_sched.conf"
        SCHEDULER="noop"
        if /sbin/busybox [ -f /system/etc/$CONFFILE ];then
            if /sbin/busybox [ "`grep IO_SCHED_NOOP /system/etc/$CONFFILE`" ]; then
                SCHEDULER="noop"
            elif /sbin/busybox [ "`grep IO_SCHED_VR /system/etc/$CONFFILE`" ]; then
                SCHEDULER="vr"
            elif /sbin/busybox [ "`grep IO_SCHED_CFQ /system/etc/$CONFFILE`" ]; then
                SCHEDULER="cfq"
            elif /sbin/busybox [ "`grep IO_SCHED_DEADLINE /system/etc/$CONFFILE`" ]; then
                SCHEDULER="deadline"
            elif /sbin/busybox [ "`grep IO_SCHED_SIO /system/etc/$CONFFILE`" ]; then
                SCHEDULER="sio"
            fi
            echo "IO: scheduler config file found, setting [$SCHEDULER]..."
        else
            echo "IO: scheduler config file not found, using kernel default scheduler..."
        fi

        STL=`ls -d /sys/block/stl*`;
        BML=`ls -d /sys/block/bml*`;
        MMC=`ls -d /sys/block/mmc*`;
        TFSR=`ls -d /sys/block/tfsr*`;

        echo "IO: Applying IO scheduler settings";
        for i in $STL $BML $MMC $TFSR; do 
            echo "$SCHEDULER" > "$i"/queue/scheduler;
        done;

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
    fi
fi
