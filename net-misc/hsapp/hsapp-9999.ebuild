# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_SRC=github.com/HyperspaceApp/Hyperspace
EGO_PN=${EGO_SRC}/...


inherit golang-build golang-vcs
KEYWORDS="arm64 amd64"
DESCRIPTION="The Decentralized Cloud Storage Based on Blockchain Forked from Sia"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="MIT"
SLOT="0"
DEPEND="dev-lang/go"

src_compile() {
      hs_version=$(curl --silent "https://api.github.com/repos/HyperspaceApp/Hyperspace/releases/latest" | /bin/grep '"tag_name":' | /bin/sed -E 's/.*"([^"]+)".*/\1/')
      go clean github.com/HyperspaceApp/Hyperspace/...
      go get -d github.com/HyperspaceApp/Hyperspace/...
      cd ${HOME}/go/src/github.com/HyperspaceApp/Hyperspace/ && git checkout $hs_version && make release || die "A problem occured. Try to re-emerge hsapp."
}

src_install() {
      dobin ${HOME}/go/bin/*
      doconfd "${FILESDIR}"/confd/hsd
      doinitd "${FILESDIR}"/initd/hsd
}
