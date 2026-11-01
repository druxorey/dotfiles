#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_INFO="\e[1;34m[INFO]\e[0m"

declare -r ROFI_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/modules/panel_translate.rasi"
declare -r HISTORY_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/rofi_translator_history"

declare -r REGEX_TRANSLATION='^([a-zA-Z]{0,2}):([a-zA-Z]{2})[[:space:]]+(.*)$'
declare -r REGEX_DICTIONARY='^([a-zA-Z]{2})[[:space:]]+(.*)$'

function help() {
	local -r HELP_BOLD="\e[1;34m"
	local -r HELP_RESET="\e[0m"

	echo -e "${HELP_BOLD}USAGE:${HELP_RESET} ${0##*/} [OPTIONS]

${HELP_BOLD}DESCRIPTION:${HELP_RESET}
  Interactive Rofi panel for translation and dictionary lookups powered by Cortana AI.
  Supports cloud reasoning via Google Gemini with automatic fallback to local Ollama.

${HELP_BOLD}SYNTAX:${HELP_RESET}
  :[tgt] <text>        Translate text to target language (e.g. ':en ¿cómo estás?', ':es hello')
  [src]:[tgt] <text>   Translate from source to target (e.g. 'es:en buenos días')
  [lang] <word>        Dictionary lookup in specific language (e.g. 'en serendipity', 'es albedrío')
  <word>               Auto dictionary lookup (defaults to Spanish definition)

${HELP_BOLD}OPTIONS:${HELP_RESET}
  -h, --help           Display this help message and exit."
	exit 0
}

function resolveLanguageName() {
	local -r code="$1"
	case "$code" in
		'es') echo "español" ;;
		'en') echo "inglés" ;;
		'fr') echo "francés" ;;
		'de') echo "alemán" ;;
		'it') echo "italiano" ;;
		'pt') echo "portugués" ;;
		'ja') echo "japonés" ;;
		'zh') echo "chino" ;;
		'ru') echo "ruso" ;;
		'ko') echo "coreano" ;;
		'la') echo "latín" ;;
		'ar') echo "árabe" ;;
		*)    echo "$code" ;;
	esac
}

function formatPangoMarkup() {
	local -r rawText="$1"
	# 1. Strip ANSI escape sequences
	# 2. Escape XML special characters (&, <, >)
	# 3. Convert markdown bold **word** to Pango <b>word</b>
	# 4. Strip leading empty lines so inline headers look seamless
	echo "$rawText" \
		| sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g' \
		| sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' \
		| sed -E 's/\*\*([^*]+)\*\*/<b>\1<\/b>/g' \
		| sed '/./,$!d'
}

function main() {
	if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
		help
	fi

	# Ensure GEMINI_API_KEY is available in GUI environments
	if [[ -z ${GEMINI_API_KEY:-} && -f "$HOME/.config/zsh/secrets.zsh" ]]; then
		# shellcheck source=/dev/null
		source "$HOME/.config/zsh/secrets.zsh"
	fi

	local -r historyDir="${HISTORY_FILE%/*}"
	if [[ ! -d "$historyDir" ]]; then
		mkdir -p "$historyDir"
	fi
	if [[ ! -f "$HISTORY_FILE" ]]; then
		touch "$HISTORY_FILE"
	fi

	local input=""
	local message=""
	local -a rofiCmd=(rofi -dmenu -m -1 -config "$ROFI_CONFIG")

	while true; do
		input=$(tac "$HISTORY_FILE" | "${rofiCmd[@]}" ${message:+-mesg "$message"})

		if [[ -z "$input" ]]; then
			printf "%b Translator closed.\n" "$FORMAT_INFO"
			return 0
		fi

		# Deduplicate and append input to history
		sed -i "\|^${input}$|d" "$HISTORY_FILE" 2>/dev/null
		echo "$input" >> "$HISTORY_FILE"

		# Case 1: Translation mode. Pattern: [src:]tgt <text> (e.g. ':en hello' or 'es:en hola')
		if [[ "$input" =~ $REGEX_TRANSLATION ]]; then
			local sourceCode="${BASH_REMATCH[1]}"
			local targetCode="${BASH_REMATCH[2]}"
			local queryText="${BASH_REMATCH[3]}"

			local targetName
			targetName=$(resolveLanguageName "$targetCode")

			local translationPrompt=""
			if [[ -n "$sourceCode" ]]; then
				local sourceName
				sourceName=$(resolveLanguageName "$sourceCode")
				translationPrompt="Traduce de ${sourceName} a ${targetName}: ${queryText}"
			else
				translationPrompt="Traduce al ${targetName}: ${queryText}"
			fi

			local result=""
			result=$(cortana trans "$translationPrompt" 2>/dev/null)

			if [[ -n "$result" ]]; then
				printf "%s" "$result" | xclip -selection clipboard 2>/dev/null
				local formattedResult
				formattedResult=$(formatPangoMarkup "$result")
				message="<b>Traducción [${targetName}]:</b> ${formattedResult}"
			else
				message="<b>Error:</b> No se pudo completar la traducción."
			fi

		# Case 2: Dictionary mode with explicit language code. Pattern: <lang> <word> (e.g. 'en food', 'es zapato')
		elif [[ "$input" =~ $REGEX_DICTIONARY ]]; then
			local langCode="${BASH_REMATCH[1]}"
			local wordQuery="${BASH_REMATCH[2]}"

			local langName
			langName=$(resolveLanguageName "$langCode")

			local dictPrompt=""
			if [[ "$langCode" == "en" ]]; then
				dictPrompt="Define en inglés la palabra: ${wordQuery}"
			elif [[ "$langCode" == "es" ]]; then
				dictPrompt="Define en español la palabra: ${wordQuery}"
			else
				dictPrompt="Define en ${langName} la palabra: ${wordQuery}"
			fi

			local result=""
			result=$(cortana dict "$dictPrompt" 2>/dev/null)

			if [[ -n "$result" ]]; then
				local formattedResult
				formattedResult=$(formatPangoMarkup "$result")
				message="<b>Definición [${langName}]:</b> ${formattedResult}"
			else
				message="<b>Error:</b> No se encontró definición para '${wordQuery}'."
			fi

		# Case 3: Auto dictionary mode. Defaults to Spanish definition
		else
			local dictPrompt="Define en español la palabra: ${input}"
			local result=""
			result=$(cortana dict "$dictPrompt" 2>/dev/null)

			if [[ -n "$result" ]]; then
				local formattedResult
				formattedResult=$(formatPangoMarkup "$result")
				message="<b>Definición:</b> ${formattedResult}"
			else
				message="<b>Error:</b> No se encontró definición para '${input}'."
			fi
		fi
	done

	return 0
}

main "$@"
