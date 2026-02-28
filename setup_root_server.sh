apt update && apt upgrade -y && apt autoremove -y

cat << EOF >> /root/.bashrc
alias wasd='clear'
alias update='apt update && apt upgrade -y && apt autoremove -y'
EOF

cat << EOF >> /etc/network/interfaces

#interface for virtual machines

auto vmbr0
iface vmbr0 inet static
    address 10.0.10.254/25
    bridge-ports none
    bridge-stp off
    bridge-fd 0
EOF

systemctl restart networking

cat << EOF >> /etc/environment
LANG="de_DE.utf-8"
LC_ALL="de_DE.utf-8"
LC_CTYPE="de_DE.UTF-8"
EOF

localedef -i de_DE -f UTF-8 de_DE.UTF-8

apt install neovim btop nftables

waniface=""
laniface="vmbr0"

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
        iif $laniface tcp dport 22 accept
        iif $waniface tcp dport 22 accept

        # allow ping
        ip protocol icmp accept
    }

    chain forward {
        type filter hook forward priority 0;
        policy drop;

        # lan to wan
        iif $laniface oif $waniface accept

        # wan to lan for established connections
        iif $waniface oif $laniface ct state established,related accept
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
systemctl restart nftables
