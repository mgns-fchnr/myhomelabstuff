virt-install \
--name test-01 \
--memory 1024 \
--vcpus 1 \
--disk /var/lib/libvirt/images/test-01.qcow2,format=qcow2,size=10 \
--disk seed.iso,device=cdrom \
--os-variant debian13 \
--network network=default \
--graphics none \
--import