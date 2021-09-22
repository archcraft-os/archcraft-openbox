#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CARD="$(ls /sys/class/backlight | head -n 1)"
RFILE="$DIR/.module"

# Fix backlight module for non intel machines
backlight() {
	if [[ "$CARD" != *"intel_"* ]]; then
		if [[ ! -f "$RFILE" ]]; then
			sed -i -e 's/backlight/brightness/g' "$DIR"/config.ini
			touch "$RFILE"
		fi
	fi
}

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar
	polybar -q top -c "$DIR"/config.ini &
	polybar -q bottom -c "$DIR"/config.ini &
}

# Execute functions
backlight
launch_bar
