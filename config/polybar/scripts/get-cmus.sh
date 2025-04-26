#!/bin/bash

status=$(cmus-remote -Q 2>/dev/null)
if [ $? -ne 0 ]; then
    echo ""
    exit 0
fi

state=$(echo "$status" | grep "status" | awk '{print $2}')
artist=$(echo "$status" | grep "tag artist" | cut -d ' ' -f 3-)
title=$(echo "$status" | grep "tag title" | cut -d ' ' -f 3-)

if [ "$state" = "playing" ]; then
    echo " $artist - $title"
elif [ "$state" = "paused" ]; then
    echo " $artist - $title"
else
    echo " Stopped"
fi
