#!/bin/bash
state=~/.config/polybar/state

if [[ -f $state && $(cat $state) == "monocle" ]]; then
  pkill polybar && polybar main-normal &
  echo "normal" > $state
else
  pkill polybar && polybar main-monocle &
  echo "monocle" > $state
fi
