#!/bin/bash
F="proxy-admin_linux-amd64.tar.gz"
set -e
if [ -e /tmp/proxy ]; then
    rm -rf /tmp/proxy
fi
mkdir /tmp/proxy
cd /tmp/proxy
echo -e "\n>>> downloading ... $F\n"
set +e
CN=$(wget -O - -t 3 --dns-timeout 1 --connect-timeout 2 --read-timeout 2 myip.ipip.net)
if [ "$CN" != "" ];then
CN=$(echo $CN| grep "中国" |grep -v grep)
fi
set -e
manual=""
if [ -z "$CN" ];then
manual="https://snail007.github.io/goproxy/manual/"
LAST_VERSION=$(curl --silent "https://api.github.com/repos/snail007/proxy_admin_free/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
wget  -t 1 "https://github.com/snail007/proxy_admin_free/releases/download/${LAST_VERSION}/$F"
else
manual="https://snail007.github.io/goproxy/manual/zh/"
wget  -t 1 "http://mirrors.host900.com/snail007/proxy_admin_free/$F"
fi
echo -e ">>> installing ... \n"
#install proxy-admin
tar zxvf $F >/dev/null
tar zxvf $F
chmod +x proxy-admin
./proxy-admin uninstall >/dev/null 2>&1 
./proxy-admin install
rm $F
systemctl status proxyadmin &
sleep 2
echo  -e ">>> install done, thanks for using snail007/proxy-admin\n"
echo  -e ">>> install path /usr/bin/proxy\n"
echo  -e ">>> configuration path /etc/proxy\n"
echo  -e ">>> uninstall just exec : rm /usr/bin/proxy && rm /etc/proxy\n"
echo  -e ">>> please visit : http://YOUR_IP:32080/ username: root, password: 123"
echo  -e ">>> How to using? Please visit : $manual\n"
