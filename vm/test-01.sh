mkdir -p /var/lib/libvirt/images/test-01
wget -O /var/lib/libvirt/images/test-01/debian-13.qcow2 https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
cloud-localds seed.iso user-data
cp /root/VM/test-01/seed.iso /var/lib/libvirt/images/test-01/
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/test-01/seed.iso
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/test-01/debian-13.qcow2
chmod 644 /var/lib/libvirt/images/test-01/seed.iso
chmod 644 /var/lib/libvirt/images/test-01/debian-13.qcow2

qemu-img resize /var/lib/libvirt/images/test-01/debian-13.qcow2 20G

virt-install \
--name test-01 \
--memory 1024 \
--vcpus 1 \
--disk /var/lib/libvirt/images/test-01/debian-13.qcow2,format=qcow2 \
--disk /var/lib/libvirt/images/test-01/seed.iso,device=cdrom \
--os-variant debian13 \
--network network=default \
--graphics none \
--import