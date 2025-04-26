#!/bin/bash

ERROR="\e[1;31mERROR:"
WARN="\e[1;33mWARNING:"
SUCCESS="\e[1;32mSUCCESS:"
END="\e[0m"

function help() {
    echo
    echo "USAGE: compress [-o OUTPUT_FILE] [-l COMPRESSION_LEVEL] INPUT_FILE"
    echo
    echo "DESCRIPTION: Compresses a video file using ffmpeg with a specified compression level."
    echo
    echo "ARGUMENTS:"
    echo "  -o OUTPUT_FILE: (Optional) Specify the name of the output file."
    echo "  -l COMPRESSION_LEVEL: (Optional) Compression level (0-3)."
    echo "      0: Low compression (default)."
    echo "      1: Medium compression."
    echo "      2: High compression."
    echo "      3: Maximum compression."
    echo "  INPUT_FILE: The video file to be compressed."
    echo
    echo "EXAMPLES:"
    echo "  compress -o output.mp4 -l 2 input.mp4"
    echo "  compress input.mp4"
    echo
    echo "Report bugs to https://github.com/druxorey/dotfiles/issues"
    echo
    exit 1
}


function main() {
	local file="$1"

	while getopts "h" opt; do
		case $opt in
			h) help ;;
			*) help ;;
		esac
	done

	if [ -f "$file" ] ; then
		case $file in
			*.mp4)    mpv     "$file" ;;
			*.mkv)    mpv     "$file" ;;
			*.mp3)    mpv     "$file" ;;
			*.avi)    mpv     "$file" ;;
			*.flac)   mpv     "$file" ;;
			*.png)    sxiv    "$file" ;;
			*.webp)   sxiv    "$file" ;;
			*.jpeg)   sxiv    "$file" ;;
			*.jpg)    sxiv    "$file" ;;
			*.svg)    sxiv    "$file" ;;
			*.pdf)    zathura "$file" ;;
			*) echo -e '"$file" cannot be open via open()\n Use: [mpv, sxiv or zathura]' ;;
		esac
	else
		echo -e '"$file" is not a valid file'
	fi
}

main "$@"
