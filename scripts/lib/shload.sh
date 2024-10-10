#!/bin/bash

MAX_WIDTH=96
BAR_CHARACTER="="

setupShload() {
	# Progress bar variables
	maxValue=$1
	barMessage=$2

	# Bar width depends on terminal size, max width is 96
	# and the default delimiter is 1 percent
	barDelimiter=$maxValue
	while [ $(($MAX_WIDTH + ($MAX_WIDTH / 4))) -gt $(tput cols) ]; do
		MAX_WIDTH=$(($MAX_WIDTH / 2))
		barDelimiter=$(($barDelimiter * 2))
	done

	# If maximum count is less than bar width,
	# adjust symbol width and delimiter (when will the bar update)
	actualPercentage=$MAX_WIDTH
	while [ $1 -lt $actualPercentage ]; do
		barDelimiter=$(($barDelimiter * 2))
		BAR_CHARACTER="$BAR_CHARACTER$BAR_CHARACTER"
		actualPercentage=$(($actualPercentage / 2))
	done

	# Empty bar and completion variable
	progressBar=""
	previousPercentage=0

	# Print the skeleton and save cursor location
	printf "${barMessage}:\033[0m\033[s [\033[${MAX_WIDTH}C] 0%%"
	# Add 1 to the width (less math later)
	MAX_WIDTH=$(($MAX_WIDTH + 1))
}


function updateShload() {
	actualPercentage=$(($1 * 100))
	finalPercentage=$(($actualPercentage / $maxValue))

	if [ $finalPercentage -ne $previousPercentage ]; then
		# Make the bar itself, by printing the number of characters needed
		progressBar=$(printf "%0.s${BAR_CHARACTER}" $(seq -s " " 1 $(($actualPercentage / $barDelimiter))))
		previousPercentage=$finalPercentage
	fi

	# Print progress bar and percentage
	printf "\033[u [$progressBar\033[u \033[${MAX_WIDTH}C] $finalPercentage%%"
}

: '
# How to use
value=128

setupShload $value

count=0
while [ $count -lt $maxValue ]; do
	sleep .01
	count=$(($count + 1))
	updateShload $count
done
'
