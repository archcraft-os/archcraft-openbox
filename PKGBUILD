# Maintainer: Aditya Shakya <adi1090x@gmail.com>

pkgname=archcraft-openbox
pkgver=3.0
pkgrel=0
pkgdesc="Openbox WM Configurations for Archcraft"
url="https://github.com/archcraft-os/archcraft-openbox"
arch=('any')
license=('GPL3')
makedepends=()
depends=('openbox' 'obconf'
		'obmenu-generator' 'perl-linux-desktopfiles'
		'pastel' 'python-pywal'
		'pulsemixer' 'light' 'xcolor'
		'xfce4-settings' 'xfce4-power-manager' 'xfce4-terminal'
		'nitrogen' 'alacritty' 'thunar' 'geany'
		'rofi' 'polybar' 'dunst'
		'mpd' 'mpc' 'ffmpeg'
		'maim' 'xclip' 'viewnior'
		'ksuperkey' 
		'betterlockscreen'
		'networkmanager-dmenu-git'
		'xorg-xsetroot'
		'xmlstarlet'
		'yad'
)
conflicts=('archcraft-openbox-premium')
provides=("${pkgname}")
options=(!strip !emptydirs)
install="${pkgname}.install"

prepare() {
	cp -af ../files/. ${srcdir}
}

package() {
	local _sharedir=${pkgdir}/usr/share/archcraft/openbox
	local _configdir=${pkgdir}/etc/skel/.config
	local _obdir=${_configdir}/openbox
	local _thdir=${_configdir}/openbox-themes

	mkdir -p "$_sharedir" && mkdir -p "$_configdir"
	mkdir -p "$_obdir" && mkdir -p "$_thdir"

	# Copy shared files & fix permissions
	cp -r ${srcdir}/icons 				"$_sharedir"
	cp -r ${srcdir}/menulib 			"$_sharedir"
	cp -r ${srcdir}/ob-random 			"$_sharedir"
	cp -r ${srcdir}/pipemenus 			"$_sharedir"
	chmod +x "$_sharedir"/pipemenus/*
	
	# Copy openbox specific configs
	cp -r ${srcdir}/alacritty 				"$_configdir"
	cp -r ${srcdir}/networkmanager-dmenu 	"$_configdir"
	cp -r ${srcdir}/nitrogen 				"$_configdir"
	cp -r ${srcdir}/obmenu-generator 		"$_configdir"
	cp -r ${srcdir}/plank 					"$_configdir"

	# Copy window manager configs
	cp -r ${srcdir}/scripts 				"$_obdir"
	chmod +x "$_obdir"/scripts/*
	
	install -Dm 755 autostart   		"$_obdir"/autostart
	install -Dm 644 environment			"$_obdir"/environment
	install -Dm 644 rc.xml				"$_obdir"/rc.xml
	install -Dm 644 menu-glyphs.xml		"$_obdir"/menu-glyphs.xml
	install -Dm 644 menu-icons.xml		"$_obdir"/menu-icons.xml
	install -Dm 644 menu-minimal.xml	"$_obdir"/menu-minimal.xml
	install -Dm 644 menu-simple.xml		"$_obdir"/menu-simple.xml

	# Copy openbox themes
	cp -r ${srcdir}/openbox-themes 		"$_configdir"
	chmod +x "$_thdir"/scripts/*
	chmod +x "$_thdir"/themes/polybar.sh
	chmod +x "$_thdir"/themes/easy/polybar/polywins.sh

	apply_files=(`find ${_thdir}/themes -type f | grep apply.sh`)
	for _afile in "${apply_files[@]}"; do
		chmod +x ${_afile}
	done

	launch_files=(`find ${_thdir}/themes -type f | grep launch.sh`)
	for _lfile in "${launch_files[@]}"; do
		chmod +x ${_lfile}
	done

	scripts_dir=(`find ${_thdir}/themes -type d | grep scripts`)
	for _script in "${scripts_dir[@]}"; do
		chmod +x ${_script}/*
	done
}
