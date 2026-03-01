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

apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mkdir /root/DOCKER

cd /root/DOCKER

apt install cifs-utils

touch /root/.sbox-01
echo 'user=u469650' >> /root/.sbox-01
echo 'password=PASSWORD' >> /root/.sbox-01

mkdir /mnt/sbox-01
echo '//u469650.your-storagebox.de/backup /mnt/sbox-01 cifs credentials=/root/.sbox-01,iocharset=utf8' >> /etc/fstab

systemctl daemon-reload
mount -a

reboot