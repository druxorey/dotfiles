#!/bin/bash

declare -r formatSuccess="\e[1;32m[SUCCESS]\e[0m"
declare -r formatError="\e[1;31m[ERROR]\e[0m"
declare -r ocrLangs="spa+eng"
declare -r notifyAppName="FlameshotOCR"

function main() {
	local extractedText=$(flameshot gui --raw | tesseract stdin stdout -l "$ocrLangs" 2>/dev/null)

	if [[ -z "${extractedText//[[:space:]]/}" ]]; then
		printf "%b No text detected or capture canceled.\n" "$formatError"
		notify-send "OCR Failed" "No readable text detected." --app-name "$notifyAppName" -u normal
		return 1
	fi

	printf "%s" "$extractedText" | xclip -in -selection clipboard

	local snippet="${extractedText:0:40}"
	[[ ${#extractedText} -gt 40 ]] && snippet="${snippet}..."

	printf "%b Text extracted and copied successfully.\n" "$formatSuccess"
	notify-send "OCR Success" "Copied to clipboard:\n\n<i>$snippet</i>" --app-name "$notifyAppName"

	return 0
}

main "$@"
