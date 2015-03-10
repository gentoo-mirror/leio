# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/${PN/-//}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://dev.gentoo.org/~leio/distfiles/${P}.tar.xz"
	KEYWORDS="~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="wayland"

RDEPEND="wayland? ( dev-libs/wayland )"
DEPEND="${RDEPEND}
	wayland? ( virtual/pkgconfig )"

# TODO:
# * port vcfiled init script
# * stuff is still installed to hardcoded /opt/vc location, investigate whether
#   anything else depends on it being there
# * live ebuild

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-2_src_unpack
	else
		default
		mv userland-*/ ${P}/ || die
	fi
}

src_prepare() {
	# init script for Debian, not useful on Gentoo
	sed -i "/DESTINATION \/etc\/init.d/,+2d" interface/vmcs_host/linux/vcfiled/CMakeLists.txt || die
	# wayland egl support
	epatch "${FILESDIR}"/next-resource-handle.patch
	epatch "${FILESDIR}"/wayland-wsys.patch
}

src_configure() {
	# FIXME: Fails to link apps using libmmal.so, due to libmmal_util getting filtered out and apps not linking to it
	append-ldflags $(no-as-needed)
	local mycmakeargs=(
		$(cmake-utils_use_build wayland WAYLAND)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doenvd "${FILESDIR}"/04${PN}

	# enable dynamic switching of the GL implementation
	dodir /usr/lib/opengl
	dosym ../../../opt/vc /usr/lib/opengl/${PN}

	# tell eselect opengl that we do not have libGL
	touch "${ED}"/opt/vc/.gles-only

	insinto /usr/lib/pkgconfig
	doins "${FILESDIR}"/bcm_host.pc
	doins "${FILESDIR}"/egl.pc
	doins "${FILESDIR}"/glesv2.pc
	if use wayland; then
		# Missing wayland-egl version from the patch; claim 9.0 (a mesa version) for now, so gst-plugins-bad wayland-egl check is happy
		sed -i -e 's/Version:  /Version: 9.0/' "${ED}"/opt/vc/lib/pkgconfig/wayland-egl.pc
		doins "${ED}"/opt/vc/lib/pkgconfig/wayland-egl.pc # Maybe move?
	fi
}
