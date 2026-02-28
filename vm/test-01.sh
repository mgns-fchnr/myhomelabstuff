mkdir -p /var/lib/libvirt/images/test-01
cp /root/VM/test-01/seed.iso /var/lib/libvirt/images/test-01/
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/test-01/seed.iso
chmod 644 /var/lib/libvirt/images/test-01/seed.iso

virt-install \
--name test-01 \
--memory 1024 \
--vcpus 1 \
--disk /var/lib/libvirt/images/test-01.qcow2,format=qcow2,size=10 \
--disk /var/lib/libvirt/images/test-01/seed.iso,device=cdrom \
--os-variant debian13 \
--network network=default \
--graphics none \
--import