# init.d support 
CONFFILE="midnight_misc.conf"
if [ -f /system/etc/$CONFFILE ];then
    if /sbin/ext/busybox [ "`grep INIT_D /system/etc/$CONFFILE`" ]; then
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
