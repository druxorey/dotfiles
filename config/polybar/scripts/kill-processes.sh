#!/bin/bash

function main() {
	local apps=("Discord" "steam" "protonvpn-app" "obs" "localsend")

	for app in "${apps[@]}"; do
		if [[ "$app" == "Discord" ]]; then
			pkill -9 -i "$app" 2>/dev/null
		else
			pkill -i "$app" 2>/dev/null
		fi
	done
}

main "$@"
