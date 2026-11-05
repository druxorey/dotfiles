#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"
declare -r FORMAT_DRY_RUN="\e[1;34m[DRY-RUN]\e[0m"

declare -r SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

declare FLAVOUR=""
declare CURRENT_SECTION=""
declare SOURCE_PATH=""
declare -a EXCLUDES=()
declare -i IS_EXCLUDE=0
declare -i IS_DRY_RUN=0
declare -i BACKUP_INDEX=0

function help() {
	local -r HELP_BOLD="\e[1;34m"
	local -r HELP_RESET="\e[0m"

	echo -e "${HELP_BOLD}USAGE:${HELP_RESET} ${0##*/} [OPTIONS]

${HELP_BOLD}DESCRIPTION:${HELP_RESET} Backs up active dotfiles configuration from your system to the repository.

${HELP_BOLD}OPTIONS:${HELP_RESET}
  -d            Show changes without modifying repository files (dry-run).
  -f FLAVOUR    Force specific flavour (core, minimal or any flavour in flavours/).
  -h            Display this help message."
	exit 0
}

function reportProgress() {
	local -r message="$1"
	local -r detail="$2"

	((BACKUP_INDEX++))
	printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] %s:\e[0m %s" "$BACKUP_INDEX" "$message" "$detail"
	tput el 2>/dev/null

	return 0
}

function resetBackupItem() {
	SOURCE_PATH=""
	EXCLUDES=()

	return 0
}

function detectFlavour() {
	local desktop="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"
	desktop="${desktop,,}"

	case $desktop in
		*kde*|*plasma*) printf "kde\n" && return 0 ;;
		*cinnamon*) printf "cinnamon\n" && return 0 ;;
		*bspwm*) printf "bspwm\n" && return 0 ;;
		*mangowm*) printf "mangowm\n" && return 0 ;;
	esac

	if pgrep -x "mangowm" >/dev/null 2>&1; then
		printf "mangowm\n"
		return 0
	fi

	if pgrep -x "plasmashell" >/dev/null 2>&1 || pgrep -x "kwin" >/dev/null 2>&1; then
		printf "kde\n"
		return 0
	fi

	return 1
}

function cleanValue() {
	local value="${1#"${1%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	value="${value#[\"\']}"
	value="${value%[\"\']}"
	printf "%s\n" "$value"

	return 0
}

function getTargetPath() {
	local -r section="$1"
	local -r src="$2"
	local parent="flavours/$section"
	local relPath

	[[ $section == core ]] && parent="core"

	case $src in
		*".obsidian"*) printf "%s\n" "$parent/config/obsidian" ;;
		*".config/"*) printf "%s\n" "$parent/config/${src#*.config/}" ;;
		*".local/"*) printf "%s\n" "$parent/local/${src#*.local/}" ;;
		"$HOME/"*)
			relPath="${src#"$HOME"/}"
			printf "%s\n" "$parent/home/${relPath#/}"
			;;
		"~/"*) printf "%s\n" "$parent/home/${src#\~/}" ;;
		"~"*) printf "%s\n" "$parent/home/${src#\~}" ;;
		*) printf "%s\n" "$parent/extras/${src#/}" ;;
	esac

	return 0
}

# Extracts package names from a list file. Supports one package per line and
# bash array dumps (multi-line or `declare -p` style) without sourcing the file.
function parsePackageList() {
	local -r listFile="$1"
	local -n outRef="$2"

	local line token
	local -a tokens=()

	while IFS= read -r line || [[ -n $line ]]; do
		line="${line%%#*}"
		line="${line#*'newPackages=('}"
		line="${line//[()]/ }"
		read -ra tokens <<< "$line"

		for token in "${tokens[@]}"; do
			token="${token#\[*\]=}"
			token=$(cleanValue "$token")
			[[ -z $token || $token == declare || $token == newPackages || $token == -* ]] && continue
			outRef+=("$token")
		done
	done < "$listFile"

	return 0
}

function loadPackageSet() {
	local -r listFile="$1"
	local -n setRef="$2"

	[[ -f $listFile ]] || return 0

	local -a listedPackages=()
	parsePackageList "$listFile" listedPackages

	local package
	for package in "${listedPackages[@]}"; do
		setRef["$package"]=1
	done

	return 0
}

