#!/bin/bash
if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

cp -a playvideos.sh /home/pi/playvideos.sh
cp -a configfile.txt /boot/configfile.txt
cp -a ssh /boot/ssh
cp -a wpa_supplicant.conf /boot/wpa_supplicant.conf
cp /etc/dhcpcd.conf /boot/dhcpcd.conf
mv /etc/dhcpcd.conf /etc/dhcpcd.conf.backup
ln -s /boot/dhcpcd.conf /etc/dhcpcd.conf
chmod +x /home/pi/playvideos.sh
apt-get install libpcre3 fonts-freefont-ttf fbset libssh-4 python3-dbus exfat-fuse exfat-utils
apt-get update
apt-get -f install
wget -O /usr/bin/omxplayer-sync https://github.com/HsienYu/omxplayer-sync/raw/master/omxplayer-sync
chmod 0755 /usr/bin/omxplayer-sync
mkdir /media/USB
chmod a+r /media/USB
echo "/dev/sda1	/media/USB	exfat	defaults	0	2" >> /etc/fstab
sed -i -e '$i \setterm -blank 1\n' /etc/rc.local
sed -i -e '$i \sudo /home/pi/playvideos.sh &\n' /etc/rc.local

exit 0

echo "enjoy!" 
