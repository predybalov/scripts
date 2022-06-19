#! /usr/bin/env bash

# Usage
if [ $# -eq 0 ]
then
  echo "Usage: ${0} SERVER_NAME USER1_NAME [USER2_NAME] ... [USERn_NAME]"
  exit 1
fi

ip_address=$(curl ip.me)

# Set path to wireguard
wg="/etc/wireguard"

# Update repos & install wireguard
apt-get update && sudo apt-get install -y wireguard
chmod 755 $wg

# Generate keys
for user in $@
do
wg genkey | tee ${wg}/${user} | wg pubkey | tee ${wg}/${user}.pub
done

# Turn on packets forwarding
is_forward=$(sysctl -a 2> /dev/null | grep "net.ipv4.ip_forward = " | awk '{print $NF}')

if [ 0 -eq  $is_forward ]
then
  echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
  sysctl -p
fi


# Configure wireguard server
touch ${wg}/wg0.conf
server_name=$1
shift

interface_name=$(ip a |grep BROADCAST |awk '{print $2}' |tr -d :)

cat << EOF > ${wg}/wg0.conf
[Interface]
PrivateKey = $(cat ${wg}/$server_name)
Address = 10.0.0.1/24
ListenPort = 55555
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface_name -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface_name -j MASQUERADE

EOF

# Configure peers and user files
counter=2

for peer in $@
do
  cat << EOF >> ${wg}/wg0.conf
[Peer]
PublicKey = $(cat ${wg}/${peer}.pub)
AllowedIPs = 10.0.0.${counter}/32

EOF

  cat << EOF > ${wg}/${peer}.conf
[Interface]
PrivateKey = $(cat ${wg}/${peer})
Address = 10.0.0.${counter}/24
DNS = 8.8.8.8

[Peer]
PublicKey = $(cat ${wg}/${server_name}.pub)
AllowedIPs = 0.0.0.0/0
Endpoint = ${ip_address}:55555
EOF

  counter=$(( counter + 1 ))
done

# Enable and start wireguard service
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
