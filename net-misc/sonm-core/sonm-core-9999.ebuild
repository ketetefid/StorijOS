# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI=https://github.com/sonm-io/core

inherit git-r3

KEYWORDS="amd64"
DESCRIPTION="The Decentralized Cloud Computing Market"
HOMEPAGE="https://${EGIT_REPO_URI}"
LICENSE="GPLv3"
SLOT="0"
DEPEND="dev-lang/go
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/sdl2-ttf
	app-emulation/docker"

src_compile() {
      snm_version=$(curl --silent "https://api.github.com/repos/sonm-io/core/releases/latest" | /bin/grep '"tag_name":' | /bin/sed -E 's/.*"([^"]+)".*/\1/')

      cd ${WORKDIR}/${P} && git checkout $snm_version && make build || die "A problem occured. Try to re-emerge sonm-core."
}

src_install() {
      dobin ${WORKDIR}/${P}/target/*
      dodir /var/log/sonm
      dodir /etc/sonm
      insinto /etc/sonm
      doins ${WORKDIR}/${P}/etc/*
      doinitd "${FILESDIR}"/initd/*
}

pkg_postinst() {
        elog "If this is your first setup, you need to:"
	elog "1. Run 'sonmcli_linux_x86_64 login' as your user to generate a new Ethereum address."
	elog "   This will create a new UTC/JSON keystore with a given passphrase that will be"
	elog "   your 'Admin address'."
	elog "2. Then you need to set the master address (generated via SONM-GUI located at"
	elog "   https://sonm-io.github.io/gui/#) and the admin address (generated by the login command)"
	elog "   in /etc/sonm/worker.yaml. Also specify the GPU settings in the file."
	elog "3. Edit /etc/sonm/node.yaml and put your keystore path and the passphrase in the 'ethereum'"
	elog "   section."
	elog "4. Set the keystore path and the passphrase in /etc/sonm/optimus.yaml and also set your"
	elog "   worker address (which will be generated when you run the worker and will need to be"
	elog "   confirmed in the SONM-GUI website)."
	elog ""
	elog "Finally, start the services sonm-worker and sonm-optimus."
 	elog "For more information, follow the setup at https://docs.sonm.com/getting-started/as-a-supplier"
	elog "You may find the relevant log files in /var/log/sonm directory."
}

