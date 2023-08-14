
# RPi-Video-Sync-Looper

##  The shoulders of Giants

* [omxplayer-sync](https://github.com/turingmachine/omxplayer-sync) (Simon Josi)
* [RPi_SyncLooper](https://github.com/HsienYu/RPi_SyncLooper) (HsienYu Cheng)
* [pi_video_looper](https://github.com/adafruit/pi_video_looper.git) (Christian Sievers)
	* [Raspberry Pi Video Looper](https://videolooper.de/)
	* [Raspberry Pi Video Looper](https://learn.adafruit.com/raspberry-pi-video-looper?view=all) (adafruit)


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

