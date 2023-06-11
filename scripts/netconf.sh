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

reboot
