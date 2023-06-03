sed -i -e "s/UMBREL_OS=<version>/UMBREL_OS=$SCHIRM_OS_VERSION/g" files/umbrel
install -m 644 files/umbrel "${ROOTFS_DIR}"/etc/default/umbrel

sed -i -e "s/SCHIRM_OS=<version>/SCHIRM_OS=$SCHIRM_OS_VERSION/g" files/schirm
install -m 644 files/schirm "${ROOTFS_DIR}"/etc/default/schirm
