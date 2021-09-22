#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# Column_circle     Column_square     Column_rounded     Column_alt
# Card_circle     	Card_square       Card_rounded       Card_alt
# Dock_circle     	Dock_square       Dock_rounded       Dock_alt
# Drop_circle     	Drop_square       Drop_rounded       Drop_alt
# Full_circle     	Full_square       Full_rounded       Full_alt
# Row_circle      	Row_square        Row_rounded        Row_alt

## Default
DIR="default"
STYLE="powermenu"

rofi_command="rofi -theme $HOME/.config/openbox/rofi/$DIR/$STYLE.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
if [[ "$DIR" == "powermenus" ]]; then
	shutdown=""
	reboot=""
	lock=""
	suspend=""
	logout=""
	ddir="$HOME/.config/openbox/rofi/$DIR"
else
	# Buttons
	layout=`cat $HOME/.config/openbox/rofi/$DIR/powermenu.rasi | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/'`
	if [[ "$layout" == "TRUE" ]]; then
		shutdown=""
		reboot=""
		lock=""
		suspend=""
		logout=""
	else
		shutdown=" Shutdown"
		reboot=" Restart"
		lock=" Lock"
		suspend=" Sleep"
		logout=" Logout"
	fi
	ddir="$HOME/.config/openbox/rofi/dialogs"
fi

# Ask for confirmation
rdialog () {
rofi -dmenu\
    -i\
    -no-fixed-num-lines\
    -p "Are You Sure? : "\
    -theme "$ddir/confirm.rasi"
}

# Display Help
show_msg() {
	rofi -theme "$ddir/askpass.rasi" -e "Options : yes / no / y / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $reboot)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl reboot
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $lock)
        betterlockscreen --lock
        ;;
    $suspend)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			mpc -q pause
			amixer set Master mute
			betterlockscreen --suspend
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $logout)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			openbox --exit
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
esac

