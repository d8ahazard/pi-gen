#!/bin/bash -e
install -m 644 files/comitup.conf ${ROOTFS_DIR}/etc/comitup.conf
# id -u glimmrtv &>/dev/null || useradd -m glimmrtv
# usermod -aG sudo glimmrtv 
cd ${ROOTFS_DIR}/home/glimmrtv
# Check dotnet installation
wget https://dotnetcli.blob.core.windows.net/dotnet/Sdk/master/dotnet-sdk-latest-linux-arm.tar.gz
sudo mkdir -p ${ROOTFS_DIR}/usr/share/dotnet
sudo tar -zxf dotnet-sdk-latest-linux-arm.tar.gz -C ${ROOTFS_DIR}/usr/share/dotnet
sudo ln -s ${ROOTFS_DIR}/usr/share/dotnet/dotnet ${ROOTFS_DIR}/usr/bin/dotnet
rm -rf ${ROOTFS_DIR}/dotnet-sdk-latest-linux-arm.tar.gz