function backupBookmarks() {
	local -r bookmarksFile="$HOME/.config/BraveSoftware/Brave-Origin/Profile 1/Bookmarks"
	local -r yamlDir="core/local/share/brave"

	if [[ ! -f $bookmarksFile ]]; then
		printf "\n%b Brave bookmarks file not found: %s\n" "$FORMAT_WARNING" "$bookmarksFile"
		return 0
	fi

	if ((IS_DRY_RUN)); then
		printf "%b Parse Brave bookmarks -> %s/bookmarks.yaml\n" "$FORMAT_DRY_RUN" "$yamlDir"
		return 0
	fi

	mkdir -p "$yamlDir" || return 1

	# Extracts bookmarks from Brave's JSON bookmarks file and converts them to YAML
	if ! grep -E '"name":|"url":' "$bookmarksFile" | awk '
	BEGIN { name = ""; url = ""; }
	/"name":/ {
		name = $0;
		getline;
		if ($0 ~ /"url":/) {
			url = $0;
			print "- name: " substr(name, index(name, ":") + 3, length(name) - index(name, ":") - 4) "\n  url: " substr(url, index(url, ":") + 3, length(url) - index(url, ":") - 3);
		}
	}
	' > "$yamlDir/bookmarks.yaml"; then
		printf "\n%b Failed to backup Brave bookmarks.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	reportProgress "Successfully backed up" "Brave bookmarks"
	return 0
}

function backupUtils() {
	local -r binDir="$HOME/.local/bin"
	local -r utilsDir="utils"

	if [[ ! -d $binDir ]]; then
		printf "\n%b Local bin directory not found: %s\n" "$FORMAT_WARNING" "$binDir"
		return 0
	fi

	if ((IS_DRY_RUN)); then
		printf "%b rsync %s/ -> %s/\n" "$FORMAT_DRY_RUN" "$binDir" "$utilsDir"
		rsync -av --delete --no-perms --dry-run "$binDir/" "$utilsDir/" | grep -E '^deleting |^[^/]+$' | grep -vE '^sending|^sent|^total|^$' | sed 's/^/  -> /'
		return 0
	fi

	mkdir -p "$utilsDir" || return 1
	if ! rsync -av --delete --no-perms "$binDir/" "$utilsDir/" >/dev/null 2>&1; then
		printf "\n%b Failed to backup local utils.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	reportProgress "Successfully backed up" "local utils"
	return 0
}

