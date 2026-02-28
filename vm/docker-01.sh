mkdir -p /var/lib/libvirt/images/docker-01
wget -O /var/lib/libvirt/images/docker-01/debian-13.qcow2 https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
cloud-localds seed.iso user-data meta-data
cp /root/VM/docker-01/seed.iso /var/lib/libvirt/images/docker-01/
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/docker-01/seed.iso
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/docker-01/debian-13.qcow2
chmod 644 /var/lib/libvirt/images/docker-01/seed.iso
chmod 644 /var/lib/libvirt/images/docker-01/debian-13.qcow2

qemu-img resize /var/lib/libvirt/images/docker-01/debian-13.qcow2 40G

VM_NAME="docker-01"
MEMORY=8192
VCPUS=4
DISK_IMAGE="/var/lib/libvirt/images/${VM_NAME}/debian-13.qcow2"
CLOUD_INIT_ISO="/var/lib/libvirt/images/${VM_NAME}/seed.iso"
OS_VARIANT="debian13"
NETWORK="default"

virt-install \
  --name "$VM_NAME" \
  --memory "$MEMORY" \
  --vcpus "$VCPUS" \
  --disk "$DISK_IMAGE",format=qcow2,bus=virtio \
  --disk "$CLOUD_INIT_ISO",device=cdrom \
  --os-variant "$OS_VARIANT" \
  --network network="$NETWORK",model=virtio \
  --graphics none \
  --console pty,target_type=serial \
  --import \
  --boot uefi