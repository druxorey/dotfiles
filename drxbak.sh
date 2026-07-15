#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare FLAVOUR=""
declare CURRENT_SECTION=""
declare SOURCE_PATH=""
declare -a EXCLUDES=()
declare -i IS_EXCLUDE=0
declare -i IS_DRY_RUN=0
declare -i backupIndex=0

function help() {
	local -r FORMAT_BOLD="\e[1;34m"
	local -r FORMAT_RESET="\e[0m"
	
	echo -e "${FORMAT_BOLD}USAGE:${FORMAT_RESET} $(basename "$0") [OPTIONS] [FLAVOUR]

${FORMAT_BOLD}DESCRIPTION:${FORMAT_RESET}
    Backs up active dotfiles configuration from your system to the repository.

${FORMAT_BOLD}OPTIONS:${FORMAT_RESET}
    -d              Show changes without modifying repository files.
    -f FLAVOUR      Force backup for a specific flavour (e.g. bspwm, cinnamon, kde, mangowm).
    -h              Show this help screen."

	return 0
}


function detectFlavour() {
	local desktop=$(echo "${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}" | tr '[:upper:]' '[:lower:]')
	
	case "$desktop" in
		*kde*|*plasma*)     echo "kde"; return 0 ;;
		*cinnamon*)         echo "cinnamon"; return 0 ;;
		*bspwm*)            echo "bspwm"; return 0 ;;
		*mangowm*)          echo "mangowm"; return 0 ;;
	esac
	
	# Check running processes only for Wayland sessions (kde and mangowm)
	pgrep -x "mangowm" >/dev/null 2>&1 && echo "mangowm" && return 0
	(pgrep -x "plasmashell" || pgrep -x "kwin") >/dev/null 2>&1 && echo "kde" && return 0
	
	return 1
}


function cleanValue() {
	local val="${1#"${1%%[![:space:]]*}"}"
	val="${val%"${val##*[![:space:]]}"}"
	val="${val#[\"\']}"
	val="${val%[\"\']}"
	echo "$val"
}


function getTargetPath() {
	local section="$1"
	local src="$2"
	local parent="flavours/$section"
	[[ "$section" == "core" ]] && parent="core"
	
	case "$src" in
		*".obsidian"*)  echo "$parent/config/obsidian" ;;
		*".config/"*)   echo "$parent/config/${src#*.config/}" ;;
		*".local/"*)    echo "$parent/local/${src#*.local/}" ;;
		"~/"*|"$HOME/"*) local tmp="${src#\~/}"; echo "$parent/home/${tmp#$HOME/}" ;;
		"~"*)           echo "$parent/home/${src#\~}" ;;
		*)              echo "$parent/extras/${src#/}" ;;
	esac
}


function backupBookmarks() {
	local bookmarksDir="$HOME/.config/BraveSoftware/Brave-Origin/Profile 1/Bookmarks"
	local yamlDir="core/local/share/brave"
	
	if [[ ! -f "$bookmarksDir" ]]; then
		printf "\n\e[0;33m[SKIP]\e[0m Brave bookmarks file not found: %s\n" "$bookmarksDir"
		return 0
	fi
	
	if [[ "$IS_DRY_RUN" -eq 1 ]]; then
		printf "\e[1;34m[DRY-RUN]\e[0m Parse Brave bookmarks -> core/local/share/brave/bookmarks.yaml\n"
		return 0
	fi

	mkdir -p "$yamlDir"
	
	# Extracts bookmarks from Brave's JSON bookmarks file and converts them to YAML
	grep -E '"name":|"url":' "$bookmarksDir" | awk '
	BEGIN { name = ""; url = ""; }
	/"name":/ {
		name = $0;
		getline;
		if ($0 ~ /"url":/) {
			url = $0;
			print "- name: " substr(name, index(name, ":") + 3, length(name) - index(name, ":") - 4) "\n  url: " substr(url, index(url, ":") + 3, length(url) - index(url, ":") - 3);
		}
	}
	' > "$yamlDir/bookmarks.yaml" || {
		printf "\n%b Failed to backup Brave bookmarks.\n" "$FORMAT_ERROR" >&2
		return 1
	}

	backupIndex=$((backupIndex + 1))
	printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Successfully backed up:\e[0m %s" "$backupIndex" "Brave bookmarks"
	tput el
	return 0
}


