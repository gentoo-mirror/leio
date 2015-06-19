# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit xorg-2

DESCRIPTION="Drop-in replacement for xf86-video-fbdev and xf86-video-mali providing a better performance on ARM"
SRC_URI="https://github.com/ssvb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="arm"
IUSE=""

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xproto
	x11-proto/xf86driproto
"
# FIXME: driproto shouldn't really be necessary on rpi

src_prepare()
{
	xorg-2_src_prepare
	# Was added upstream for fixing compilations somewhere, but doesn't seemed needed
	# Not present with xorg-server[minimal]
	sed -i -e 's:#include "dri2.h"::g' "${S}"/src/sunxi_x_g2d.c || die
}
