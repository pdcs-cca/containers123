# containers123

~~~bash
#!/bin/bash 


URL=https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-minirootfs-3.22.2-x86_64.tar.gz
ROOTFS="/tmp/ram-container"
EXEC=$1

test $# -eq 0 && EXEC=/bin/sh

setup_container() {
#mkdir -p /tmp/ram-container
#mount -t tmpfs -o size=100M tmpfs /tmp/ram-container

    test ! -d $ROOTFS/oldroot &&  mkdir -p $ROOTFS/oldroot
    test ! -e $ROOTFS/bin/sh && echo curl -L $URL | tar -xzf - -C $ROOTFS
}

exec_container() {
    unshare -m -u -p -i -f --mount-proc bash -c "
        # Montar sistemas virtuales
        mount -t proc proc $ROOTFS/proc
        mount -t sysfs sysfs $ROOTFS/sys
        mount -t tmpfs tmpfs $ROOTFS/tmp
        mount -t devtmpfs devtmpfs $ROOTFS/dev
        
        # Configurar 
        echo '127.0.0.1 localhost' > $ROOTFS/etc/hosts
	echo 'nameserver 1.1.1.1' > $ROOTFS/etc/resolv.conf
        
	# Ejecutar comando 
	cd $ROOTFS
	pivot_root . oldroot
	umount -l /oldroot
	rmdir /oldroot
	ip link set lo up
	#sh256sum 412454ed98025ad9cd910d13f3d448b184e81502baa83180e89f98d0f13674be
	hostname  412454e
	exec chroot . $EXEC
    "
}

# Ejecutar
setup_container
exec_container 
~~~
