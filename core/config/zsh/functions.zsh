
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

[[ -z "$FORMAT_SUCCESS" ]] && declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
[[ -z "$FORMAT_WARNING" ]] && declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
[[ -z "$FORMAT_FAILURE" ]] && declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

# Extract common compressed file formats automatically
function ex() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s INPUT_FILE\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done

	shift $((OPTIND - 1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_FAILURE" "$file" >&2 && return 1

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
		*) printf "%b $file cannot be extracted via ex().\n" "$FORMAT_FAILURE" >&2 && return 1 ;;
	esac

	printf "%b %s extracted successfully.\n" "$FORMAT_SUCCESS" "$file"

	return 0
}

# Open common file types with their associated GUI applications
function open() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s INPUT_FILE\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done

	shift $((OPTIND - 1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_FAILURE" "$file" >&2 && return 1

	case $file in
		*.mp4|*.mkv)                                               mpv "$file" ;;
		*.mp3|*.avi|*.flac|*.wav|*.oog|*.m4a)                      mpv --no-video --term-osd-bar "$file" ;;
		*.png|*.webp|*.jpeg|*.jpg|*.svg|*.gif|*.bmp|*.jxl|*.avif)  feh "$file" ;;
		*.pdf|*.epub)                                              zathura "$file" ;;
		*.csv)                                                     sheets "$file" ;;
		*.pptx|*.ppt|*.odp)                                        libreoffice --impress "$file" ;;
		*.docx|*.doc|*.odt)                                        libreoffice --writer  "$file" ;;
		*.torrent)                                                 fragments "$file" ;;
		*) printf "%b $file cannot be open via open() %b.\n" "$FORMAT_FAILURE" >&2 && return 1 ;;
	esac

	return 0
}

# Compile C/C++ files, run them, and cleanup the output binary
function run() {
	while getopts "hf:" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s [-f \"FLAGS\"] INPUT_FILE\n" "${0##*/}" && return 0 ;;
			f) extraFlags="$OPTARG" ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done

	shift $((OPTIND -1))

	local file="$1"

	[[ -z "$file" ]] && printf "%b No input file provided. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1
	[[ ! -f "$file" ]] && printf "%b File '%s' does not exist.\n" "$FORMAT_FAILURE" "$file" >&2 && return 1

	

	local fileExtension=${file##*.}
	local output=$(basename "$file" ".$fileExtension")

	if [[ "$fileExtension" == "cpp" ]]; then
		g++ "$file" -o "${output}.out" -Wall $extraFlags "${@:2}" && ./"${output}.out"
	elif [[ "$fileExtension" == "c" ]]; then
		gcc "$file" -o "${output}.out" -Wall $extraFlags "${@:2}" && ./"${output}.out"
	else
		printf "%b File '%s' is not a C or C++ source file.\n" "$FORMAT_FAILURE" "$file" >&2
		return 1
	fi

	rm "${output}.out"

	return 0
}

# Soft-reset the last Git commit while keeping changes staged.
function gfix() {
	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		printf "%b Not a git repository.\n" "$FORMAT_FAILURE"
		return 1
	fi

	if ! git rev-parse HEAD~1 >/dev/null 2>&1; then
		printf "%b Not enough commits to perform a reset.\n" "$FORMAT_FAILURE"
		return 1
	fi

	printf "Current commit:\n"
	git log --oneline --graph --decorate -n 1

	if git reset --soft HEAD~1; then
		printf "\n Reverted to previous commit:\n"
		git log --oneline --graph --decorate -n 1
	else
		printf "\n%b Failed to perform git reset.\n" "$FORMAT_FAILURE"
		return 1
	fi

	return 0
}

# Connect to a local Samba share (files or media) using smbclient
function buho() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s [files|media]\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done

    local type="$1"
    local credentials="$BUHO_SMB_CREDENTIALS"

    if [[ "$type" != "files" && "$type" != "media" ]]; then
        printf "%b The first argument must be 'files' or 'media'.\n" "$FORMAT_FAILURE" >&2
        return 1
    fi

    smbclient "//192.168.1.10/$type" -U "$credentials"
}

# Copy vi-yanked text to the system clipboard
function vi-yank-to-clipboard() {
    zle vi-yank
    echo -n "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-to-clipboard
bindkey -M vicmd 'y' vi-yank-to-clipboard
