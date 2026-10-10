#!/bin/bash

#! ========================================================================== !#
#!
#!                       ██████╗  █████╗ ███████╗██╗  ██╗
#!                       ██╔══██╗██╔══██╗██╔════╝██║  ██║
#!                       ██████╔╝███████║███████╗███████║
#!                       ██╔══██╗██╔══██║╚════██║██╔══██║
#!                       ██████╔╝██║  ██║███████║██║  ██║
#!                       ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#!
#!                                   BASHRC
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

#* ================================= startup ================================ *#

[[ $- != *i* ]] && return

function getStartTime() {
    date +%s.%N > "/dev/shm/${USER}.bashtime.${1}"
}

function getStopTime() {
    local endtime starttime elapsed
    endtime=$(date +%s.%N)
    starttime=$(cat "/dev/shm/${USER}.bashtime.${1}")
    elapsed=$(echo "scale=3; ($endtime - $starttime) / 1" | bc)
    printf "%.3f\n" "$elapsed"
}

ROOTPID=$BASHPID
getStartTime $ROOTPID

FORMAT_DIR='\[\e[1;34m\]'
FORMAT_TIME='\[\e[1;36m\]'
FORMAT_RESET='\[\e[0m\]'

PS0='$(getStartTime $ROOTPID)'
PS1="${FORMAT_TIME}[\$(getStopTime \$ROOTPID)ms] ${FORMAT_DIR}\w${FORMAT_RESET} > "
eval "$(zoxide init bash)"