function backupPackages() {
	local -r sysPackagesFile="$HOME/.local/share/packages.list"
	local -r corePackagesFile="core/core.packages"
	local -r minimalPackagesFile="flavours/minimal/minimal.packages"

	if [[ ! -f $sysPackagesFile ]]; then
		printf "\n%b System packages list not found: %s\n" "$FORMAT_WARNING" "$sysPackagesFile"
		return 0
	fi

	# Determine target packages file (defaults to minimal)
	local targetPackagesFile="$minimalPackagesFile"
	if [[ -n $FLAVOUR && $FLAVOUR != core && $FLAVOUR != minimal ]]; then
		targetPackagesFile="flavours/$FLAVOUR/$FLAVOUR.packages"
	fi

	local -A coreSet=() minimalSet=() targetSet=()
	loadPackageSet "$corePackagesFile" coreSet
	loadPackageSet "$minimalPackagesFile" minimalSet
	loadPackageSet "$targetPackagesFile" targetSet

	local -a sourcePackages=()
	parsePackageList "$sysPackagesFile" sourcePackages

	# Retain only truly new packages: not in core, not in minimal and not already in the target
	local -a newPackages=()
	local package
	for package in "${sourcePackages[@]}"; do
		[[ -n ${coreSet[$package]:-} || -n ${minimalSet[$package]:-} || -n ${targetSet[$package]:-} ]] && continue
		newPackages+=("$package")
		targetSet["$package"]=1
	done

	local -ri count=${#newPackages[@]}
	if ((count == 0)); then
		reportProgress "Packages up to date" "$targetPackagesFile (0 new)"
		return 0
	fi

	if ((IS_DRY_RUN)); then
		printf "%b Add %d new packages to %s: %s\n" "$FORMAT_DRY_RUN" "$count" "$targetPackagesFile" "${newPackages[*]}"
		return 0
	fi

	# Rewrite the target as a sorted, duplicate-free list of clean package names
	local sortedPackages
	sortedPackages=$(printf "%s\n" "${!targetSet[@]}" | sort) || return 1
	mkdir -p "${targetPackagesFile%/*}" || return 1
	printf "%s\n" "$sortedPackages" > "$targetPackagesFile" || return 1

	reportProgress "Successfully backed up" "$targetPackagesFile (+$count new packages)"
	return 0
}

function backupItem() {
	[[ -z $SOURCE_PATH ]] && return 0

	if [[ $CURRENT_SECTION != core && $CURRENT_SECTION != minimal && $CURRENT_SECTION != "$FLAVOUR" ]]; then
		resetBackupItem
		return 0
	fi

	local -i isDir=0
	local cleanSrc="$SOURCE_PATH"
	if [[ $SOURCE_PATH == */ ]]; then
		isDir=1
		cleanSrc="${SOURCE_PATH%/}"
	fi

	local -r expandedSrc="${cleanSrc/#\~/$HOME}"

	if [[ ! -e $expandedSrc ]]; then
		printf "\n%b Source does not exist: %s\n" "$FORMAT_WARNING" "$cleanSrc"
		resetBackupItem
		return 0
	fi

	local targetPath
	targetPath=$(getTargetPath "$CURRENT_SECTION" "$cleanSrc")

	local -i status=0
	if ((isDir == 0)); then
		if ((IS_DRY_RUN)); then
			printf "%b cp %s -> %s\n" "$FORMAT_DRY_RUN" "$expandedSrc" "$targetPath"
		elif ! mkdir -p "${targetPath%/*}" || ! cp -p "$expandedSrc" "$targetPath"; then
			status=1
		fi
	else
		local -a rsyncCmd=("rsync" "-av" "--delete")
		((IS_DRY_RUN)) && rsyncCmd+=("--dry-run")

		local pattern
		for pattern in "${EXCLUDES[@]}"; do
			rsyncCmd+=("--exclude=$pattern")
		done
		rsyncCmd+=("$expandedSrc/" "$targetPath/")

		if ((IS_DRY_RUN)); then
			printf "%b rsync %s/ -> %s/\n" "$FORMAT_DRY_RUN" "$expandedSrc" "$targetPath"
			# Run rsync and capture/filter stdout to show changes in dry-run mode
			"${rsyncCmd[@]}" | grep -E '^deleting |^[^/]+$' | grep -vE '^sending|^sent|^total|^$' | sed 's/^/  -> /'
		elif ! mkdir -p "$targetPath" || ! "${rsyncCmd[@]}" >/dev/null; then
			status=1
		fi
	fi

	if ((status != 0)); then
		printf "\n%b Failed to back up: %s\n" "$FORMAT_FAILURE" "$cleanSrc" >&2
	elif ((IS_DRY_RUN == 0)); then
		reportProgress "Successfully backed up" "$cleanSrc"
	fi

	resetBackupItem
	return $status
}

function backupConfigs() {
	local -r yamlFile="$1"

	if [[ ! -f $yamlFile ]]; then
		printf "%b Configuration file not found: %s\n" "$FORMAT_FAILURE" "$yamlFile" >&2
		return 1
	fi

	local -i status=0
	local -i indent
	local line strippedLine noComment cleanLine

	while IFS= read -r line || [[ -n $line ]]; do
		strippedLine="${line#"${line%%[![:space:]]*}"}"
		indent=$((${#line} - ${#strippedLine}))

		noComment="${line%%#*}"
		cleanLine="${noComment#"${noComment%%[![:space:]]*}"}"
		cleanLine="${cleanLine%"${cleanLine##*[![:space:]]}"}"

		[[ -z $cleanLine ]] && continue

		if ((indent == 0)); then
			# Section check at indent 0
			if [[ $cleanLine == name:* ]]; then
				CURRENT_SECTION=$(cleanValue "${cleanLine#name:}")
			elif [[ $cleanLine == routes: ]]; then
				backupItem || status=1
				IS_EXCLUDE=0
			fi
		elif [[ -n $CURRENT_SECTION ]]; then
			# Inside a section
			if [[ $cleanLine == "- source:"* ]]; then
				backupItem || status=1
				IS_EXCLUDE=0
				SOURCE_PATH=$(cleanValue "${cleanLine#*- source:}")
			elif [[ $cleanLine == "exclude:"* ]]; then
				IS_EXCLUDE=1
			elif ((IS_EXCLUDE == 1 && indent >= 4)) && [[ $cleanLine == "- "* ]]; then
				EXCLUDES+=("$(cleanValue "${cleanLine#*- }")")
			fi
		fi
	done < "$yamlFile"

	backupItem || status=1
	return $status
}

function redactGitconfig() {
	local -r gitconfigPath="core/home/.gitconfig"

	[[ -f $gitconfigPath ]] || return 0

	if ((IS_DRY_RUN)); then
		printf "%b Redact user details in %s\n" "$FORMAT_DRY_RUN" "$gitconfigPath"
		return 0
	fi

	if ! sed -i -E \
		-e 's/(user[[:space:]]*=[[:space:]]*).*/\1user/' \
		-e 's/(name[[:space:]]*=[[:space:]]*).*/\1name/' \
		-e 's/(email[[:space:]]*=[[:space:]]*).*/\1user@mail.com/' \
		-e 's/(signingkey[[:space:]]*=[[:space:]]*).*/\1SIGNING_KEY/' \
		"$gitconfigPath"; then
		printf "\n%b Failed to redact user details in %s\n" "$FORMAT_FAILURE" "$gitconfigPath" >&2
		return 1
	fi

	return 0
}

function backupDotfiles() {
	local -r forcedFlavour="$1"

	if ! command -v rsync >/dev/null 2>&1; then
		printf "%b Missing required package: rsync\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if [[ -n $forcedFlavour ]]; then
		if [[ $forcedFlavour != core && ! -d flavours/$forcedFlavour ]]; then
			printf "%b Forced flavour '%s' does not exist in flavours/ directory.\n" "$FORMAT_FAILURE" "$forcedFlavour" >&2
			return 1
		fi
		FLAVOUR="$forcedFlavour"
		printf "Backing up dotfiles (Flavour forced: %s)\n" "$FLAVOUR"
	else
		local detected
		if detected=$(detectFlavour) && [[ -n $detected ]]; then
			FLAVOUR="$detected"
			printf "Backing up dotfiles (Flavour auto-detected: %s)\n" "$FLAVOUR"
		else
			printf "Backing up dotfiles (Core only, no matching flavour active/detected)\n"
		fi
	fi

	((IS_DRY_RUN)) && printf "Dry-run mode enabled. No files will be modified.\n"

	if [[ ! -f core/core.yaml ]]; then
		printf "%b Core configuration 'core/core.yaml' not found. Cannot proceed.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	local -i status=0

	backupConfigs "core/core.yaml" || status=1

	local -r minimalYaml="flavours/minimal/minimal.yaml"
	if [[ -f $minimalYaml ]]; then
		backupConfigs "$minimalYaml" || status=1
	fi

	if [[ -n $FLAVOUR && $FLAVOUR != minimal && $FLAVOUR != core ]]; then
		local -r flavourYaml="flavours/$FLAVOUR/$FLAVOUR.yaml"
		if [[ -f $flavourYaml ]]; then
			backupConfigs "$flavourYaml" || status=1
		else
			printf "Flavour configuration not found: %s. Skipping flavour backup.\n" "$flavourYaml"
		fi
	fi

	backupPackages || status=1
	backupUtils || status=1
	backupBookmarks || status=1
	redactGitconfig || status=1

	if ((status != 0)); then
		printf "\n%b Backup finished with errors.\n" "$FORMAT_FAILURE" >&2
	elif ((IS_DRY_RUN)); then
		printf "%b Dry-run simulation finished.\n" "$FORMAT_SUCCESS"
	else
		printf "\r%b All %02d configurations have been successfully backed up." "$FORMAT_SUCCESS" "$BACKUP_INDEX"
		tput el 2>/dev/null
		printf "\n"
	fi

	return $status
}

function main() {
	local opt
	local forcedFlavour=""

	while getopts "hdf:" opt; do
		case $opt in
			h) help ;;
			d) IS_DRY_RUN=1 ;;
			f) forcedFlavour="$OPTARG" ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# > 0)); then
		printf "%b Unexpected argument: '%s'. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "$1" "${0##*/}" >&2
		exit 1
	fi

	cd "$REPO_DIR" || return 1
	backupDotfiles "$forcedFlavour"
}

main "$@"
