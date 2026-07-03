
#! ========================================================================== !#
#!
#!                          ███████╗███████╗██╗  ██╗
#!                          ╚══███╔╝██╔════╝██║  ██║
#!                            ███╔╝ ███████╗███████║
#!                           ███╔╝  ╚════██║██╔══██║
#!                          ███████╗███████║██║  ██║
#!                          ╚══════╝╚══════╝╚═╝  ╚═╝
#!
#!                                 FUNCTIONS
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

# Extract common compressed file formats automatically
function ex() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s INPUT_FILE\n" "$(basename "$0")" && exit 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done

	shift $((OPTIND - 1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_ERROR" "$file" >&2 && exit 1

	case "$file" in
		*.tar.bz2) xjf        "$file" ;;
		*.tar.gz)  tar xzf    "$file" ;;
		*.bz2)     bunzip2    "$file" ;;
		*.rar)     unrar x    "$file" ;;
		*.gz)      gunzip     "$file" ;;
		*.tar)     tar xf     "$file" ;;
		*.tbz2)    tar xjf    "$file" ;;
		*.tgz)     tar xzf    "$file" ;;
		*.zip)     7z x       "$file" ;;
		*.Z)       uncompress "$file" ;;
		*.7z)      7z x       "$file" ;;
		*.deb)     ar x       "$file" ;;
		*.tar.xz)  tar xf     "$file" ;;
		*.tar.zst) unzstd     "$file" ;;
		*) printf "%b $file cannot be extracted via ex().\n" "$FORMAT_ERROR" >&2 && exit 1 ;;
	esac

	printf "%b %s extracted successfully.\n" "$FORMAT_SUCCESS" "$file"

	return 0
}

# Open common file types with their associated GUI applications
function open() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s INPUT_FILE\n" "$(basename "$0")" && exit 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done

	shift $((OPTIND - 1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_ERROR" "$file" >&2 && exit 1

	case $file in
		*.mp4|*.mkv|*.mp3|*.avi|*.flac|*.wav|*.oog|*.m4a)  mpv "$file" ;;
		*.png|*.webp|*.jpeg|*.jpg|*.svg|*.gif|*.bmp)       nsxiv "$file" ;;
		*.pdf|*.epub)                                      zathura "$file" ;;
		*.csv)                                             sheets "$file" ;;
		*.pptx|*.ppt|*.odp)                                libreoffice --impress "$file" ;;
		*.docx|*.doc|*.odt)                                libreoffice --writer  "$file" ;;
		*.torrent)                                         fragments "$file" ;;
		*) printf "%b $file cannot be open via open() %b.\n" "$FORMAT_ERROR" >&2 && exit 1 ;;
	esac

	return 0
}

# Compile C/C++ files, run them, and cleanup the output binary
function run() {
	while getopts "hf:" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s [-f \"FLAGS\"] INPUT_FILE\n" "$(basename "$0")" && exit 0 ;;
			f) extraFlags="$OPTARG" ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1 ;;
		esac
	done

	shift $((OPTIND -1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_ERROR" "$(basename "$0")" >&2 && exit 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_ERROR" "$file" >&2 && exit 1

	local fileExtension=${file##*.}
	local output=$(basename "$file" ".$fileExtension")
	if [[ "$fileExtension" == "cpp" ]]; then
		g++ "$file" -o "${output}.out" -Wall $extraFlags "${@:2}" && ./"${output}.out"
	elif [[ "$fileExtension" == "c" ]]; then
		gcc "$file" -o "${output}.out" -Wall $extraFlags "${@:2}" && ./"${output}.out"
	else
		printf "%b File '%s' is not a C or C++ source file.\n" "$FORMAT_ERROR" "$file" >&2
		exit 1
	fi

	rm "${output}.out"

	return 0
}

# Soft-reset the last Git commit while keeping changes staged.
function gfix() {
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		printf "%b Not a git repository.\n" "$FORMAT_ERROR"
		exit 1
	fi

	if ! git rev-parse HEAD~1 >/dev/null 2>&1; then
		printf "%b Not enough commits to perform a reset.\n" "$FORMAT_ERROR"
		exit 1
	fi

	printf "Current commit:\n"
	git log --oneline --graph --decorate -n 1

	if git reset --soft HEAD~1; then
		printf "\n Reverted to previous commit:\n"
		git log --oneline --graph --decorate -n 1
	else
		printf "\n%b Failed to perform git reset.\n" "$FORMAT_ERROR"
		exit 1
	fi

	return 0
}

# Generate Git commit messages using AI based on diffs and history
function gmods() {
	local -r PROMPT_FILE="$HOME/.config/mods/prompts/ai-git-commit-message-generator.md"
	if [[ ! -f "$PROMPT_FILE" ]]; then
		printf "%b Prompt not found in %s\n" "$FORMAT_ERROR" "$PROMPT_FILE"
		return 1
	fi

	local gitDiff=$(git diff --cached)
	if [[ -z "$gitDiff" ]]; then
		printf "%b There are no changes in the staging area to analyze\n" "$FORMAT_WARNING"
		return 1
	fi

	local recentCommits=$(git log -n 25 --format="### Commit: %s%n%b" 2>/dev/null)

	{
		cat "$PROMPT_FILE"
		if [[ -n "$recentCommits" ]]; then
			echo -e "\n\n================ START OF RECENT COMMIT HISTORY (CONTEXT) ================\n"
			echo "$recentCommits"
			echo -e "\n\n================ END OF RECENT COMMIT HISTORY (CONTEXT) ================\n"
		fi
		
		echo -e "\n\n================ START OF INPUT DATA (GIT DIFF) ================\n"
		echo "$gitDiff"
		echo -e "\n\n================ END OF INPUT DATA (GIT DIFF) ================\n"
		echo -e "\n================ START OF USER INPUT (PRIORITY) ================\n"
	} | mods --title "Git Diff" "$@"

	return 0
}

# Query the 'mods' AI tool with a specific role for command explanations
function how() {
	local -r PROMPT_FILE="$HOME/.config/mods/prompts/ai-linux-command-generator.md"
	cat "$PROMPT_FILE" | mods --max-tokens 80 "$*"
}

# Copy vi-yanked text to the system clipboard
function vi-yank-to-clipboard() {
    zle vi-yank
    echo -n "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-to-clipboard
bindkey -M vicmd 'y' vi-yank-to-clipboard
