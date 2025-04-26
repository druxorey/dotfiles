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
		case "$file" in
			*.tar.bz2)  xjf        "$file" ;;
			*.tar.gz)   tar xzf    "$file" ;;
			*.bz2)      bunzip2    "$file" ;;
			*.rar)      unrar x    "$file" ;;
			*.gz)       gunzip     "$file" ;;
			*.tar)      tar xf     "$file" ;;
			*.tbz2)     tar xjf    "$file" ;;
			*.tgz)      tar xzf    "$file" ;;
			*.zip)      unzip      "$file" ;;
			*.Z)        uncompress "$file" ;;
			*.7z)       7z x       "$file" ;;
			*.deb)      ar x       "$file" ;;
			*.tar.xz)   tar xf     "$file" ;;
			*.tar.zst)  unzstd     "$file" ;;
			*) echo -e '"$file" cannot be extracted via ex()' ;;
		esac
	else
		echo -e '"$file" is not a valid file'
	fi
}

main "$@"
