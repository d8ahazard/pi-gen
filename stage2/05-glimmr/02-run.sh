#!/bin/bash -e
rm -rf ${ROOTFS_DIR}/home/glimmrtv/ws281x
git clone https://github.com/jgarff/rpi_ws281x ${ROOTFS_DIR}/home/glimmrtv/ws281x
cd ${ROOTFS_DIR}/home/glimmrtv/ws281x
apt-get -y install scons
scons
gcc -shared -o ws2811.so *.o
cp ./ws2811.so ${ROOTFS_DIR}/usr/lib/ws2811.so
rm -rf ${ROOTFS_DIR}/home/glimmrtv/glimmr
git clone -b dev https://github.com/d8ahazard/glimmr ${ROOTFS_DIR}/home/glimmrtv/glimmr
# Install update script to init.d 
sudo chmod 777 ${ROOTFS_DIR}/home/glimmrtv/glimmr/update_pi.sh
sudo ln -sf ${ROOTFS_DIR}/home/glimmrtv/glimmr/update_pi.sh ${ROOTFS_DIR}/etc/init.d/update_glimmr.sh
cd ${ROOTFS_DIR}/home/glimmrtv/glimmr
dotnet publish ./src/Glimmr.csproj /p:PublishProfile=LinuxARM -o ${ROOTFS_DIR}/bin/
cp -r ${ROOTFS_DIR}/home/glimmrtv/glimmr/lib/bass.dll ${ROOTFS_DIR}/usr/lib/bass.dll
cp -r ${ROOTFS_DIR}/home/glimmrtv/glimmr/lib/arm/* ${ROOTFS_DIR}/usr/lib
# Install service
cd /tmp
sudo crontab -l > mycron
#echo new cron into cron file
echo "00 01 * * * /etc/init.d/update_pi.sh" >> mycron
#install new cron file
crontab mycron
rm mycron
echo "
[Unit]
Description=GlimmrTV

[Service]
Type=simple
RemainAfterExit=yes
StandardOutput=tty
Restart=always
User=root
WorkingDirectory=/home/glimmrtv/glimmr/bin
ExecStart=/home/glimmrtv/glimmr/bin/Glimmr


[Install]
WantedBy=multi-user.target

" > ${ROOTFS_DIR}/etc/systemd/system/glimmr.service
sudo ln -sf ${ROOTFS_DIR}/etc/systemd/glimmr.service ${ROOTFS_DIR}/etc/systemd/multi-user.target.wants/glimmr.service

git clone -b dev https://github.com/davesteele/comitup ${ROOTFS_DIR}/home/glimmrtv/comitup
cp -r ${ROOTFS_DIR}/home/glimmrtv/comitup/comitup/*.py ${ROOTFS_DIR}/usr/share/comitup/comitup/