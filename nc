#!/bin/bash

sed -i -e 's/dhcp4: yes/dhcp4: no/' /etc/netplan/01-netcfg.yaml

sed -i -e '8a\      addresses: [91.221.70.147/23]'  /etc/netplan/01-netcfg.yaml
sed -i -e '9a\      gateway4: 91.221.70.1'  /etc/netplan/01-netcfg.yaml
sed -i -e '10a\      nameservers:'  /etc/netplan/01-netcfg.yaml
sed -i -e '11a\        addresses: [91.221.70.1, 91.221.71.1]'  /etc/netplan/01-netcfg.yaml

netplan --debug generate
netplan --debug apply

systemctl start sshd

ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow ssh
ufw allow 22
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 10000/udp
ufw allow 5349/tcp
ufw enable

apt-get -y -q install apt-transport-https curl

iptables -I INPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
iptables -I INPUT -p tcp --dport 10000 -j ACCEPT
iptables -I INPUT -p tcp --dport 5349 -j ACCEPT

DEBIAN_FRONTEND=noninteractive apt-get  -y -q install iptables-persistent
apt-get -y -q install curl
netfilter-persistent save

#apt-get -y -q install prosody
#apt-get -y -q remove prosody

hostnamectl set-hostname media3.nbics.net

echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -
apt -y -q install lua5.2
curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
apt update
apt-get -y -q install jitsi-meet
apt-get -y -q install socat certbot
/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
apt-get -y -q install liblua5.1-0-dev liblua5.2-dev liblua50-dev
apt-get -y install libunbound-dev
luarocks install luaunbound
chmod a+x /etc/jitsi/jicofo/

sed -i -e 's/authentication = "jitsi-anonymous" -- do not delete me/authentication = "internal_hashed" -- do not delete me/' /etc/prosody/conf.avail/media3.nbics.net.cfg.lua
echo 'VirtualHost "guest.media3.nbics.net"' >> /etc/prosody/conf.avail/media3.nbics.net.cfg.lua
echo '    authentication = "anonymous"' >> /etc/prosody/conf.avail/media3.nbics.net.cfg.lua
echo '    c2s_require_encryption = false' >> /etc/prosody/conf.avail/media3.nbics.net.cfg.lua
sed -i -e "s/domain: 'media3.nbics.net',/domain: 'media3.nbics.net',anonymousdomain: 'guest.media3.nbics.net',/" /etc/jitsi/meet/media3.nbics.net-config.js
sed -i -e '16a\  authentication: { '  /etc/jitsi/jicofo/jicofo.conf
sed -i -e '17a\    enabled: true'  /etc/jitsi/jicofo/jicofo.conf
sed -i -e '18a\    type: XMPP'  /etc/jitsi/jicofo/jicofo.conf
sed -i -e '19a\    login-url: media3.nbics.net'  /etc/jitsi/jicofo/jicofo.conf
sed -i -e '20a\  }'  /etc/jitsi/jicofo/jicofo.conf

prosodyctl register oleg media3.nbics.net Kondratenko2357

reboot
