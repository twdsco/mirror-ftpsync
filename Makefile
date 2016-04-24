bindir = /usr/bin
examplesdir = /usr/share/doc/ftpsync/examples

all: bin/ftpsync.install bin/runmirrors.install

bin/%.install: bin/% etc/common
	sed -e '\#^\. .*/common"# {' -e 'r etc/common' -e 'd' -e '}' $^ > $@

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir}
	install bin/ftpsync.install ${DESTDIR}/${bindir}/ftpsync
	install bin/runmirrors.install ${DESTDIR}/${bindir}/runmirrors
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}

clean:
	rm -f bin/ftpsync.install bin/runmirrors.install
