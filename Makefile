include /usr/share/dpkg/pkg-info.mk

bindir = /usr/bin
docdir = /usr/share/doc/ftpsync
examplesdir = ${docdir}/examples
mandir = /usr/share/man
man1dir = ${mandir}/man1
man5dir = ${mandir}/man5

MAN1 = ftpsync ftpsync-cron rsync-ssl-tunnel runmirrors
MAN5 = ftpsync.conf runmirrors.conf runmirrors.mirror
SCRIPTS = bin/ftpsync bin/ftpsync-cron bin/rsync-ssl-tunnel bin/runmirrors

all: $(MAN1:%=doc/%.1) $(MAN5:%=doc/%.5) $(SCRIPTS:%=%.install) $(SCRIPTS:%=%.install-tar)

bin/%.install: bin/% bin/common
	sed -r \
		-e '/## INCLUDE COMMON$$/ {' \
		-e 'r bin/common' \
		-e 'r bin/include-install' \
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

doc/%: doc/%.md
	pandoc -s -t man -o $@ $<

define install_bin
install bin/ftpsync.$(1) $(2)/ftpsync
install bin/ftpsync-cron.$(1) $(2)/ftpsync-cron
install bin/rsync-ssl-tunnel.$(1) $(2)/rsync-ssl-tunnel
install bin/runmirrors.$(1) $(2)/runmirrors
endef

install:
	install -d ${DESTDIR}/${bindir} ${DESTDIR}/${examplesdir} ${DESTDIR}/${man1dir} ${DESTDIR}/${man5dir}
	$(call install_bin,install,${DESTDIR}/${bindir})
	install -m644 \
		README.md \
		${DESTDIR}/${docdir}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/${examplesdir}
	install -m644 ${MAN1:%=doc/%.1} ${DESTDIR}/${man1dir}
	install -m644 ${MAN5:%=doc/%.5} ${DESTDIR}/${man5dir}

install-tar:
	install -d ${DESTDIR}/bin ${DESTDIR}/doc ${DESTDIR}/etc ${DESTDIR}/log
	$(call install_bin,install-tar,${DESTDIR}/bin/)
	install -m644 \
		README.md \
		${DESTDIR}
	install -m644 \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample \
		${DESTDIR}/etc
	install -m644 ${MAN1:%=doc/%.1} ${MAN5:%=doc/%.5} ${DESTDIR}/doc

clean:
	rm -f $(MAN1:%=doc/%.1) $(MAN5:%=doc/%.5) $(SCRIPTS:%=%.install) $(SCRIPTS:%=%.install-tar)
