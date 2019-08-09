# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_SRC=gitlab.com/NebulousLabs/Sia
EGO_PN=${EGO_SRC}/...


inherit golang-build golang-vcs
KEYWORDS="arm64 amd64"
DESCRIPTION="The Decentralized Cloud Storage Based on Blockchain"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="MIT"
SLOT="0"
DEPEND="dev-lang/go dev-vcs/git"

src_compile() {
      sia_version=$(curl --silent "https://api.gitlab.com/repos/NebulousLabs/Sia/releases/latest" | /bin/grep '"tag_name":' | /bin/sed -E 's/.*"([^"]+)".*/\1/')
      go clean gitlab.com/NebulousLabs/Sia/...
      go get -d gitlab.com/NebulousLabs/Sia/...
      cd ${HOME}/go/src/gitlab.com/NebulousLabs/Sia/ && git checkout $sia_version && make release || die "A problem occured. Try to re-emerge sia."
}

src_install() {
      dobin ${HOME}/go/bin/*
      doconfd "${FILESDIR}"/confd/siad
      doinitd "${FILESDIR}"/initd/siad
}
