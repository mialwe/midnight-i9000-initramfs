/sbin/busybox mount -t rootfs -o remount,rw rootfs 
/sbin/busybox mkdir -p /customkernel/property 
echo true >> /customkernel/property/customkernel.cf-root 
echo true >> /customkernel/property/customkernel.base.cf-root 
echo Midnight >> /customkernel/property/customkernel.name 
echo "Midnight 0.7.9" >> /customkernel/property/customkernel.namedisplay 
echo 35 >> /customkernel/property/customkernel.version.number 
echo "DIVA" >> /customkernel/property/customkernel.version.name 
echo true >> /customkernel/property/customkernel.bootani.zip 
echo true >> /customkernel/property/customkernel.bootani.bin 
echo true >> /customkernel/property/customkernel.cwm 
echo 4.0.1.4 >> /customkernel/property/customkernel.cwm.version 
echo true >> /customkernel/property/customkernel.fs.rfs 
echo true >> /customkernel/property/customkernel.fs.ext4 
echo true >> /customkernel/property/customkernel.fs.ext4.sd.int 
echo true >> /customkernel/property/customkernel.fs.ext4.sd.ext 
/sbin/busybox mount -t rootfs -o remount,ro rootfs 
