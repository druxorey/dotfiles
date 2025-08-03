#!/bin/bash

DEFAULT_ROUTE=~/Videos/Anime/download-list
DEFAULT_SPEED=2500
DEFAULT_PASSWORD="ivanime.com"

downloadFiles() {
	local downloadLink=$1
	local downloadSpeed=$2
	local downloadType=$3

	if [ "$downloadType" == "link" ] ; then
		wget --limit-rate=${downloadSpeed}k "$downloadLink"
	else
		xargs -n 1 wget --limit-rate=${downloadSpeed}k < "$downloadLink"
	fi
}


decompressFiles() {
	local password=$1

	for file in *.rar; do
		unrar x -p"$password" "$file"
	done
}


main() {
	local password="$DEFAULT_PASSWORD"
	local downloadType="file"

	while getopts p: flag; do
		case "${flag}" in
			p) password=${OPTARG};;
		esac
	done

	shift $((OPTIND -1))

	local downloadLink=${1:-$DEFAULT_ROUTE}
	local downloadSpeed=${2:-$DEFAULT_SPEED}

	[ ! -f "$downloadLink" ] && downloadType="link"

	downloadFiles "$downloadLink" "$downloadSpeed" "$downloadType"
	decompressFiles "$password"
}

main "$@"
