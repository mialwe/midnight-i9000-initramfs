#if /sbin/ext/busybox [ ! -f /system/cfroot/release-82-JVT-s1- ]; 
#then
echo "Remounting /system for rooting..."
/sbin/ext/busybox mount -o remount,rw /system

# create xbin
if [ -d /system/xbin ];then
    echo "/system/xbin found, skipping mkdir..."
else
    echo "/system/xbin not found, creating..."
    mkdir /system/xbin
    chmod 755 /system/xbin
fi

# create init.d
if [ -d /system/etc/init.d ];then
    echo "/system/etc/init.d found, skipping mkdir..."
else
    echo "/system/etc/init.d not found, creating..."
    mkdir /system/etc/init.d
    chmod 777 /system/etc/init.d
fi

# clean multiple su binaries
echo "Cleaning su installations except /system/xbin/su if any..."
rm -f /system/bin/su
rm -f /vendor/bin/su
rm -f /system/sbin/su

# install xbin/su if not there
if [ -f /system/xbin/su ];then
    echo "/system/xbin/su found, skipping..."
else
    echo "Cleaning up su installations..."
    echo "Installing /system/xbin/su..."
    echo "If this fails free some space on /system."
    cat /res/misc/su > /system/xbin/su
    chown 0.0 /system/xbin/su
    chmod 4755 /system/xbin/su
fi

# install /system/app/Superuser.apk if not there
if [ -f /system/app/Superuser.apk ];then
    echo "/system/app/Superuser.apk found, skipping..."
else
    echo "Cleaning up Superuser.apk installations..."
    rm -f /system/app/Superuser.apk
    rm -f /data/app/Superuser.apk
    echo "Installing /system/app/Superuser.apk"
    echo "If this fails free some space on /system."
    cat /res/misc/Superuser.apk > /system/app/Superuser.apk
    chown 0.0 /system/app/Superuser.apk
    chmod 644 /system/app/Superuser.apk
fi

# Install CWMManager if not there
if [ -f /system/app/CWMManager.apk ];then
    echo "/system/app/CWMManager.apk found, skipping..."
else
    echo "Cleaning old CWMManager files if any..."
    rm -f /system/app/CWMManager.apk
    rm -f /data/dalvik-cache/*CWMManager.apk*
    rm -f /data/app/eu.chainfire.cfroot.cwmmanager*.apk
    echo "Installing /system/app/CWMManager.apk..."
    echo "If this does not work free some space on /system."
    cat /res/misc/CWMManager.apk > /system/app/CWMManager.apk
    chown 0.0 /system/app/CWMManager.apk
    chmod 644 /system/app/CWMManager.apk
fi

# Housekeeping...
echo "Cleaning old CF-files if any..."
rm -f /system/app/CWMReboot.apk
rm -f /data/dalvik-cache/*CWMReboot.apk*
rm -f /data/app/eu.chainfire.cfroot.cwmreboot*.apk
if [ -d /system/cfroot ];then
    echo "Removing /system/cfroot as we are using Midnight kernel..."
    rm -rf /system/cfroot
fi

echo "Remounting /system readonly..."
/sbin/ext/busybox mount -o remount,ro /system
