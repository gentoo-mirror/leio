# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ffmpeg/gst-plugins-ffmpeg-0.10.2.ebuild,v 1.9 2007/09/26 16:11:01 armin76 Exp $

inherit flag-o-matic eutils autotools cvs

SLOT=0.10

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-ffmpeg.html"

ECVS_USER="anoncvs"
ECVS_SERVER="anoncvs.freedesktop.org:/cvs/gstreamer/"
ECVS_MODULE="gst-ffmpeg"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/gst-ffmpeg"

DEPEND=">=media-libs/gstreamer-0.10.13
	>=media-libs/gst-plugins-base-0.10.13
	>=dev-libs/liboil-0.3.6
	dev-util/pkgconfig"

src_unpack() {
	cvs_src_unpack
	ln -s "${WORKDIR}/mirror/ffmpeg" "${S}/gst-libs/ext/ffmpeg"
	ffmpeg_cvs_src_unpack
	cd "${S}"
	AT_M4DIR="${S}/common/m4" eautoreconf
}

ffmpeg_cvs_src_unpack() {
	ECVS_SERVER="anoncvs.freedesktop.org:/cvs/gstreamer"
	ECVS_MODULE="mirror/ffmpeg"
	cvs_src_unpack
}

src_compile() {
	# Restrictions taken from the mplayer ebuild
	# See bug #64262 for more info
	# let's play the filtration game!
	filter-flags -fPIE -fPIC -fstack-protector -fforce-addr -momit-leaf-frame-pointer -msse2 -msse3 -falign-functions -fweb
	# ugly optimizations cause MPlayer to cry on x86 systems!
	if use x86 ; then
		replace-flags -O0 -O2
		replace-flags -O3 -O2
	fi

	econf --disable-ffplay|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}

