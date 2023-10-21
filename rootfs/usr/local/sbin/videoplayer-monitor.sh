#!/usr/bin/env bash
#
# Copyright 2023 Andrew Lin (https://github.com/andrewintw)
# This Source Code Form is subject to the terms of the Mozilla
# Public License, v. 2.0. If a copy of the MPL was not distributed
# with this file, You can obtain one at
# https://mozilla.org/MPL/2.0/.
# 

# bash
#   └─videoplayer.sh /usr/local/sbin/videoplayer.sh
#       └─python3 /usr/bin/omxplayer-sync --master --loop --adev=both --destination=192.168.90.255 /media/USB/GK5.m4v
#           └─omxplayer /usr/bin/omxplayer --loop -o both --no-keys --no-osd /media/USB/GK5.m4v
#               └─omxplayer.bin --loop -o both --no-keys --no-osd /media/USB/GK5_R1_Adriy.m4v
#                   └─8*[{omxplayer.bin}]

LOG_TAG="player-monitor"

PLAY_CMD_PATTEN="videoplayer.sh"
SYNC_CMD_PATTEN="omxplayer-sync"
WRAP_CMD_PATTEN="omxplayer "
EXEC_CMD_PATTEN="omxplayer.bin"

do_restart=0

_logger() {
	local msg="$1"
	/usr/bin/logger -t "$LOG_TAG" "$msg"
}

_grep_pid() {
	local pname="$1"
	pgrep -f "$pname"
}

_is_proc_exists() {
	local pid="$1"
	local name="$2"

	if [ "$pid" = "" ]; then
		do_restart=1
		_logger "ERRO>> $name cannot be found"
	fi
}

videoplayer_monitoring() {
	local pid_player=`_grep_pid  "$PLAY_CMD_PATTEN"`
	local pid_syncer=`_grep_pid  "$SYNC_CMD_PATTEN"`
	local pid_wrapper=`_grep_pid "$WRAP_CMD_PATTEN"`
	local pid_execbin=`_grep_pid "$EXEC_CMD_PATTEN"`

	_is_proc_exists "$pid_player"  "$PLAY_CMD_PATTEN"
	_is_proc_exists "$pid_syncer"  "$SYNC_CMD_PATTEN"
	_is_proc_exists "$pid_wrapper" "$WRAP_CMD_PATTEN"
	_is_proc_exists "$pid_execbin" "$EXEC_CMD_PATTEN"


	if [ "$do_restart" = "0" ]; then
		_logger "INFO>> ${pid_player}:${PLAY_CMD_PATTEN} -> ${pid_syncer}:${SYNC_CMD_PATTEN} -> ${pid_wrapper}:${WRAP_CMD_PATTEN} -> ${pid_execbin}:${EXEC_CMD_PATTEN}"
	else
		_logger "WARN>> restarting videoplayer ..."
		/usr/local/sbin/videoplayer.sh
	fi
}

do_main() {
	videoplayer_monitoring
}

do_main
