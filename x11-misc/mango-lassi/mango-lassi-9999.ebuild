# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

EGIT_REPO_URI="http://git.0pointer.de/repos/mango-lassi.git"
EGIT_BOOTSTRAP="intltoolize --force --copy --automake && eautoreconf"

inherit git autotools eutils
DESCRIPTION="GNOME Input Sharing"

HOMEPAGE="http://0pointer.de/blog/projects/mango-lassi.html"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=sys-apps/dbus-1.1.1
	dev-libs/dbus-glib
	x11-libs/gtk+:2
	x11-libs/libXtst
	net-dns/avahi
	x11-libs/libnotify
	gnome-base/libglade"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	>=dev-util/intltool-0.35"

pkg_setup() {
	# dbus -> avahi-client, glib -> avahi-glib, glib/dbus -> avahi-ui, glib is always enabled in our avahi package
	built_with_use net-dns/avahi dbus || die "net-dns/avahi must be built with \"dbus\" USE flag"
}

src_unpack() {
	git_fetch
	cd "${S}"
	touch config.rpath
	sed -i -e 's/ACLOCAL_AMFLAGS = -I m4//' Makefile.am
	git_bootstrap
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
