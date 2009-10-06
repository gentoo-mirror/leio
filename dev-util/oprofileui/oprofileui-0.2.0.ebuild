# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

DESCRIPTION="User interface for system profiler OProfile"
HOMEPAGE="http://labs.o-hand.com/oprofileui/"
SRC_URI="http://labs.o-hand.com/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi +gtk +server"

RDEPEND=">=dev-libs/glib-2
	client? (
		>=x11-libs/gtk+-2
		>=gnome-base/libglade-2
		>=gnome-base/gnome-vfs-2
		>=gnome-base/gconf-2
		>=dev-libs/libxml2-2
	)
	avahi? ( net-dns/avahi )"
RDEPEND="${DEPEND}
	dev-util/oprofile
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

src_compile() {
	econf $(use_with avahi)
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc NEWS ChangeLog AUTHORS README
	rm -rf "${D}/usr/share/doc/${PN}"
}
