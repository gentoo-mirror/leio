# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sysprof/sysprof-1.0.9.ebuild,v 1.2 2008/02/29 18:00:10 carlo Exp $

inherit eutils linux-mod autotools git

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://www.daimi.au.dk/~sandmann/sysprof/"
EGIT_REPO_URI="git://people.freedesktop.org/~sandmann/sysprof"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	x11-libs/pango
	>=gnome-base/libglade-2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	MODULE_NAMES="sysprof-module(misc:${S}/module)"
	CONFIG_CHECK="PROFILING"
	PROFILING_ERROR="You need to enable Profiling support in your kernel. \
For this you need to enable 'Profiling support' under 'Instrumentation Support'. \
It is marked CONFIG_PROFILING in the config file"
	BUILD_TARGETS="all"
	linux-mod_pkg_setup
}

src_compile() {
	econf --disable-kernel-module || die
	emake || die
	linux-mod_src_compile
}

src_install() {
	make install DESTDIR="${D}" || die
	linux-mod_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO
	make_desktop_entry sysprof Sysprof sysprof-icon
}
