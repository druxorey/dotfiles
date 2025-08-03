#!/bin/bash

function main() {
	processes=$(ps aux | awk '{print $11 $12}')

	discord=$(echo $processes | grep "discord")
	steam=$(echo $processes  | grep "steam")
	proton=$(echo $processes  | grep "proton")

	[ -n "$discord" ] && pkill Discord
	[ -n "$steam" ] && pkill steam
	[ -n "$proton" ] && pkill protonvpn-app
}

main $@
