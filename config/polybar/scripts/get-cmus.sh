#!/bin/bash

ARTIST_MAX_LENGTH=50

status=$(cmus-remote -Q 2>/dev/null)
if [ $? -ne 0 ]; then
	printf ""
	exit 0
fi

state=$(printf "$status" | grep "status" | awk '{print $2}')
artist=$(printf "$status" | grep "tag artist" | cut -d ' ' -f 3-)
title=$(printf "$status" | grep "tag title" | cut -d ' ' -f 3-)

if [ ${#artist} -gt $ARTIST_MAX_LENGTH ]; then
	artist=$(printf "$artist" | cut -c 1-$ARTIST_MAX_LENGTH)...
fi

if [ "$state" = "playing" ]; then
	printf "   $artist - $title"
elif [ "$state" = "paused" ]; then
	printf "   $artist - $title"
else
	printf "   Stopped"
fi
