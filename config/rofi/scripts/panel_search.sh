#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r QUERY_ROFI_CONFIG="$HOME/.config/rofi/shared/layout_scan.rasi"
declare -r RESULTS_ROFI_CONFIG="$HOME/.config/rofi/modules/panel_search.rasi"

function main() {
	local query=$(rofi -dmenu -m -1 -mesg "Search via DuckDuckGo" -config "$QUERY_ROFI_CONFIG")

	if [[ -z "$query" ]]; then
		printf "%b Search cancelled or empty.\n" "$FORMAT_WARNING"
		exit 0
	fi

	printf "Searching for: %s\n" "$query"

	local results=$(ddgr --unsafe --json -n 10 "$query" 2>/dev/null)

	if [[ -z "$results" || "$results" == "[]" ]]; then
		printf "%b No results found or an error occurred.\n" "$FORMAT_ERROR"
		notify-send -u critical --app-name "Search Error" "No results found for $query"
		exit 1
	fi

	local jqFilter='.[] | "\(.title | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;"))\n<span color=\"#6272A4\" size=\"small\">\(.url | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;"))</span>\u0000"'
	local selectedIndex=$(echo "$results" | jq -j "$jqFilter" | rofi -dmenu -format i -m -1 -sep '\0' -markup-rows -eh 2 -mesg "<b>Query:</b> $query" -config "$RESULTS_ROFI_CONFIG")

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	local url=$(echo "$results" | jq -r ".[$selectedIndex].url")

	printf "Option selected (Index): %s\n" "$selectedIndex"
	printf "%b Opening URL: %s\n" "$FORMAT_SUCCESS" "$url"

	xdg-open "$url" >/dev/null 2>&1 &

	return 0
}

main "$@"
