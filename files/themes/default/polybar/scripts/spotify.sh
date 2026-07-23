#!/usr/bin/env bash

## Copyright (C) 2020-2026 Aditya Shakya <adi1090x@gmail.com>
##
## Spotify script for waybar --------------------------------

spotify_status=`playerctl -p spotify status 2>/dev/null`
md_cmd="playerctl -p spotify metadata"

if [[ "$spotify_status" = "Playing" ]]; then
	if [[ "`$md_cmd title`" == "Advertisement" ]]; then
		echo -e " Stupid Ads!"; exit 0
	else
		echo -e " $($md_cmd artist) - $($md_cmd title)"; exit 0
	fi
elif [[ "$spotify_status" = "Paused" ]]; then
    echo -e " $($md_cmd artist) - $($md_cmd title)"; exit 0
else
	echo -e "󰎊 Spotify Offline!"; exit 1
fi
