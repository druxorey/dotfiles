#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r QUERY_ROFI_CONFIG="$HOME/.config/rofi/shared/layout_scan.rasi"
declare -r RESULTS_ROFI_CONFIG="$HOME/.config/rofi/modules/panel_search.rasi"
declare -r BOOKMARKS_FILE="$HOME/Workspace/dotfiles/local/share/brave/bookmarks.yaml"

declare -A SEARCH_ENGINES=(
	["y"]="https://www.youtube.com/results?search_query="
	["r"]="https://www.reddit.com/search/?q="
	["g"]="https://github.com/search?q="
	["i"]="https://www.google.com/search?tbm=isch&q="
	["a"]="https://wiki.archlinux.org/index.php?search="
)

function urlEncode() {
	local rawString="$1"
	jq -rn --arg x "$rawString" '$x|@uri'
	return 0
}


function openUrl() {
	local targetUrl="$1"
	printf "%b Opening URL: %s\n" "$FORMAT_SUCCESS" "$targetUrl"
	xdg-open "$targetUrl" >/dev/null 2>&1 &
	return 0
}


function findBookmark() {
	local searchQuery="$1"
	
	if [[ ! -f "$BOOKMARKS_FILE" ]]; then
		printf "%b Bookmarks file not found at: %s\n" "$FORMAT_ERROR" "$BOOKMARKS_FILE" >&2
		return 1
	fi

	local resultUrl
	resultUrl=$(awk -v q="$searchQuery" '
		BEGIN { q = tolower(q) }
		/^[ \t]*- name:/ {
			# Clean the tag to leave only the name
			sub(/^[ \t]*- name:[ \t]*/, "")
			name = $0
			
			# Read the next line to get the URL
			getline
			if ($0 ~ /^[ \t]*url:/) {
				sub(/^[ \t]*url:[ \t]*/, "")
				url = $0
				# index() == 1 ensures the bookmark name starts exactly with the query
				if (index(tolower(name), q) == 1) {
					print url
					exit 0
				}
			}
		}
	' "$BOOKMARKS_FILE" 2>/dev/null)

	if [[ -n "$resultUrl" ]]; then
		echo "$resultUrl"
		return 0
	fi

	return 1
}


function performWebSearch() {
	local searchQuery="$1"
	printf "Performing web search for: %s\n" "$searchQuery"

	local fetchResults=$(ddgr --unsafe --json -n 10 "$searchQuery" 2>/dev/null)

	if [[ -z "$fetchResults" || "$fetchResults" == "[]" ]]; then
		printf "%b No results found or an error occurred during web search.\n" "$FORMAT_ERROR"
		notify-send -u critical --app-name "Search Error" "No results found for '$searchQuery'"
		return 1
	fi

	local jqFilter='.[] | "\(.title | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;"))\n<span color=\"#6272A4\" size=\"small\">\(.url | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;"))</span>\u0000"'
	local selectedIndex=$(echo "$fetchResults" | jq -j "$jqFilter" | rofi -dmenu -format i -m -1 -sep '\0' -markup-rows -eh 2 -mesg "<b>Search:</b> $searchQuery" -config "$RESULTS_ROFI_CONFIG")

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected in results menu. Exiting.\n" "$FORMAT_WARNING"
		return 0
	fi

	openUrl "$(echo "$fetchResults" | jq -r ".[$selectedIndex].url")"
	
	return 0
}


function handlePrefixSearch() {
	local fullQuery="$1"
	[[ ! "$fullQuery" =~ ^([a-zA-Z])/(.*)$ ]] && return 1

	local prefix="${BASH_REMATCH[1]}"
	local searchTerm="${BASH_REMATCH[2]}"

	if [[ "$prefix" == "s" ]]; then
		printf "Force web search triggered via 's/' prefix. Query: '%s'\n" "$searchTerm"
		performWebSearch "$searchTerm"
		return 0
	fi

	if [[ -n "${SEARCH_ENGINES[$prefix]}" ]]; then
		printf "Prefix '%s/' recognized. Using direct search engine.\n" "$prefix"
		openUrl "${SEARCH_ENGINES[$prefix]}$(urlEncode "$searchTerm")"
		return 0
	fi
	
	printf "%b Unknown prefix '%s/'. Falling back to standard search flow.\n" "$FORMAT_WARNING" "$prefix"
	return 1
}


function main() {
	local query=$(rofi -dmenu -m -1 -mesg "Search via DuckDuckGo" -config "$QUERY_ROFI_CONFIG")

	if [[ -z "$query" ]]; then
		printf "%b Search cancelled or empty query provided.\n" "$FORMAT_WARNING"
		exit 0
	fi

	handlePrefixSearch "$query" && exit 0

	local bookmarkUrl=$(findBookmark "$query")
	
	if [[ $? -eq 0 && -n "$bookmarkUrl" ]]; then
		printf "Local bookmark match found for '%s'.\n" "$query"
		openUrl "$bookmarkUrl"
		exit 0
	fi

	printf "No local bookmark match found. Proceeding to web search.\n"
	performWebSearch "$query"
	
	exit $?
}

main "$@"
