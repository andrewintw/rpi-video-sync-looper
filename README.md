
# RPi-Video-Sync-Looper

## Install

2023-05-03-raspios-buster-armhf-lite.img.xz

```
sudo apt update && \
sudo apt install -y omxplayer exfat-fuse exfat-utils python3 psmisc procps libpcre3 fonts-freefont-ttf fbset libssh-4 python3-dbus
```

install for Master (default)

```
curl -LJs https://raw.githubusercontent.com/andrewintw/rpi-video-sync-looper/main/install.sh | sudo bash
```

or

```
curl -LJs https://raw.githubusercontent.com/andrewintw/rpi-video-sync-looper/main/install.sh | sudo bash -s -- master
```

install for Slave
```
curl -LJs https://raw.githubusercontent.com/andrewintw/rpi-video-sync-looper/main/install.sh | sudo bash -s -- slave
```


