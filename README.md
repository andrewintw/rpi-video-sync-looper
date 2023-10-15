
# RPi-Video-Sync-Looper

## Install

```
curl -LJs https://raw.githubusercontent.com/andrewintw/rpi-video-sync-looper/main/install.sh | sudo bash
```

##  The shoulders of Giants

* [omxplayer-sync](https://github.com/turingmachine/omxplayer-sync) (Simon Josi)
* [RPi_SyncLooper](https://github.com/HsienYu/RPi_SyncLooper) (HsienYu Cheng)
* [pi_video_looper](https://github.com/adafruit/pi_video_looper.git) (Christian Sievers)
	* [Raspberry Pi Video Looper](https://videolooper.de/)
	* [Raspberry Pi Video Looper](https://learn.adafruit.com/raspberry-pi-video-looper?view=all) (adafruit)
* [MP4MUSEUM](https://mp4museum.org/) (Julius Schmiedel)
	* [GitHub](https://github.com/JuliusCode/MP4MUSEUM)
* [Lūpa](https://lupaplayer.com/)
* [BrightSign](https://support.brightsign.biz/hc/en-us)


## The config.txt file

### hdmi_force_hotplug=1

### config_hdmi_boost

* The minimum value is 0 and the maximum is 11.
* The default value for the original Model B and A is 2.
* The default value for the Model B+ and all later models is 5.
* If you are seeing HDMI issues (speckling, interference) then try 7.
* Very long HDMI cables may need up to 11

### hdmi_group

* 0 | Auto-detect from EDID
* 1 | CEA
* 2 | DMT


```
$ apt-get install libraspberrypi-bin
$ tvservice --modes CEA
$ tvservice --modes DMT
$ tvservice --status
```


### hdmi_mode

* if hdmi_group=1 (CEA):
	* 16 | 1080p | 60Hz | 16:9
	* 31 | 1080p | 50Hz | 16:9
	* 32 | 1080p | 24Hz | 16:9
	* 33 | 1080p | 25Hz | 16:9
	* 34 | 1080p | 30Hz | 16:9
* if hdmi_group=2 (DMT):
	* 82 | 1080p | 60Hz | 16:9


## Static IP Addresses

/etc/dhcpcd.conf

```
interface eth0
static ip_address=192.168.0.4/24
static routers=192.168.0.254
static domain_name_servers=192.168.0.254 8.8.8.8
```


### Configuration

* in /boot/config.txt
	* `hdmi_force_hotplug=1`
	* `hdmi_drive=2`
* in /boot/cmdline.txt
	* `consoleblank=0`
