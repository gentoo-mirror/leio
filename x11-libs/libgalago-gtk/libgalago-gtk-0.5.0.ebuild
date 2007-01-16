# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GTK+ widgets for the Galago presence framework."
HOMEPAGE="http://www.galago-project.org"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.4
		>=x11-libs/gtk+-2.4
		>=dev-libs/libgalago-0.5.0
		>=sys-apps/dbus-0.36
		>=dev-libs/dbus-glib-0.36"

src_compile() {
	econf $(use_enable nls) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS
}
