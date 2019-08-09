# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A collection of tools for managing StorijOS"
HOMEPAGE="https://storij.net"
LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~alpha arm64 amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

pkg_preinst() {
    doinitd "${FILESDIR}"/initd/*
    into /usr/local
    dobin "${FILESDIR}"/bin/*

    # installing specific storijos portage files
    insinto /etc/portage
    doins "${FILESDIR}"/make.conf_storijos

    insinto /etc/portage/package.keywords
    doins "${FILESDIR}"/storij-packages.keywords

    insinto /etc/portage/package.use
    doins "${FILESDIR}"/storij-packages.use

    insinto /etc/portage/package.mask
    doins "${FILESDIR}"/storij-packages.mask

    insinto /etc/portage/package.unmask
    doins "${FILESDIR}"/storij-packages.unmask

    insinto /etc/portage/sets
    doins "${FILESDIR}"/storijos*

    insinto /etc/local.d
    doins "${FILESDIR}"/mounter.start
    fperms 755 /etc/local.d/mounter.start
    
    dodir /boot/storij
    insinto /boot/storij
    doins "${FILESDIR}"/parameters.txt
    # we would change the permission when we run apache
    #fowners apache /boot/storij
    #fowners apache /boot/storij/parameters.txt
}
