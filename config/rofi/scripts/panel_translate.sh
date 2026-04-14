#!/bin/bash

declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_translate.rasi"
declare -r HISTORY_FILE="$HOME/.cache/rofi_translator_history"

function main() {
	[[ ! -f "$HISTORY_FILE" ]] && touch "$HISTORY_FILE"

	local input=""
	local message=""
	local rofiCmd=(rofi -dmenu -m -1 -config "$ROFI_CONFIG")

	while true; do
		input=$(tac "$HISTORY_FILE" | "${rofiCmd[@]}" ${message:+-mesg "$message"})

		if [[ -z "$input" ]]; then
			printf "%b Translator closed.\n" "$FORMAT_WARNING"
			exit 0
		fi

		sed -i "\|^${input}$|d" "$HISTORY_FILE" 2>/dev/null
		echo "$input" >> "$HISTORY_FILE"

		# Dictionary mode. Pattern: lang word (e.g., en food)
		if [[ "$input" =~ ^([a-zA-Z]{2})[[:space:]]+(.*)$ ]]; then
			local lang="${BASH_REMATCH[1]}"
			local query="${BASH_REMATCH[2]}"
			printf "Dictionary mode. Lang: '%s', Word: '%s'\n" "$lang" "$query"

			local result=$(trans -d -no-ansi -show-original-phonetics n -s "$lang" -t "$lang" "$query" 2>/dev/null)
			message="<b>Definition:</b> $(echo "$result" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | head -n 30)"

		# Translation mode with optional source language. Pattern: [src:]tgt word (e.g., en:es hello or :es hello)
		elif [[ "$input" =~ ^([a-zA-Z]{0,2}):([a-zA-Z]{2})[[:space:]]+(.*)$ ]]; then
			local source="${BASH_REMATCH[1]}"
			local target="${BASH_REMATCH[2]}"
			local query="${BASH_REMATCH[3]}"

			printf "Translation mode. Source: '%s', Target: '%s', Text: '%s'\n" "${source:-auto}" "$target" "$query"
			
			local transOpts="-b -no-ansi -t $target"
			[[ -n "$source" ]] && transOpts="$transOpts -s $source"

			local result=$(trans $transOpts "$query" 2>/dev/null)
			message="<b>Traducción:</b> $(echo "$result" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')"
			echo "$result" | xclip -selection clipboard

		# Auto dictionary mode. If input doesn't match previous patterns, treat it as a word to look up in the dictionary.
		else
			printf "Auto dictionary mode. Word: '%s'\n" "$input"
			
			local result=$(trans -d -no-ansi "$input" 2>/dev/null | head -n 30)
			message="<b>Definición:</b> $(echo "$result" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')"
		fi
	done

	return 0
}

main "$@"
