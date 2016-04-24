bindir = /usr/bin

all:

install:
	install -d ${DESTDIR}/${bindir}
	install bin/ftpsync ${DESTDIR}/${bindir}/ftpsync
	install bin/runmirrors ${DESTDIR}/${bindir}/runmirrors

clean:
