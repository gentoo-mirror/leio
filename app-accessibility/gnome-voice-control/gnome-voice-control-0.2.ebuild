# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A speech recognizer to control the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeVoiceControl/"

SRC_URI="http://www.comp.ufscar.br/~raphael18/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=gnome-base/gnome-panel-2
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-base-0.10
	x11-libs/libwnck
	gnome-extra/at-spi
	app-accessibility/sphinx2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35"
