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

curl https://repo.jellyfin.org/install-debuntu.sh | sudo bash

apt install cifs-utils -y

touch /root/.sbox-01
echo 'user=u469650' >> /root/.sbox-01
echo 'password=PASSWORD' >> /root/.sbox-01

mkdir /mnt/sbox-01
echo '//u469650.your-storagebox.de/backup /mnt/sbox-01 cifs credentials=/root/.sbox-01,iocharset=utf8' >> /etc/fstab

reboot