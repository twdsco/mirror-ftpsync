include /usr/share/dpkg/pkg-info.mk

bindir = /usr/bin
docdir = /usr/share/doc/ftpsync
examplesdir = ${docdir}/examples

SCRIPTS = bin/ftpsync bin/ftpsync-cron bin/rsync-ssl-tunnel bin/runmirrors

all: $(SCRIPTS:%=%.install) $(SCRIPTS:%=%.install-tar)

bin/%.install: bin/% bin/common
	sed -r \
		-e '/## INCLUDE COMMON$$/ {' \
		-e 'r bin/common' \
		-e 'c VERSION="${DEB_VERSION}"' \
		-e '};' \
		$< > $@

bin/%.install-tar: bin/% bin/common bin/include-tar
	sed -r \
		-e '/## INCLUDE COMMON$$/ {' \
		-e 'r bin/common' \
		-e 'r bin/include-tar' \
		-e 'c VERSION="${DEB_VERSION}"' \
		-e '};' \
		$< > $@

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir}
	install bin/ftpsync.install ${DESTDIR}/${bindir}/ftpsync
	install bin/ftpsync-cron.install ${DESTDIR}/${bindir}/ftpsync-cron
	install bin/rsync-ssl-tunnel.install ${DESTDIR}/${bindir}/rsync-ssl-tunnel
	install bin/runmirrors.install ${DESTDIR}/${bindir}/runmirrors
	install -m644 \
		README.md \
		${DESTDIR}/${docdir}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}

install-tar:
	install -d ${DESTDIR}/bin ${DESTDIR}/etc ${DESTDIR}/log
	install bin/ftpsync.install-tar ${DESTDIR}/bin/ftpsync
	install bin/ftpsync-cron.install-tar ${DESTDIR}/bin/ftpsync-cron
	install bin/rsync-ssl-tunnel.install-tar ${DESTDIR}/bin/rsync-ssl-tunnel
	install bin/runmirrors.install ${DESTDIR}/bin/runmirrors
	install -m644 \
		README.md \
		${DESTDIR}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/etc

clean:
	rm -f $(SCRIPTS:%=%.install) $(SCRIPTS:%=%.install-tar)
