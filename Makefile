bindir = /usr/bin
docdir = /usr/share/doc/ftpsync
examplesdir = ${docdir}/examples

all: bin/ftpsync.install bin/runmirrors.install

bin/%.install: bin/% bin/common
	sed \
		-e '\#^\. .*/common"# {' -e 'r bin/common' -e 'd' -e '};' \
		-e 's/^VERSION=.*$$/VERSION="${DEB_VERSION}"/;' \
		$^ > $@

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir}
	install bin/ftpsync.install ${DESTDIR}/${bindir}/ftpsync
	install bin/runmirrors.install ${DESTDIR}/${bindir}/runmirrors
	install -m644 \
		README \
		${DESTDIR}/${docdir}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}

clean:
	rm -f bin/ftpsync.install bin/runmirrors.install
