apt update && apt upgrade -y && apt autoremove -y

cat << EOF >> /root/.bashrc
alias wasd='clear'
alias update='apt update && apt upgrade -y && apt autoremove -y'
alias ll='ls -la'
EOF

cat << EOF >> /etc/environment
LANG="de_DE.utf-8"
LC_ALL="de_DE.utf-8"
LC_CTYPE="de_DE.UTF-8"
EOF

localedef -i de_DE -f UTF-8 de_DE.UTF-8

apt install neovim btop -y

apt install caddy -y

cat << EOF >> /etc/caddy/Caddyfile
DOMAIN.rz-mgns.de {
        reverse_proxy IP-ADRESS:PORT
}
EOF

apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst bridge-utils cloud-image-utils ovmf -y

virsh net-start default
virsh net-autostart default

mkdir /root/VM
mkdir /root/VM/test-01
mkdir /root/VM/docker-01

reboot