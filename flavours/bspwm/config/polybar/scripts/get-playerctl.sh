#!/usr/bin/env bash

declare -i MAX_LENGTH_TITLE=50
declare -i MIN_LENGTH_ARTIST=20
declare -i MAX_TOTAL_LENGTH=73

function main() {
	local playerStatus="" activePlayer=""

	for player in $(playerctl --list-all 2>/dev/null); do
		if [[ $(playerctl -p "$player" status 2>/dev/null) == "Playing" ]]; then
			activePlayer="$player"
			playerStatus="Playing"
			break
		fi
	done

	if [[ -z $activePlayer ]]; then
		activePlayer=$(playerctl --list-all 2>/dev/null | head -n 1)
		if [[ -n $activePlayer ]]; then
			playerStatus=$(playerctl -p "$activePlayer" status 2>/dev/null)
		fi
	fi

	if [[ -z $playerStatus ]]; then
		printf " \n"
		return
	fi

	local title=$(playerctl -p "$activePlayer" metadata title 2>/dev/null)
	local artist=$(playerctl -p "$activePlayer" metadata artist 2>/dev/null)
	artist="${artist%%;*}"

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
		Playing) printf "    %s  %s\n" "$title" "$artist" ;;
		Paused)  printf "    %s  %s\n" "$title" "$artist" ;;
		*)       printf "    Stopped\n" ;;
	esac
}

main "$@"
