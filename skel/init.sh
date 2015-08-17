#!/bin/bash

if [[ ! -d /target ]]; then
cat <<EOF


!#!#!#!#!#!!#!#!#!#!# WARNING !#!#!#!#!#!!#!#!#!#!#
!#  No target directory found. Did you mount it? !#
!#       Directory /target will be created.      !#
!#     Output will not be available on host.     !#
!#!#!#!#!#!!#!#!#!#!# WARNING !#!#!#!#!#!!#!#!#!#!# 


EOF
  mkdir -p /target
fi


cd /usr/share/easy-rsa/
source ./vars
source ./clean-all

cat <<EOF
###############################################
###############################################
########## Executing build-ca script ##########
###############################################
###############################################
EOF

source ./build-ca

cat <<EOF
###############################################
###############################################
###### Executing build-key-server script ######
###############################################
###############################################
EOF

read -p "Please Give the Server certificate a name [default: server]: " sname
sname="${sname:-server}"

source ./build-key-server "$sname"

cat <<EOF
###############################################
###############################################
##### Do you wish to build a client cert? #####
###############################################
###############################################
EOF

read -p "Do you wish to generate any client certs? (y/n) [default: N]:" genclient
genclient="${genclient:-n}"
if [[ "${genclient,,}" == "y" || "${genclient,,}" == "yes" ]]; then
  mkdir -p /target/client-certs
  cp keys/ca.crt /target/client-certs
  while true; do
    read -p "Please give this client certificate a name [default: client]:" clientname
    clientname="${clientname:-client}"
    ./build-key "$clientname"
    cp "keys/$clientname.key" "keys/$clientname.crt" /target/client-certs
    read -p "Generate another client cert? (y/n) [default: N]: " clientbreak
    clientbreak="${clientbreak:-n}"
    if [[ $clientbreak != "y" ]]; then
      break
    fi
  done
fi

cat <<EOF
###############################################
############# Go Get some Coffee. #############
########## Executing build-dh script ##########
############# (Gonna be a few...) #############
###############################################
EOF
source ./build-dh


tar cvzf /target/keys.tar.gz keys
mkdir -p /target/server-certs
cp "keys/$sname.crt" "keys/$sname.key" keys/ca.crt keys/dh2048.pem /target/server-certs
