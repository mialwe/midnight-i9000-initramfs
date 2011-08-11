#!/sbin/busybox sh

/sbin/busybox insmod /lib/modules/fsr.ko
/sbin/busybox insmod /lib/modules/fsr_stl.ko
/sbin/busybox insmod /lib/modules/rfs_glue.ko
/sbin/busybox insmod /lib/modules/rfs_fat.ko

/sbin/busybox mkdir /dev
/sbin/busybox mkdir /dev/block
/sbin/busybox mkdir /dev/snd

/sbin/busybox ln -s /system/etc /etc

/sbin/busybox mknod /dev/null c 1 3
/sbin/busybox mknod /dev/zero c 1 5

# internal and external sd card
/sbin/busybox mknod /dev/block/mmcblk0 b 179 0
/sbin/busybox mknod /dev/block/mmcblk0p1 b 179 1
/sbin/busybox mknod /dev/block/mmcblk0p2 b 179 2

/sbin/busybox mknod /dev/block/mmcblk1 b 179 8
/sbin/busybox mknod /dev/block/mmcblk1p1 b 179 9
# ROM blocks
/sbin/busybox mknod /dev/block/stl1 b 138 1
/sbin/busybox mknod /dev/block/stl2 b 138 2
/sbin/busybox mknod /dev/block/stl3 b 138 3
/sbin/busybox mknod /dev/block/stl4 b 138 4
/sbin/busybox mknod /dev/block/stl5 b 138 5
/sbin/busybox mknod /dev/block/stl6 b 138 6
/sbin/busybox mknod /dev/block/stl7 b 138 7
/sbin/busybox mknod /dev/block/stl8 b 138 8
/sbin/busybox mknod /dev/block/stl9 b 138 9
/sbin/busybox mknod /dev/block/stl10 b 138 10
/sbin/busybox mknod /dev/block/stl11 b 138 11
/sbin/busybox mknod /dev/block/stl12 b 138 12

# framebuffer for the graphsh command if needed
/sbin/busybox mkdir /dev/graphics
/sbin/busybox mknod /dev/graphics/fb0 c 29 0
/sbin/busybox mknod /dev/graphics/fb1 c 29 1
/sbin/busybox mknod /dev/graphics/fb2 c 29 2
/sbin/busybox mknod /dev/graphics/fb3 c 29 3
/sbin/busybox mknod /dev/graphics/fb4 c 29 4
# input
/sbin/busybox mkdir /dev/input
/sbin/busybox mknod /dev/input/event0 c 13 64
/sbin/busybox mknod /dev/input/event1 c 13 65
/sbin/busybox mknod /dev/input/event2 c 13 66
/sbin/busybox mknod /dev/input/event3 c 13 67
/sbin/busybox mknod /dev/input/event4 c 13 68
/sbin/busybox mknod /dev/input/event5 c 13 69
/sbin/busybox mknod /dev/input/event6 c 13 70
/sbin/busybox mknod /dev/input/event7 c 13 71
/sbin/busybox mknod /dev/input/event8 c 13 72
/sbin/busybox mknod /dev/input/mice c 13 63
/sbin/busybox mknod /dev/input/mouse0 c 13 32

# mount and check /system. Some modules are needed from /system/lib
echo Mounting /system

# first try it as rfs
/sbin/busybox mount -t rfs -o check=no /dev/block/stl9 /system
# then try it as ext4
/sbin/busybox mount -t ext4 -o noatime,data=ordered,nodelalloc,commit=20 /dev/block/stl9 /system

# for SYSTEM conversion
if /sbin/busybox [ -f "/system/etc/lagfixsystem.conf" ]; then

	# required for CWM to work
	/sbin/busybox ln -s /sbin/busybox /sbin/sh
	/sbin/busybox cp /res/misc/mke2fs.conf /etc/

  #echo Going to convert /system
  /sbin/busybox rm -f /system/etc/lagfixsystem.conf

  /sbin/busybox ln -s /sbin/recovery /sbin/lagfixer
  /sbin/busybox ln -s /sbin/recovery /sbin/graphchoice
  /sbin/busybox ln -s /sbin/recovery /sbin/reboot
  
  #echo "Starting choice app"
  /sbin/graphchoice "SYSTEM conversion requested. Convert /system?" "EXT4: Convert to EXT4" "RFS: Convert to RFS" "NO: Abort conversion"
  SYSRESULT=$?
  if /sbin/busybox [ $SYSRESULT == "0" ]; then
	SYSLFOPTS=sysext4
  elif /sbin/busybox [ $SYSRESULT == "1" ]; then
    SYSLFOPTS=sysrfs
  fi
  if /sbin/busybox [ $SYSRESULT != "2" ]; then
    /sbin/lagfixer $SYSLFOPTS > /res/lagfix.log 2>&1
    /sbin/busybox sleep 5
    /sbin/busybox cp /res/lagfix.log /mnt/sdcard/
  fi
  /sbin/reboot -f
fi

