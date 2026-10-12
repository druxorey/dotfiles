#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"
declare -r FORMAT_INFO="\e[1;34m[INFO]\e[0m"

declare -r REPO_URL="https://github.com/druxorey/dotfiles.git"

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
	
	echo -e "${FORMAT_BOLD}USAGE:${FORMAT_RESET} ${0##*/} <COMMAND> [FLAVOUR]

${FORMAT_BOLD}COMMANDS:${FORMAT_RESET}
  backup  [OPTIONS]  Backs up active dotfiles configuration from your system to the repository.
  install [FLAVOUR]  Installs system completely without prompts (yay, packages, configs, services).
  config  [FLAVOUR]  Configures user preferences (Git, NAS, secrets).

${FORMAT_BOLD}FLAVOURS:${FORMAT_RESET}
  bspwm, kde, minimal (core only)

${FORMAT_BOLD}OPTIONS:${FORMAT_RESET}
  -d                Show changes without modifying repository files (dry-run).
  -f FLAVOUR        Force specific flavour.
  -h, --help        Show this help screen."

	return 0
}


function checkDependencies() {
	local action="$1"
	local -a requiredDeps=("git" "curl")

	case "$action" in
		backup)  requiredDeps+=("rsync" "grep" "awk" "sed" "sort") ;;
		install) requiredDeps+=("git") ;;
		config)  requiredDeps=() ;;
	esac

	local -a missingDeps=()
	for dep in "${requiredDeps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			missingDeps+=("$dep")
		fi
	done

	if [[ ${#missingDeps[@]} -gt 0 ]]; then
		printf "%b Missing required package(s): %s\n" "$FORMAT_FAILURE" "${missingDeps[*]}" >&2
		printf "Please install them before running 'drxdots %s'.\n" "$action" >&2
		return 1
	fi

	return 0
}


function ensureRepository() {
	local action="$1"

	# Check if current directory is already the dotfiles repo
	if [[ -f "core/core.yaml" && -d "flavours" ]]; then
		return 0
	fi

	case "$action" in
		backup)
			local dirContents=$(ls -A 2>/dev/null)
			if [[ -z "$dirContents" ]]; then
				printf "%b Empty directory detected. Initializing dotfiles repository...\n" "$FORMAT_INFO"
				if ! git clone "$REPO_URL" .; then
					printf "%b Failed to clone dotfiles repository into current directory.\n" "$FORMAT_FAILURE" >&2
					return 1
				fi
				printf "%b Repository initialized successfully.\n" "$FORMAT_SUCCESS"
				return 0
			else
				printf "%b Current directory is not a dotfiles repository and is not empty.\n" "$FORMAT_FAILURE" >&2
				printf "To initialize and backup here, run inside an empty directory or navigate to your dotfiles repo.\n" >&2
				return 1
			fi
			;;
		install|config)
			local -r targetDir="/tmp/dotfiles"
			if [[ -d "$targetDir/.git" ]]; then
				printf "Found existing dotfiles repository in %s, updating...\n" "$targetDir"
				git -C "$targetDir" pull >/dev/null 2>&1 || true
			else
				printf "Cloning dotfiles repository to %s...\n" "$targetDir"
				rm -rf "$targetDir"
				if ! git clone "$REPO_URL" "$targetDir"; then
					printf "%b Failed to clone dotfiles repository.\n" "$FORMAT_FAILURE" >&2
					return 1
				fi
			fi
			cd "$targetDir" || return 1
			return 0
			;;
	esac

	return 0
}


function detectFlavour() {
	local desktop=$(echo "${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}" | tr '[:upper:]' '[:lower:]')
	
	case "$desktop" in
		*kde*|*plasma*) echo "kde"; return 0 ;;
		*cinnamon*)     echo "cinnamon"; return 0 ;;
		*bspwm*)        echo "bspwm"; return 0 ;;
		*mangowm*)      echo "mangowm"; return 0 ;;
	esac
	
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
		*".obsidian"*)   echo "$parent/config/obsidian" ;;
		*".config/"*)    echo "$parent/config/${src#*.config/}" ;;
		*".local/"*)     echo "$parent/local/${src#*.local/}" ;;
		"$HOME/"*)       local tmp="${src#\~/}"; echo "$parent/home/${tmp#$HOME/}" ;;
		"~"*)            echo "$parent/home/${src#\~}" ;;
		*)               echo "$parent/extras/${src#/}" ;;
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
		printf "\n%b Failed to backup Brave bookmarks.\n" "$FORMAT_FAILURE" >&2
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
		
		if [[ "$IS_DRY_RUN" -eq 1 ]]; then
			# Run rsync and capture/filter stdout to show changes in dry-run mode
			"${rsyncCmd[@]}" | grep -E '^deleting |^[^/]+$' | grep -vE '^sending|^sent|^total|^$' | sed 's/^/  -> /'
		else
			"${rsyncCmd[@]}" > /dev/null
		fi
	fi

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
		printf "%b Configuration file not found: %s\n" "$FORMAT_FAILURE" "$yamlFile" >&2
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
		printf "\n%b Failed to backup local utils.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	backupIndex=$((backupIndex + 1))
	printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Successfully backed up:\e[0m %s" "$backupIndex" "local utils"
	tput el
	return 0
}


