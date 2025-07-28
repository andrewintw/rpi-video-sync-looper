#!/bin/bash

if [ "$#" -lt 2 ]; then
	echo "Usage: $0 bitrate video1.mp4 video2.mov ..."
	echo "Example: $0 5M video1.mp4 video2.mov"
	exit 1
fi

bitrate=$1
shift	# Remove bitrate from parameters, rest are files

for f in "$@"; do
	if [ ! -f "$f" ]; then
		echo "ERROR> File not found: $f"
		continue
	fi

	base="${f%.*}"

	fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "$f" | awk -F'/' '{printf "%.2f", $1/$2}')
	if (( $(echo "$fps > 30" | bc -l) )); then
		target_fps=30
	else
		target_fps=$fps
	fi

	echo "INFO> Processing $f, original fps=$fps → output fps=$target_fps, bitrate=$bitrate"

	output="${base}_1080p_${target_fps}fps_${bitrate}.mp4"

	time ffmpeg -i "$f" \
		-vf "scale=1920:1080,rotate=PI" \
		-r "$target_fps" \
		-vsync cfr \
		-c:v libx264 -preset fast -b:v "$bitrate" \
		-c:a copy \
		"$output"
done
