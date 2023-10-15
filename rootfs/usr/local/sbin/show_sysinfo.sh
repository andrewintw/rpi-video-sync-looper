#!/usr/bin/env bash

sec="${1-10}"

while true; do
	echo "---------------------------------------"
	pstree -a $(pgrep -f videoplayer-monitor.sh)
	echo ""
	pgrep -af "player"
	echo ""
	systemctl list-timers | grep videoplayer-monitor.timer
	sleep $sec
done
