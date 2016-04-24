bindir = /usr/bin
examplesdir = /usr/share/doc/ftpsync/examples

all:

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir}
	install bin/ftpsync ${DESTDIR}/${bindir}/ftpsync
	install bin/runmirrors ${DESTDIR}/${bindir}/runmirrors
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}

clean:
