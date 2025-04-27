#!/bin/bash

ARTIST_MAX_LENGTH=50

status=$(cmus-remote -Q 2>/dev/null)
if [ $? -ne 0 ]; then
    echo ""
    exit 0
fi

state=$(echo "$status" | grep "status" | awk '{print $2}')
artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)

if [ ${#artist} -gt $ARTIST_MAX_LENGTH ]; then
	artist=$(echo "$artist" | cut -c 1-$ARTIST_MAX_LENGTH)...
fi

if [ "$state" = "playing" ]; then
    echo " $artist - $title"
elif [ "$state" = "paused" ]; then
    echo " $artist - $title"
else
    echo " Stopped"
fi
