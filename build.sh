#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Script Termination
exit_on_signal_SIGINT () {
    { printf "\n\n%s\n" "Script interrupted." 2>&1; echo; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf "\n\n%s\n" "Script terminated." 2>&1; echo; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

# Build packages
build_pkg () {
	echo -e "\nBuilding Package - \n"
	makepkg -s && rm -rf src pkg
	
	RDIR='../packages/x86_64'
	if [[ -d "$RDIR" ]]; then
		mv -f *.pkg.tar.zst "$RDIR"
		echo -e "\nPackage moved to Repository.\n[!] Don't forget to update the database.\n"
	fi
}

# Execute
build_pkg
