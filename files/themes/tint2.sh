#!/usr/bin/env bash

## Copyright (C) 2020-2024 Aditya Shakya <adi1090x@gmail.com>

## Current Theme
STYLE="default"

## Launch tint2 with selected theme
launch_bar() {
	# Terminate already running bar instances
	killall -q tint2

	# Wait until the processes have been shut down
	while pgrep -u $UID -x tint2 >/dev/null; do sleep 1; done

	# Launch the bar
	tint2 -c "$HOME"/.config/openbox/themes/"$STYLE"/tint2/tint2rc &
}

# Execute function
launch_bar
