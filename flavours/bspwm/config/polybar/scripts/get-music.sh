#!/usr/bin/env bash

declare -i MAX_LENGTH_TITLE=50
declare -i MIN_LENGTH_ARTIST=20
declare -i MAX_TOTAL_LENGTH=73

function main() {

	if pgrep -x lofi > /dev/null; then
		printf "󰋋 Lofi Radio\n"
		return 0
	fi

	local cmusOutput=$(cmus-remote -Q 2>/dev/null)

	if [[ -z "$cmusOutput" ]]; then
		printf " \n"
		return 0
	fi

	local playerStatus=""
	local title=""
	local artist=""

	eval "$(awk '
		/^status / {print "playerStatus=\"" $2 "\""}
		/^tag artist / {sub(/^tag artist /, ""); print "artist=\"" $0 "\""}
		/^tag title / {sub(/^tag title /, ""); print "title=\"" $0 "\""}
	' <<< "$cmusOutput")"

	[[ -z $title ]] && title="Unknown"
	artist="${artist:+-  $artist}"

	local titleLength=${#title}
	local artistLength=${#artist}
	local totalLength=$(( titleLength + artistLength ))

	if [[ $totalLength -gt $MAX_TOTAL_LENGTH ]]; then
		local excess=$(( totalLength - MAX_TOTAL_LENGTH ))

		if [[ -n $artist ]]; then
			local maxArtistReduction=$(( artistLength - MIN_LENGTH_ARTIST ))

			if [[ $maxArtistReduction -gt 0 ]]; then
				if [[ $excess -le $maxArtistReduction ]]; then
					artistLength=$(( artistLength - excess ))
					artist="${artist:0:artistLength}..."
					excess=0
				else
					excess=$(( excess - maxArtistReduction ))
					artistLength=$MIN_LENGTH_ARTIST
					artist="${artist:0:artistLength}..."
				fi
			fi
		fi

		if [[ $excess -gt 0 ]]; then
			titleLength=$(( titleLength - excess ))
			[[ $titleLength -lt 0 ]] && titleLength=0
			title="${title:0:titleLength}..."
		fi
	fi

	case "$playerStatus" in
		playing) printf "    %s  %s\n" "$title" "$artist" ;;
		paused)  printf "    %s  %s\n" "$title" "$artist" ;;
		*)       printf "    Stopped\n" ;;
	esac
}

main "$@"
