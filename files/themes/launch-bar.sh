#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>

## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PFILE="$DIR/.panel"

## Launch polybar or tint2 accordingly
launch_bar() {
	CPANEL="`cat $PFILE`"

	if [[ "$CPANEL" == 'polybar' ]]; then
		bash "$DIR"/polybar.sh
	elif [[ "$CPANEL" == 'tint2' ]]; then
		bash "$DIR"/tint2.sh
	else
		bash "$DIR"/polybar.sh	
	fi
}

# Execute function
launch_bar
