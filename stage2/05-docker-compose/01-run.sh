#!/bin/bash -e

# Install docker via pip3 (within chroot)
echo "Installing docker-compose from pip3, and also setting up the box folder structure"

on_chroot << EOF
pip3 install docker-compose
cd /home/${FIRST_USER_NAME}
wget -qO- "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/install-box.sh" | sh
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

# Maybe generate docker-compose file so we can use it
chmod 755 files/compose-service

# Docker compose service
on_chroot << EOF
mkdir -p /etc/init.d
mkdir -p /etc/rc2.d
mkdir -p /etc/rc3.d
mkdir -p /etc/rc4.d
mkdir -p /etc/rc5.d
mkdir -p /etc/rc0.d
mkdir -p /etc/rc1.d
mkdir -p /etc/rc6.d
EOF

echo "Copying the compose service to rootfs (etc/init.d)"
cp files/compose-service ${ROOTFS_DIR}/etc/init.d/umbrelbox


echo "Docker stuff installed!"

echo "Bundling Docker images required to run Umbrel services"
apt-get update
apt-get install golang-go
go version
wget -q "https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh"
wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq | tr \\n " ")
echo "List of images to download: $IMAGES"
chmod +x ./download-frozen-image-v2.sh
./download-frozen-image-v2.sh docker-images "${IMAGES//\"}"

mkdir ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/images
cp -avr docker-images/ ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/images