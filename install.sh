#! /bin/bash

GIT_REPO_RAW="https://raw.githubusercontent.com/andrewintw/rpi-video-sync-looper/main/rootfs"

install_fstab=0
install_rclocal=0

chk_pkgs() {
	for pkg in omxplayer exfat-fuse exfat-utils python3 psmisc procps libpcre3 fonts-freefont-ttf fbset libssh-4 python3-dbus; do
		dpkg-query -W -f='${Status}' $pkg 1>/dev/null 2>&1
		if [ "$?" != "0" ]; then
			print_msg "ERRO> Please install \"${pkg}\" before run the script!"
			cat << EOF

Requirements:
  omxplayer exfat-fuse exfat-utils python3 psmisc procps libpcre3 fonts-freefont-ttf fbset libssh-4 python3-dbus

EOF
			exit 1
		fi
	done
}

do_init() {
	if [ "$EUID" -ne 0 ]; then
		print_msg "ERRO> Please run as root"
		exit 0
	fi

	mkdir -p /media/USB
	if [ "`grep '/media/USB.*exfat' /etc/fstab | wc -l`" = "0" ]; then
		install_fstab=1
	fi

	if [ "`grep 'setterm --blank 0' /etc/rc.local | wc -l`" = "0" ]; then
		install_rclocal=1
	fi
}

print_msg () {
	local msg="$1"
	echo -e "$msg"
}

_install_file() {
	local path="$1"
	local perm="$2"
	local file="`basename $path`"
	local dl_url="${GIT_REPO_RAW}/${path}"

	curl -LJOs "${GIT_REPO_RAW}/${path}"

	if [ "$perm" != "" ]; then
		chmod "$perm" $file
	else
		chmod 644 $file
	fi

	if [ -f $file ]; then
		print_msg "INSTALL> $file -> $path"
		mv $file $path
	fi
}


install_pkg() {
	# config file
	_install_file "/boot/video-sync.conf"

	# system files
	if [ "$install_fstab" = "1" ]; then
		cp -a /etc/fstab /etc/fstab.BACKUP
		_install_file "/etc/fstab"
	fi

	if [ "$install_rclocal" = "1" ]; then
		cp -a /etc/rc.local /etc/rc.local.BACKUP
		_install_file "/etc/rc.local" "755"
	fi

	_install_file "/home/pi/synctest.mp4"

	_install_file "/usr/bin/omxplayer-sync" "755"


	if [ -f /usr/lib/systemd/system/videoplayer-monitor.timer ]; then
		systemctl stop videoplayer-monitor.timer
		systemctl disable videoplayer-monitor.timer
	fi
	_install_file "/usr/lib/systemd/system/videoplayer-monitor.timer"

	if [ -f /usr/lib/systemd/system/videoplayer-monitor.service ]; then
		systemctl stop videoplayer-monitor.service
		systemctl disable videoplayer-monitor.service
	fi
	_install_file "/usr/lib/systemd/system/videoplayer-monitor.service"

	_install_file "/usr/local/sbin/show_sysinfo.sh"        "755"
	_install_file "/usr/local/sbin/videoplayer-monitor.sh" "755"
	_install_file "/usr/local/sbin/videoplayer.sh"         "755"
}

do_restart() {
	systemctl daemon-reload
	systemctl start videoplayer-monitor.service
	systemctl start videoplayer-monitor.timer
	systemctl enable videoplayer-monitor.timer
}

do_done() {
	cat << EOF

NOTE
----
  Make sure to insert the USB flash drive before powering on, or the system may hang while attempting to mount the flash drive.

SETUP
-----
  1. Format the USB flash drive as exFAT.
  2. Copy 1080p video file (.mp4, .mkv, .m4v, .mov, .avi) to the root directory of the USB flash drive.

CONFIG
------
  - Edit /boot/video-sync.conf
    - For master
      Set video.player.role='master'
    - For slave
      Set video.player.role='slave'

COMMAND
-------
  - Restart player
    $ sudo systemctl restart videoplayer-monitor.service
  - show log
    $ tail -f /var/log/syslog | grep -w -e 'videoplayer:' -e 'player-monitor:'
    $ show_sysinfo.sh

EOF
}

do_main() {
	do_init
	chk_pkgs
	install_pkg
	do_restart
	do_done
}

do_main
