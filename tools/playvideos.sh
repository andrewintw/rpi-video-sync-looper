#!/bin/bash

declare -A vids

#Make a newline a delimiter instead of a space
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

configs=`cat /boot/configfile.txt`
usb=`echo "$configs" | grep usb | cut -c 5- | tr -d '\r' | tr -d '\n'`
audio_source=`echo "$configs" | grep audio_source | cut -c 14- | tr -d '\r' | tr -d '\n'`
role=`echo "$configs" | grep role | cut -c 6- | tr -d '\r' | tr -d '\n'`

FILES=/home/pi/

if [[ $usb -eq 1 ]]; then
    FILES=/media/USB/
fi

current=0
for f in `ls $FILES | grep ".mp4$\|.avi$\|.mkv$\|.mp3$\|.mov$\|.mpg$\|.flv$\|.m4v$"`
do
        vids[$current]="$f"
        let current+=1
        echo "$f"
done
max=$current
current=0

#Reset the IFS
IFS=$SAVEIFS

while true; do
if pgrep omxplayer > /dev/null
then
        echo 'running'
else
        let current+=1
        if [ $current -ge $max ]
        then
                current=0
        fi

        /usr/bin/omxplayer-sync -"$role"u -o "$audio_source" "$FILES${vids[$current]}"
fi
done