function backupPackages() {
	local sysPackagesFile="$HOME/.local/share/packages.list"
	local corePackagesFile="core/core.packages"

	if [[ ! -f "$sysPackagesFile" ]]; then
		printf "\n\e[0;33m[SKIP]\e[0m System packages list not found: %s\n" "$sysPackagesFile"
		return 0
	fi

	if [[ -z "$FLAVOUR" ]]; then
		printf "\n\e[0;33m[SKIP]\e[0m No active flavour detected or specified for package assignment.\n"
		return 0
	fi

	local flavourPackagesFile="flavours/$FLAVOUR/$FLAVOUR.packages"
	if [[ ! -f "$flavourPackagesFile" ]]; then
		mkdir -p "$(dirname "$flavourPackagesFile")"
		touch "$flavourPackagesFile"
	fi

	declare -A coreMap=()
	if [[ -f "$corePackagesFile" ]]; then
		while IFS= read -r pkg || [[ -n "$pkg" ]]; do
			pkg=$(cleanValue "$pkg")
			[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
			coreMap["$pkg"]=1
		done < "$corePackagesFile"
	fi

	declare -A flavourMap=()
	while IFS= read -r pkg || [[ -n "$pkg" ]]; do
		pkg=$(cleanValue "$pkg")
		[[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
		# Clean any stray syntax if previously corrupted
		[[ "$pkg" =~ ^(declare|new_packages|\(|\)|#) ]] && continue
		flavourMap["$pkg"]=1
	done < "$flavourPackagesFile"

	# Sourcing the file populates the bash array new_packages
	local -a new_packages=()
	source "$sysPackagesFile" 2>/dev/null || true

	# Fallback: if sourcing didn't populate new_packages, parse lines safely
	local -a sourcePackages=()
	if [[ ${#new_packages[@]} -gt 0 ]]; then
		sourcePackages=("${new_packages[@]}")
	else
		while IFS= read -r line || [[ -n "$line" ]]; do
			line=$(cleanValue "$line")
			[[ -z "$line" || "$line" =~ ^# ]] && continue
			[[ "$line" =~ ^(declare|new_packages|\(|\)) ]] && continue
			sourcePackages+=("$line")
		done < "$sysPackagesFile"
	fi

	# - Discard if in core.packages
	# - Discard if already in flavour.packages
	# - Retain only truly new packages
	local -a trulyNewPackages=()
	for pkg in "${sourcePackages[@]}"; do
		pkg=$(cleanValue "$pkg")
		[[ -z "$pkg" ]] && continue
		# Ignore any bash keywords or delimiters
		[[ "$pkg" =~ ^(declare|new_packages|\(|\)|#) ]] && continue

		[[ -n "${coreMap["$pkg"]}" ]] && continue
		[[ -n "${flavourMap["$pkg"]}" ]] && continue

		trulyNewPackages+=("$pkg")
		flavourMap["$pkg"]=1
	done

	local count=${#trulyNewPackages[@]}
	if [[ "$count" -eq 0 ]]; then
		backupIndex=$((backupIndex + 1))
		printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Packages up to date:\e[0m %s (0 new)" "$backupIndex" "$flavourPackagesFile"
		tput el
		return 0
	fi

	if [[ "$IS_DRY_RUN" -eq 1 ]]; then
		printf "\e[1;34m[DRY-RUN]\e[0m Add %d new packages to %s: %s\n" "$count" "$flavourPackagesFile" "${trulyNewPackages[*]}"
		return 0
	fi

	for pkg in "${trulyNewPackages[@]}"; do
		echo "$pkg" >> "$flavourPackagesFile"
	done

	# Clean out any stray lines or empty lines, keep pure list of sorted packages
	local tempClean=$(grep -v -E '^(declare|new_packages|\(|\)|#|[[:space:]]*$)' "$flavourPackagesFile" | sort -u)
	echo "$tempClean" > "$flavourPackagesFile"

	backupIndex=$((backupIndex + 1))
	printf "\r\e[1;32m ✔ [\e[0m%02d\e[1;32m] Successfully backed up:\e[0m %s (+%d new packages)" "$backupIndex" "$flavourPackagesFile" "$count"
	tput el
	return 0
}


function backupDotfiles() {
	local forcedFlavour="$1"

	if [[ -n "$forcedFlavour" ]]; then
		if [[ ! -d "flavours/$forcedFlavour" ]]; then
			printf "%b Forced flavour '%s' does not exist in flavours/ directory.\n" "$FORMAT_FAILURE" "$forcedFlavour" >&2
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
	
	if [[ ! -f "core/core.yaml" ]]; then
		printf "%b Core configuration 'core/core.yaml' not found. Cannot proceed.\n" "$FORMAT_FAILURE" >&2
		exit 1
	fi

	parseConfig "core/core.yaml"
	
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
	backupPackages
	
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


function installDotfiles() {
	local targetFlavour="$1"

	printf "====================================================\n"
	printf "           DRXDOTS SYSTEM INSTALLATION              \n"
	printf "====================================================\n"

	if [[ -n "$targetFlavour" && "$targetFlavour" != "minimal" && "$targetFlavour" != "core" ]]; then
		if [[ ! -d "flavours/$targetFlavour" ]]; then
			printf "%b Flavour '%s' does not exist in flavours/ directory.\n" "$FORMAT_FAILURE" "$targetFlavour" >&2
			return 1
		fi
	fi

	if [[ ! -f "core/core-install.sh" ]]; then
		printf "%b 'core/core-install.sh' not found.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	printf "\n>>> [1/2] Executing core installation...\n"
	if ! bash "core/core-install.sh"; then
		printf "%b Core installation failed.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if [[ -n "$targetFlavour" && "$targetFlavour" != "minimal" && "$targetFlavour" != "core" ]]; then
		local -r flavourScript="flavours/$targetFlavour/$targetFlavour-install.sh"
		if [[ -f "$flavourScript" ]]; then
			printf "\n>>> [2/2] Executing flavour installation (%s)...\n" "$targetFlavour"
			if ! bash "$flavourScript"; then
				printf "%b Flavour installation '%s' failed.\n" "$FORMAT_FAILURE" "$targetFlavour" >&2
				return 1
			fi
		else
			printf "%b Installation script for flavour '%s' not found: %s\n" "$FORMAT_FAILURE" "$targetFlavour" "$flavourScript" >&2
			return 1
		fi
	else
		printf "\n>>> [2/2] No desktop flavour selected (minimal core installation only).\n"
	fi

	printf "\n====================================================\n"
	printf "%b Full installation completed successfully!\n" "$FORMAT_SUCCESS"
	printf "You can configure additional preferences later via 'drxdots config'.\n"
	printf "====================================================\n"
	return 0
}


function configDotfiles() {
	# WIP
	return 0
}


function main() {
	local command=""
	local targetFlavour=""

	while [[ $# -gt 0 ]]; do
		case "$1" in
			backup)
				command="backup"
				shift
				;;
			install)
				command="install"
				shift
				if [[ $# -gt 0 && ! "$1" =~ ^- ]]; then
					targetFlavour="$1"
					shift
				fi
				;;
			config)
				command="config"
				shift
				if [[ $# -gt 0 && ! "$1" =~ ^- ]]; then
					targetFlavour="$1"
					shift
				fi
				;;
			-d)
				IS_DRY_RUN=1
				shift
				;;
			-f)
				targetFlavour="$2"
				shift 2
				;;
			-h)
				help
				exit 0
				;;
			*)
				printf "%b Unknown option or command: '%s'. Try '%s --help'.\n" "$FORMAT_FAILURE" "$1" "${0##*/}" >&2
				exit 1
				;;
		esac
	done

	if [[ -z "$command" ]]; then
		help
		exit 1
	fi

	if ! checkDependencies "$command"; then
		exit 1
	fi

	if ! ensureRepository "$command"; then
		exit 1
	fi

	case "$command" in
		backup)  backupDotfiles "$targetFlavour"  ;;
		install) installDotfiles "$targetFlavour" ;;
		config)  configDotfiles "$targetFlavour"  ;;
	esac
}

main "$@"
