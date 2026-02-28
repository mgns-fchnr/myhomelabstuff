apt update && apt upgrade -y && apt autoremove -y

cat << EOF >> /root/.bashrc
alias wasd='clear'
alias update='apt update && apt upgrade -y && apt autoremove -y'
EOF

#cat << EOF >> /etc/network/interfaces
#
#auto vmbr0
#iface vmbr0 inet static
#  address 10.0.10.254/24
#  bridge_ports none
#  bridge_stp off
#  bridge_fd 0
#  pre-up ip link set vmbr0 up
#EOF

#systemctl restart networking

cat << EOF >> /etc/environment
LANG="de_DE.utf-8"
LC_ALL="de_DE.utf-8"
LC_CTYPE="de_DE.UTF-8"
EOF

localedef -i de_DE -f UTF-8 de_DE.UTF-8

apt install neovim btop nftables -y

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

echo "export PATH=$PATH:/usr/sbin" >> /root/.bashrc

/usr/sbin/sysctl -p

waniface='"eno1"'
#laniface='"vmbr0"'

cat << EOF >> /etc/nftables.conf
flush ruleset

table inet filter {

    chain input {
        type filter hook input priority 0;
        policy drop;

        # loopback
        iif lo accept

        # established connections
        ct state established,related accept

        # allow ssh from lan and wan
        iif $waniface tcp dport 22 accept

        # allow http and https from wan
        iif $waniface tcp dport 80 accept
        iif $waniface tcp dport 443 accept

        # allow ping
        ip protocol icmp accept
    }

    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }

    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}

table ip nat {

    chain postrouting {
        type nat hook postrouting priority 100;

        # NAT for wan
        oif $waniface masquerade
    }
}
EOF

systemctl enable nftables
systemctl start nftables

apt install caddy -y

cat << EOF >> /etc/caddy/Caddyfile
DOMAIN.rz-mgns.de {
        reverse_proxy IP-ADRESS:PORT
}
EOF

apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst bridge-utils cloud-image-utils -y

reboot