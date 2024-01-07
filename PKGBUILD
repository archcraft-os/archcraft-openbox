# Maintainer: Aditya Shakya <adi1090x@gmail.com>

pkgname=archcraft-openbox
pkgver=6.0
pkgrel=1
pkgdesc="Openbox Configurations for Archcraft"
arch=('any')
url="https://github.com/archcraft-os/archcraft-openbox"
license=('GPL3')
depends=('openbox' 'obconf' 'obmenu-generator' 'perl-linux-desktopfiles'
		'pulsemixer' 'light' 'polybar' 'tint2' 'rofi' 'dunst' 'nitrogen'
		'pastel' 'python-pywal' 'xfce4-settings' 'xmlstarlet' 'python-lxml'
)
optdepends=('alacritty: default terminal emulator'
			'thunar: default file manager'
			'geany: default text editor'
			'firefox: default web browser'
			'viewnior: default image viewer'
			'betterlockscreen: default lockscreen'
			'ksuperkey: allows you to open the application launcher using the Super key'
			'networkmanager-dmenu-git: control NetworkManager via rofi'
			'mpd: server-side application for playing music, used in statusbars and scripts'
			'mpc: minimalist command line interface to MPD'
			'ffmpeg: complete solution to record, convert and stream audio and video, used in screenrecord scripts'
			'maim: utility to take a screenshot, used in screenshot scripts'
			'xclip: command line interface to the X11 clipboard'
			'xcolor: lightweight color picker for X11'
			'xfce4-power-manager: power manager'
			'xfce4-terminal: alternate terminal if alacritty does not work for you'
			'xorg-xsetroot: fix cursor theming, set root background'
			'yad: display graphical dialogs from shell scripts'
)
conflicts=('archcraft-openbox-premium')
options=(!strip !emptydirs)
install="${pkgname}.install"

prepare() {
	cp -af ../files/. "$srcdir"
}

package() {
	local _sharedir="$pkgdir"/usr/share/archcraft/openbox
	local _configdir="$pkgdir"/etc/skel/.config
	local _obdir="$_configdir"/openbox

	mkdir -p "$_sharedir" && mkdir -p "$_configdir" && mkdir -p "$_obdir"

	# Copy shared files & set permissions
	cp -r "$srcdir"/icons 					"$_sharedir"
	cp -r "$srcdir"/menulib 				"$_sharedir"
	cp -r "$srcdir"/ob-random 				"$_sharedir"
	cp -r "$srcdir"/pipemenus 				"$_sharedir"
	chmod +x "$_sharedir"/pipemenus/*
	
	# Copy openbox specific configs
	cp -r "$srcdir"/alacritty 				"$_configdir"
	cp -r "$srcdir"/networkmanager-dmenu 	"$_configdir"
	cp -r "$srcdir"/nitrogen 				"$_configdir"
	cp -r "$srcdir"/obmenu-generator 		"$_configdir"
	cp -r "$srcdir"/plank 					"$_configdir"

	# Copy window manager configs
	install -Dm 755 autostart   			"$_obdir"/autostart
	install -Dm 644 environment				"$_obdir"/environment
	install -Dm 644 menu-glyphs.xml			"$_obdir"/menu-glyphs.xml
	install -Dm 644 menu-icons.xml			"$_obdir"/menu-icons.xml
	install -Dm 644 menu-minimal.xml		"$_obdir"/menu-minimal.xml
	install -Dm 644 menu-simple.xml			"$_obdir"/menu-simple.xml
	install -Dm 644 rc.xml					"$_obdir"/rc.xml

	# Copy openbox scripts
	cp -r "$srcdir"/scripts 				"$_obdir"
	chmod +x "$_obdir"/scripts/*

	# Copy openbox themes
	cp -r "$srcdir"/themes 					"$_obdir"
	chmod +x "$_obdir"/themes/{launch-bar,polybar,tint2}.sh

	apply_files=(`find ${_obdir}/themes -type f | grep apply.sh`)
	for _afile in "${apply_files[@]}"; do
		chmod +x ${_afile}
	done

	launch_files=(`find ${_obdir}/themes -type f | grep launch.sh`)
	for _lfile in "${launch_files[@]}"; do
		chmod +x ${_lfile}
	done

	scripts_dir=(`find ${_obdir}/themes -type d | grep scripts`)
	for _script in "${scripts_dir[@]}"; do
		chmod +x ${_script}/*
	done	
}
