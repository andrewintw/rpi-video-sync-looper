#!/usr/bin/env bash

LOG_TAG="videoplayer"
CONFIG_FILE="/boot/video-sync.conf"

run_mode=''
run_exec=''
run_parms=''

file_path=''
play_files=''
run_demo=''

_uci_get() {
	local opt="$1"
	grep -w "$opt" $CONFIG_FILE | awk -F '=' '{print $2}' | tr -d "'"
}

_logger() {
	local msg="$1"
	/usr/bin/logger -t "$LOG_TAG" "$msg"
}

_killall() {
	pkill -f omxplayer-sync
	pkill omxplayer
	pkill omxplayer.bin
}

do_init() {
	_killall
}

exit_safely() {
	_logger "WARN>> exiting"
	_killall
}

chk_env() {
	if [ ! -f "$CONFIG_FILE" ]; then
		_logger "ERRO>> No config file $CONFIG_FILE"
		exit 1
	fi

	run_demo=`_uci_get video.player.rundemo`

	if [ "$run_demo" = "1" ]; then
		file_path="/home/pi"
	else
		file_path=`_uci_get video.player.filepath`
	fi

	if [ ! -d "$file_path" ]; then
		_logger "ERRO>> No such directory $file_path"
		exit 1
	fi
}

update_parms() {
	local mode=`_uci_get video.player.mode`
	run_mode="${mode,,}"

	case "$run_mode" in # sync_loop | sync | loop
		"sync_loop"|"sync")
			run_exec="/usr/bin/omxplayer-sync" ;;
		"loop")
			run_exec="/usr/bin/omxplayer" ;;
	esac

	if [ "$run_demo" = "1" ]; then
		play_files="${file_path}/synctest.mp4"
	else
		play_files=`find $file_path \( -name "*.mp4" -o -name "*.mkv" -o -name "*.m4v" -o -name "*.mov" -o -name "*.avi" \) | head -n 1`
	fi

	if [ -f "$play_files" ]; then
		_logger "INFO>> found video files: $play_files"
	else
		_logger "ERRO>> No supported video files found in $file_path"
		exit 1
	fi 
}

play_video() {
	local role=`_uci_get video.player.role`
	local loop=`_uci_get video.player.loop`
	local verbose=`_uci_get video.player.verbose`
	local audio_dev=`_uci_get video.player.audiodev`
	local if_name=`_uci_get video.player.ifname`
	#local destination=`ip -4 addr show ${if_name} | grep -oP '(?<=brd\s)\d+(\.\d+){3}'`

	if [ "${role,,}" = "master" ]; then
		run_parms="${run_parms} --master"
	else
		run_parms="${run_parms} --slave"
	fi

	if [ "$loop" = "1" ]; then
		run_parms="${run_parms} --loop"
	fi

	if [ "$verbose" = "1" ]; then
		run_parms="${run_parms} --verbose"
	fi

	if [ "$audio_dev" != "" ]; then
		run_parms="${run_parms} --adev=$audio_dev"
	fi

	#if [ "$destination" != "" ]; then
	#	run_parms="${run_parms} --destination=$destination"
	#fi
	
	_logger "INFO>> starting ${run_exec}"
	$DO $run_exec $run_parms "$play_files"
}

do_main() {
	do_init
	chk_env
	update_parms
	play_video
}

trap exit_safely EXIT

do_main
