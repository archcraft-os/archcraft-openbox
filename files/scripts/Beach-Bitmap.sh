#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Dirs #############################################
openbox_path="$HOME/.config/openbox"
polybar_path="$HOME/.config/openbox/polybar"
rofi_path="$HOME/.config/openbox/rofi"
terminal_path="$HOME/.config/alacritty"
xfce_term_path="$HOME/.config/xfce4/terminal"
geany_path="$HOME/.config/geany"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
set_wallpaper() {
	nitrogen --save --set-zoom-fill /usr/share/backgrounds/"$1"
}

# polybar -----------------------------------
change_polybar() {
	sed -i -e "s/STYLE=.*/STYLE=\"$1\"/g" 			${polybar_path}/launch.sh
	sed -i -e "s/font-0 = .*/font-0 = \"$2\"/g" 	${polybar_path}/"$1"/config.ini
}

# rofi --------------------------------------
change_rofi() {		
	sed -i -e "s/STYLE=.*/STYLE=\"$1\"/g" 						${rofi_path}/bin/music ${rofi_path}/bin/network ${rofi_path}/bin/screenshot ${rofi_path}/bin/runner
	sed -i -e "s/DIR=.*/DIR=\"$1\"/g" 							${rofi_path}/bin/launcher ${rofi_path}/bin/powermenu
	sed -i -e 's/STYLE=.*/STYLE="launcher"/g' 					${rofi_path}/bin/launcher
	sed -i -e 's/STYLE=.*/STYLE="powermenu"/g' 					${rofi_path}/bin/powermenu
	sed -i -e "s/font:.*/font:				 	\"$2\";/g" 		${rofi_path}/"$1"/font.rasi

	sed -i -e "s/font:.*/font:				 	\"$2\";/g" 			${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi
	sed -i -e "s/border:.*/border:					$3;/g" 			${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi
	sed -i -e "s/border-radius:.*/border-radius:          $4;/g" 	${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi

	if [[ -f "$HOME"/.config/rofi/config.rasi ]]; then
		sed -i -e "s/icon-theme:.*/icon-theme:         \"$5\";/g" 	"$HOME"/.config/rofi/config.rasi
	fi

	cat > ${rofi_path}/dialogs/colors.rasi <<- _EOF_
	/* Color-Scheme */

	* {
        BG:    #141c21ff;
        FG:    #93a1a1ff;
        BDR:   #2587ccff;
	}
	_EOF_
}

# network manager ---------------------------
change_nm() {
	sed -i -e "s#dmenu_command = .*#dmenu_command = rofi -dmenu -theme ~/.config/openbox/rofi/$1/networkmenu.rasi#g" "$HOME"/.config/networkmanager-dmenu/config.ini
}

# terminal ----------------------------------
change_terminal() {
	sed -i -e "s/family: .*/family: \"$1\"/g" 		${terminal_path}/fonts.yml
	sed -i -e "s/size: .*/size: $2/g" 				${terminal_path}/fonts.yml

	cat > ${terminal_path}/colors.yml <<- _EOF_
		## Colors configuration
		colors:
		  # Default colors
		  primary:
		    background: '0x141c21'
		    foreground: '0x93a1a1'

		  # Normal colors
		  normal:
		    black:   '0x263640'
		    red:     '0xd12f2c'
		    green:   '0x819400'
		    yellow:  '0xb08500'
		    blue:    '0x2587cc'
		    magenta: '0x696ebf'
		    cyan:    '0x289c93'
		    white:   '0xbfbaac'

		  # Bright colors
		  bright:
		    black:   '0x4a697d'
		    red:     '0xfa3935'
		    green:   '0xa4bd00'
		    yellow:  '0xd9a400'
		    blue:    '0x2ca2f5'
		    magenta: '0x8086e8'
		    cyan:    '0x33c5ba'
		    white:   '0xfdf6e3'
	_EOF_
}

# xfce terminal -----------------------------
change_xfce_terminal() {
	sed -i -e "s/FontName=.*/FontName=$1/g" 							${xfce_term_path}/terminalrc
	sed -i -e 's/ColorForeground=.*/ColorForeground=#9393a1a1a1a1/g' 	${xfce_term_path}/terminalrc
	sed -i -e 's/ColorBackground=.*/ColorBackground=#14141c1c2121/g' 	${xfce_term_path}/terminalrc
	sed -i -e 's/ColorCursor=.*/ColorCursor=#9393a1a1a1a1/g' 			${xfce_term_path}/terminalrc
	sed -i -e 's/ColorPalette=.*/ColorPalette=#262636364040;#d1d12f2f2c2c;#818194940000;#b0b085850000;#25258787cccc;#69696e6ebfbf;#28289c9c9393;#bfbfbabaacac;#4a4a69697d7d;#fafa39393535;#a4a4bdbd0000;#d9d9a4a40000;#2c2ca2a2f5f5;#80808686e8e8;#3333c5c5baba;#fdfdf6f6e3e3/g' ${xfce_term_path}/terminalrc
}

# geany -------------------------------------
change_geany() {
	sed -i -e "s/color_scheme=.*/color_scheme=$1.conf/g" 	${geany_path}/geany.conf
	sed -i -e "s/editor_font=.*/editor_font=$2/g" 			${geany_path}/geany.conf
}

# gtk theme, icons and fonts ----------------
change_appearance() {
	xfconf-query -c xsettings -p /Net/ThemeName -s "$1"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "$2"
	xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$3"
	xfconf-query -c xsettings -p /Gtk/FontName -s "$4"
	
	if [[ -f "$HOME"/.icons/default/index.theme ]]; then
		sed -i -e "s/Inherits=.*/Inherits=$3/g" "$HOME"/.icons/default/index.theme
	fi	
}

# openbox -----------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="$1"
	layout="$2"
	font="$3"
	fontsize="$4"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	# Openbox Menu Style
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:menu/a:file' -v "$5" "$config"

	# Margins
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 20 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 20 "$config"
}

# dunst -------------------------------------
change_dunst() {
	sed -i -e "s/geometry = .*/geometry = \"$1\"/g" 	${dunst_path}/dunstrc
	sed -i -e "s/font = .*/font = $2/g" 				${dunst_path}/dunstrc
	sed -i -e "s/frame_width = .*/frame_width = $3/g" 	${dunst_path}/dunstrc

	sed -i '/urgency_low/Q' ${dunst_path}/dunstrc
	cat >> ${dunst_path}/dunstrc <<- _EOF_
		[urgency_low]
		timeout = 2
		background = "#141c21"
		foreground = "#93a1a1"
		frame_color = "#141c21"

		[urgency_normal]
		timeout = 5
		background = "#141c21"
		foreground = "#93a1a1"
		frame_color = "#141c21"

		[urgency_critical]
		timeout = 0
		background = "#141c21"
		foreground = "#d42434"
		frame_color = "#141c21"
	_EOF_

	pkill dunst && dunst &
}

# Plank -------------------------------------
change_dock() {
	cat > "$HOME"/.cache/plank.conf <<- _EOF_
		[dock1]
		alignment='center'
		auto-pinning=true
		current-workspace-only=false
		dock-items=['xfce-settings-manager.dockitem', 'Alacritty.dockitem', 'thunar.dockitem', 'firefox.dockitem', 'geany.dockitem']
		hide-delay=0
		hide-mode='auto'
		icon-size=32
		items-alignment='center'
		lock-items=false
		monitor=''
		offset=80
		pinned-only=false
		position='right'
		pressure-reveal=false
		show-dock-item=false
		theme='Transparent'
		tooltips-enabled=true
		unhide-delay=0
		zoom-enabled=true
		zoom-percent=120
	_EOF_
}

# compositor --------------------------------
compositor() {
	comp_file="$HOME/.config/picom.conf"

	backend="$1"
	cradius="$2"
	shadow_r="$(echo $3 | cut -d' ' -f1)"
	shadow_o="$(echo $3 | cut -d' ' -f2)"
	shadow_x="$(echo $3 | cut -d' ' -f3)"
	shadow_y="$(echo $3 | cut -d' ' -f4)"
	method="$(echo $4 | cut -d' ' -f1)"
	strength="$(echo $4 | cut -d' ' -f2)"

	# Rounded Corners
	sed -i -e "s/backend = .*/backend = \"$backend\";/g" 				${comp_file}
	sed -i -e "s/corner-radius = .*/corner-radius = $cradius;/g" 		${comp_file}	

	# Shadows
	sed -i -e "s/shadow-radius = .*/shadow-radius = $shadow_r;/g" 		${comp_file}
	sed -i -e "s/shadow-opacity = .*/shadow-opacity = $shadow_o;/g" 	${comp_file}
	sed -i -e "s/shadow-offset-x = .*/shadow-offset-x = $shadow_x;/g" 	${comp_file}
	sed -i -e "s/shadow-offset-y = .*/shadow-offset-y = $shadow_y;/g" 	${comp_file}

	# Blur
	sed -i -e "s/backend = .*/backend = \"$backend\";/g" 				${comp_file}
	sed -i -e "s/method = .*/method = \"$method\";/g" 					${comp_file}
	sed -i -e "s/strength = .*/strength = $strength;/g" 				${comp_file}
}

# notify ------------------------------------
notify_user() {
	local style=`basename $0` 
	dunstify -u normal --replace=699 -i /usr/share/archcraft/icons/dunst/themes.png "Applying Style : ${style%.*}"
}

## Execute Script ---------------------------
notify_user

# funct WALLPAPER
set_wallpaper 'beach.jpg'

# funct STYLE FONT
change_polybar 'beach-bitmap' 'Terminus:size=8;3' && "$polybar_path"/launch.sh

# funct STYLE FONT BORDER BORDER-RADIUS ICON (Change colors in funct)
change_rofi 'beach-bitmap' 'Terminus 9' '0px' '0px' 'Numix-Apps'

# funct STYLE (network manager applet)
change_nm 'beach-bitmap'

# funct FONT SIZE (Change colors in funct)
change_terminal 'Terminus' '9'

# funct FONT (Change colors in funct)
change_xfce_terminal 'Terminus 9'

# funct SCHEME FONT
change_geany 'beach' 'Terminus 9'

# funct THEME ICON CURSOR FONT
change_appearance 'Arc' 'Arc-Circle' 'Future' 'Terminus 9'

# funct THEME LAYOUT FONT SIZE (Change margin in funct)
obconfig 'Arc-Bitmap' 'CLM' 'Terminus' '9' 'menu-simple.xml' && openbox --reconfigure

# funct GEOMETRY FONT BORDER (Change colors in funct)
change_dunst '300x60-20-50' 'Terminus 9' '0'

# Paste settings in funct (PLANK)
change_dock && cat "$HOME"/.cache/plank.conf | dconf load /net/launchpad/plank/docks/

# Change compositor settings
#compositor 'glx' '0' '14 0.30 -12 -12' 'none 0'
