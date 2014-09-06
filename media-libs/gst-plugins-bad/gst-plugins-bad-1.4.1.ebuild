# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

GST_ORG_MODULE="gst-plugins-bad"
inherit autotools eutils flag-o-matic gstreamer

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="egl gles2 +introspection +orc rpi vnc wayland"

# FIXME: Some REQUIRED_USE dance for egl/gles2/rpi/wayland
# FIXME: Any flags needed on raspberypi-userland for wayland or egl?

# FIXME: we need to depend on mesa to avoid automagic on egl
# dtmf plugin moved from bad to good in 1.2
# X11 is automagic for now, upstream #709530
RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.2:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-1.2:${SLOT}[${MULTILIB_USEDEP}]
	egl? (
		rpi? ( media-libs/raspberrypi-userland )
		!rpi? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
		wayland? (
			!rpi? ( media-libs/mesa[egl,wayland] )
			rpi? ( media-libs/raspberrypi-userland )
		)
	)
	gles2? (
		rpi? ( media-libs/raspberrypi-userland )
		!rpi? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
	)
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )

	!<media-libs/gst-plugins-good-1.1:${SLOT}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_prepare() {
	# Make RPI egl stuff use pkg-config - https://bugzilla.gnome.org/733248
	epatch "${FILESDIR}"/egl-rpi-pkgconfig.patch
	eautoreconf
}

src_configure() {
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # (Bug #22249)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# For glimagesink on X11 we seem to want --enable-egl --enable-dispmanx
	# For glimagesink on Wayland we seem to want --enable-egl --enable-wayland and wayland-egl.pc (on RPi provided by raspberrypi-userland + added pkg-config files)
	# Figure out all the working combinations. e.g without --disable-glx on RPi, it could autodetect X11, yet not build the context. See gstglcontext.c
	local myconf
	myconf=""
	if use rpi; then
		myconf+=" --disable-glx --disable-x11"
	fi
	if use egl; then
		myconf+=" --enable-egl --enable-gl"
		if use wayland; then
			myconf+=" --enable-wayland"
		else
			myconf+=" $(use_enable rpi dispmanx)" # can we enable it on wayland too and is it egl dependent?
		fi
	else
		myconf+=" --disable-egl"
	fi

	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable orc) \
		$(use_enable vnc librfb) \
		--disable-examples \
		--disable-debug \
		$(use_enable gles2) \
		${myconf}
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
