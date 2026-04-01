#!/bin/bash

function main() {
	pkill -9 -i "Discord" 2>/dev/null

	local targets="steam|protonvpn-app|obs|localsend"
	pkill -i "$targets" 2>/dev/null

	return 0
}

main "$@"
