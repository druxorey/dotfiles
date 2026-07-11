#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare FLAVOUR=""
declare CURRENT_SECTION=""
declare SOURCE_PATH=""
declare -a EXCLUDES=()
declare -r REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
	# Priority 1: Check active session environment variables
	local desktop
	desktop=$(echo "${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}" | tr '[:upper:]' '[:lower:]')
	
	if [[ "$desktop" == *"kde"* ]] || [[ "$desktop" == *"plasma"* ]]; then
		echo "kde"
		return 0
	elif [[ "$desktop" == *"cinnamon"* ]]; then
		echo "cinnamon"
		return 0
	elif [[ "$desktop" == *"bspwm"* ]]; then
		echo "bspwm"
		return 0
	elif [[ "$desktop" == *"mangowm"* ]]; then
		echo "mangowm"
		return 0
	fi
	
	# Priority 2: Check running processes
	if pgrep -x "bspwm" >/dev/null 2>&1; then
		echo "bspwm"
		return 0
	elif pgrep -x "cinnamon" >/dev/null 2>&1; then
		echo "cinnamon"
		return 0
	elif pgrep -x "plasmashell" >/dev/null 2>&1 || pgrep -x "kwin" >/dev/null 2>&1; then
		echo "kde"
		return 0
	elif pgrep -x "mangowm" >/dev/null 2>&1; then
		echo "mangowm"
		return 0
	fi
	
	return 1
}

function cleanQuotes() {
	local val="$1"
	val="${val%\"}"
	val="${val#\"}"
	val="${val%\'}"
	val="${val#\'}"
	echo "$val"
}

function getTargetPath() {
	local section="$1"
	local src="$2"
	local parent
	
	if [[ "$section" == "core" ]]; then
		parent="core"
	else
		parent="flavours/$section"
	fi
	
	if [[ "$src" == *".obsidian"* ]]; then
		echo "$parent/config/obsidian"
	elif [[ "$src" == *".config/"* ]]; then
		local subpath="${src#*.config/}"
		echo "$parent/config/$subpath"
	elif [[ "$src" == *".local/"* ]]; then
		local subpath="${src#*.local/}"
		echo "$parent/local/$subpath"
	elif [[ "$src" == "~/"* ]] || [[ "$src" == "$HOME/"* ]]; then
		local subpath="${src#\~/}"
		subpath="${subpath#$HOME/}"
		echo "$parent/home/$subpath"
	elif [[ "$src" == "~"* ]]; then
		local subpath="${src#\~}"
		echo "$parent/home/$subpath"
	else
		local subpath="${src#/}"
		echo "$parent/extras/$subpath"
	fi
}

function backupBookmarks() {
	local bookmarksDir="$HOME/.config/BraveSoftware/Brave-Origin/Profile 1/Bookmarks"
	local yamlDir="$REPOSITORY_ROOT/core/local/share/brave"
	
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

	local targetRel
	targetRel=$(getTargetPath "$CURRENT_SECTION" "$cleanSrc")
	local targetPath="$REPOSITORY_ROOT/$targetRel"
	
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

		# Section check at indent 0
		if [[ "$indent" -eq 0 ]]; then
			if [[ "$cleanLine" == name:* ]]; then
				local val="${cleanLine#name:}"
				CURRENT_SECTION=$(cleanQuotes "$(echo "$val" | xargs)")
			elif [[ "$cleanLine" == routes: ]]; then
				backupItem
				IS_EXCLUDE=0
			fi
		elif [[ -n "$CURRENT_SECTION" ]]; then
			# Inside a section
			if [[ "$cleanLine" == "- source:"* ]]; then
				backupItem
				IS_EXCLUDE=0
				
				local val="${cleanLine#*- source:}"
				SOURCE_PATH=$(cleanQuotes "$(echo "$val" | xargs)")
			elif [[ "$cleanLine" == "exclude:"* ]]; then
				IS_EXCLUDE=1
			elif [[ "$IS_EXCLUDE" -eq 1 ]] && [[ "$cleanLine" == "- "* ]] && [[ "$indent" -ge 4 ]]; then
				local val="${cleanLine#*- }"
				local pattern
				pattern=$(cleanQuotes "$(echo "$val" | xargs)")
				EXCLUDES+=("$pattern")
			fi
		fi
	done < "$yamlFile"

	backupItem
	return 0
}

function main() {
	cd "$REPOSITORY_ROOT" || exit 1
	
	local forcedFlavour=""
	while getopts "df:h" opt; do
		case $opt in
			d) IS_DRY_RUN=1 ;;
			f) forcedFlavour="$OPTARG" ;;
			h) help && exit 0 ;;
			*) printf "%b Invalid option: '-%s'. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$OPTARG" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done
	
	shift $((OPTIND - 1))
	
	# If flavour was not forced via option, check if it was forced via positional argument
	if [[ -z "$forcedFlavour" ]] && [[ -n "$1" ]]; then
		forcedFlavour="$1"
	fi
	
	# Determine if we have an active flavour
	if [[ -n "$forcedFlavour" ]]; then
		# Verify that the forced flavour directory exists
		if [[ ! -d "flavours/$forcedFlavour" ]]; then
			printf "%b Forced flavour '%s' does not exist in flavours/ directory.\n" "$FORMAT_ERROR" "$forcedFlavour" >&2
			exit 1
		fi
		FLAVOUR="$forcedFlavour"
		printf "Backing up dotfiles (Flavour forced: %s)\n" "$FLAVOUR"
	else
		# Try to detect automatically
		local detected
		detected=$(detectFlavour)
		if [[ $? -eq 0 ]] && [[ -n "$detected" ]]; then
			FLAVOUR="$detected"
			printf "Backing up dotfiles (Flavour auto-detected: %s)\n" "$FLAVOUR"
		else
			printf "Backing up dotfiles (Core only, no matching flavour active/detected)\n"
		fi
	fi
	
	[[ "$IS_DRY_RUN" -eq 1 ]] && printf "Dry-run mode enabled. No files will be modified.\n"
	
	# 1. Parse core/core.yaml
	if [[ -f "core/core.yaml" ]]; then
		parseConfig "core/core.yaml"
	else
		printf "%b Core configuration 'core/core.yaml' not found. Cannot proceed.\n" "$FORMAT_ERROR" >&2
		exit 1
	fi
	
	# 2. Parse flavours/$FLAVOUR/$FLAVOUR.yaml if active
	if [[ -n "$FLAVOUR" ]]; then
		local flavourYaml="flavours/$FLAVOUR/$FLAVOUR.yaml"
		if [[ -f "$flavourYaml" ]]; then
			parseConfig "$flavourYaml"
		else
			printf "[INFO] Flavour configuration not found: %s. Skipping flavour backup.\n" "$flavourYaml"
		fi
	fi
	
	backupBookmarks
	
	# Redact user details in the backed up gitconfig file
	local gitconfigPath="$REPOSITORY_ROOT/core/home/.gitconfig"
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
		printf "\r%b All %02d files have been successfully backed up." "$FORMAT_SUCCESS" "$backupIndex"
		tput el
		printf "\n"
	else
		printf "%b Dry-run simulation finished.\n" "$FORMAT_SUCCESS"
	fi
	
	return 0
}

main "$@"