function backupItem() {
	[[ -z "$SOURCE_PATH" ]] && return 0
	
	if [[ "$CURRENT_SECTION" != "core" ]] && [[ "$CURRENT_SECTION" != "$FLAVOUR" ]]; then
		SOURCE_PATH=""
		EXCLUDES=()
		return 0
	fi

	# Determine if it is a directory by checking if it ends with /
	local isDir=0
	local cleanSrc="$SOURCE_PATH"
	if [[ "$SOURCE_PATH" == */ ]]; then
		isDir=1
		cleanSrc="${SOURCE_PATH%/}"
	fi

	local expandedSrc="${cleanSrc/#\~/$HOME}"
	
	if [[ ! -e "$expandedSrc" ]]; then
		printf "\n\e[0;33m[SKIP]\e[0m Source does not exist: %s\n" "$cleanSrc"
		SOURCE_PATH=""
		EXCLUDES=()
		return 0
	fi

	local targetRel=$(getTargetPath "$CURRENT_SECTION" "$cleanSrc")
	local targetPath="$targetRel"
	
	if [[ "$isDir" -eq 0 ]]; then
		if [[ "$IS_DRY_RUN" -eq 1 ]]; then
			printf "\e[1;34m[DRY-RUN]\e[0m cp %s -> %s\n" "$expandedSrc" "$targetRel"
		else
			mkdir -p "$(dirname "$targetPath")"
			cp -p "$expandedSrc" "$targetPath"
		fi
	else
		# Directory synchronization using rsync
		if [[ "$IS_DRY_RUN" -eq 1 ]]; then
			printf "\e[1;34m[DRY-RUN]\e[0m rsync %s/ -> %s/\n" "$expandedSrc" "$targetRel"
		else
			mkdir -p "$targetPath"
		fi
		
		local rsyncCmd=("rsync" "-av" "--delete")
		[[ "$IS_DRY_RUN" -eq 1 ]] && rsyncCmd+=("--dry-run")
		
		for pattern in "${EXCLUDES[@]}"; do
			rsyncCmd+=("--exclude=$pattern")
		done
		rsyncCmd+=("$expandedSrc/" "$targetPath/")
		
		# Execute rsync
		if [[ "$IS_DRY_RUN" -eq 1 ]]; then
			# Run rsync and capture/filter stdout to show changes in dry-run mode
			"${rsyncCmd[@]}" | grep -E '^deleting |^[^/]+$' | grep -vE '^sending|^sent|^total|^$' | sed 's/^/  -> /'
		else
			"${rsyncCmd[@]}" > /dev/null
		fi
	fi

	# Overwrite line and display success message if not in dry-run
	if [[ "$IS_DRY_RUN" -eq 0 ]]; then
		backupIndex=$((backupIndex + 1))
		printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Successfully backed up:\e[0m %s" "$backupIndex" "$cleanSrc"
		tput el
	fi

	SOURCE_PATH=""
	EXCLUDES=()
	return 0
}


function parseConfig() {
	local yamlFile="$1"
	
	if [[ ! -f "$yamlFile" ]]; then
		printf "%b Configuration file not found: %s\n" "$FORMAT_ERROR" "$yamlFile" >&2
		return 1
	fi

	while IFS= read -r line || [[ -n "$line" ]]; do
		local strippedLine="${line#"${line%%[![:space:]]*}"}"
		local indent=$(( ${#line} - ${#strippedLine} ))
		
		local noComment="${line%%#*}"
		local cleanLine="${noComment#${noComment%%[![:space:]]*}}"
		cleanLine="${cleanLine%${cleanLine##*[![:space:]]}}"
		
		[[ -z "$cleanLine" ]] && continue

		if [[ "$indent" -eq 0 ]]; then          # Section check at indent 0
			if [[ "$cleanLine" == name:* ]]; then
				CURRENT_SECTION=$(cleanValue "${cleanLine#name:}")
			elif [[ "$cleanLine" == routes: ]]; then
				backupItem
				IS_EXCLUDE=0
			fi
		elif [[ -n "$CURRENT_SECTION" ]]; then  # Inside a section
			if [[ "$cleanLine" == "- source:"* ]]; then
				backupItem
				IS_EXCLUDE=0
				SOURCE_PATH=$(cleanValue "${cleanLine#*- source:}")
			elif [[ "$cleanLine" == "exclude:"* ]]; then
				IS_EXCLUDE=1
			elif [[ "$IS_EXCLUDE" -eq 1 ]] && [[ "$cleanLine" == "- "* ]] && [[ "$indent" -ge 4 ]]; then
				EXCLUDES+=($(cleanValue "${cleanLine#*- }"))
			fi
		fi
	done < "$yamlFile"

	backupItem
	return 0
}


function backupUtils() {
	local binDir="$HOME/.local/bin"
	local utilsDir="utils"
	
	if [[ ! -d "$binDir" ]]; then
		printf "\n\e[0;33m[SKIP]\e[0m Local bin directory not found: %s\n" "$binDir"
		return 0
	fi
	
	if [[ "$IS_DRY_RUN" -eq 1 ]]; then
		printf "\e[1;34m[DRY-RUN]\e[0m rsync %s/ -> %s/\n" "$binDir" "$utilsDir"
		rsync -av --delete --no-perms --dry-run "$binDir/" "$utilsDir/" | grep -E '^deleting |^[^/]+$' | grep -vE '^sending|^sent|^total|^$' | sed 's/^/  -> /'
		return 0
	fi

	mkdir -p "$utilsDir"
	if ! rsync -av --delete --no-perms "$binDir/" "$utilsDir/" >/dev/null 2>&1; then
		printf "\n%b Failed to backup local utils.\n" "$FORMAT_ERROR" >&2
		return 1
	fi

	backupIndex=$((backupIndex + 1))
	printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Successfully backed up:\e[0m %s" "$backupIndex" "local utils"
	tput el
	return 0
}


function main() {
	if [[ "$(pwd)" != "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" ]]; then
		printf "%b You have to run it inside the repository directory\n" "$FORMAT_SUCCESS"
		return 1
	fi
	
	local forcedFlavour=""
	while getopts "df:h" opt; do
		case $opt in
			d) IS_DRY_RUN=1 ;;
			f) forcedFlavour="$OPTARG" ;;
			h) help && exit 0 ;;
			*) printf "%b Invalid option: '-%s'. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$OPTARG" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done
	
	if [[ -n "$forcedFlavour" ]]; then
		if [[ ! -d "flavours/$forcedFlavour" ]]; then
			printf "%b Forced flavour '%s' does not exist in flavours/ directory.\n" "$FORMAT_ERROR" "$forcedFlavour" >&2
			exit 1
		fi
		FLAVOUR="$forcedFlavour"
		printf "Backing up dotfiles (Flavour forced: %s)\n" "$FLAVOUR"
	else
		local detected=$(detectFlavour)
		if [[ $? -eq 0 ]] && [[ -n "$detected" ]]; then
			FLAVOUR="$detected"
			printf "Backing up dotfiles (Flavour auto-detected: %s)\n" "$FLAVOUR"
		else
			printf "Backing up dotfiles (Core only, no matching flavour active/detected)\n"
		fi
	fi
	
	[[ "$IS_DRY_RUN" -eq 1 ]] && printf "Dry-run mode enabled. No files will be modified.\n"
	
	# Parse core/core.yaml
	if [[ ! -f "core/core.yaml" ]]; then
		printf "%b Core configuration 'core/core.yaml' not found. Cannot proceed.\n" "$FORMAT_ERROR" >&2
		exit 1
	fi

	parseConfig "core/core.yaml"
	
	# Parse flavours/$FLAVOUR/$FLAVOUR.yaml if active
	if [[ -n "$FLAVOUR" ]]; then
		local flavourYaml="flavours/$FLAVOUR/$FLAVOUR.yaml"
		if [[ -f "$flavourYaml" ]]; then
			parseConfig "$flavourYaml"
		else
			printf "[INFO] Flavour configuration not found: %s. Skipping flavour backup.\n" "$flavourYaml"
		fi
	fi
	
	backupBookmarks
	backupUtils
	
	# Redact user details in the backed up gitconfig file
	local gitconfigPath="core/home/.gitconfig"
	if [[ -f "$gitconfigPath" ]]; then
		if [[ "$IS_DRY_RUN" -eq 0 ]]; then
			sed -i -E 's/(user[[:space:]]*=[[:space:]]*).*/\1user/' "$gitconfigPath"
			sed -i -E 's/(name[[:space:]]*=[[:space:]]*).*/\1name/' "$gitconfigPath"
			sed -i -E 's/(email[[:space:]]*=[[:space:]]*).*/\1user@mail.com/' "$gitconfigPath"
			sed -i -E 's/(signingkey[[:space:]]*=[[:space:]]*).*/\1SIGNING_KEY/' "$gitconfigPath"
		else
			printf "\e[1;34m[DRY-RUN]\e[0m Redact user details in core/home/.gitconfig\n"
		fi
	fi
	
	if [[ "$IS_DRY_RUN" -eq 0 ]]; then
		printf "\r%b All %02d configurations have been successfully backed up." "$FORMAT_SUCCESS" "$backupIndex"
		tput el
		printf "\n"
	else
		printf "%b Dry-run simulation finished.\n" "$FORMAT_SUCCESS"
	fi
	
	return 0
}

main "$@"