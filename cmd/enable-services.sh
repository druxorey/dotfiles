#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function parseServices() {
	local servicesFile="$1"
	local -n outRef="$2"

	if [[ -z "$servicesFile" || ! -f "$servicesFile" ]]; then
		return 0
	fi

	local service
	while IFS= read -r service || [[ -n "$service" ]]; do
		service="${service#"${service%%[![:space:]]*}"}"
		service="${service%"${service##*[![:space:]]}"}"
		[[ -z "$service" || "$service" =~ ^# ]] && continue
		outRef+=("$service")
	done < "$servicesFile"

	return 0
}


function enableServices() {
	local servicesFile="$1"
	local -a services=()

	parseServices "$servicesFile" services

	if [[ ${#services[@]} -eq 0 ]]; then
		return 0
	fi

	local listName=$(basename "$servicesFile")
	printf "Enabling services from '%s'...\n" "$listName"

	local service
	for service in "${services[@]}"; do
		if sudo systemctl enable --now "$service" >/dev/null 2>&1; then
			printf "%b Service '%s' enabled and started.\n" "$FORMAT_SUCCESS" "$service"
		elif sudo systemctl enable "$service" >/dev/null 2>&1; then
			printf "%b Service '%s' enabled.\n" "$FORMAT_SUCCESS" "$service"
		else
			printf "%b Service '%s' could not be enabled/started.\n" "$FORMAT_WARNING" "$service"
		fi
	done

	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <SERVICES_FILE>\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	local servicesFile="${1:-}"
	if [[ -z "$servicesFile" ]]; then
		printf "%b Services file argument required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	enableServices "$servicesFile"
}

main "$@"
