include /usr/share/dpkg/pkg-info.mk

bindir = /usr/bin
docdir = /usr/share/doc/ftpsync
examplesdir = ${docdir}/examples
mandir = /usr/share/man
man1dir = ${mandir}/man1
man5dir = ${mandir}/man5

MAN1 = ftpsync ftpsync-cron rsync-ssl-tunnel runmirrors
MAN5 = ftpsync.conf runmirrors.conf runmirrors.mirror
SCRIPTS = ftpsync ftpsync-cron rsync-ssl-tunnel runmirrors
ALL = $(MAN1:%=doc/%.1) $(MAN5:%=doc/%.5) $(SCRIPTS:%=bin/%.install) $(SCRIPTS:%=bin/%.install-tar) $(SCRIPTS:%=bin/%.install-docker)

all: $(ALL)

define expand
	sed -r \
		-e '/## INCLUDE COMMON$$/ {' \
		-e 'r bin/common' \
		-e 'r bin/include-$(1)' \
		-e 'c VERSION="${DEB_VERSION}"' \
		-e '};' \
		$< > $@
endef

bin/%.install: bin/% bin/common bin/include-install
	$(call expand,install)

bin/%.install-tar: bin/% bin/common bin/include-tar
	$(call expand,tar)

bin/%.install-docker: bin/% bin/common bin/include-docker
	$(call expand,docker)

doc/%: doc/%.md
	pandoc -s -t man -o $@ $<

define install_bin
install -D bin/ftpsync.$(1) $(2)/ftpsync
install -D bin/ftpsync-cron.$(1) $(2)/ftpsync-cron
install -D bin/rsync-ssl-tunnel.$(1) $(2)/rsync-ssl-tunnel
install -D bin/runmirrors.$(1) $(2)/runmirrors
endef

install:
	$(call install_bin,install,${DESTDIR}/${bindir})
	install -D -m644 -t ${DESTDIR}/${docdir} \
		README.md
	install -D -m644 -t ${DESTDIR}/${examplesdir} \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample
	install -D -m644 -t ${DESTDIR}/${man1dir} ${MAN1:%=doc/%.1}
	install -D -m644 -t ${DESTDIR}/${man5dir} ${MAN5:%=doc/%.5}

install-tar:
	$(call install_bin,install-tar,${DESTDIR}/bin/)
	install -D -m644 -t ${DESTDIR} \
		README.md
	install -D -m644 -t ${DESTDIR}/etc \
		etc/ftpsync.conf.sample \
		etc/runmirrors.conf.sample \
		etc/runmirrors.mirror.sample
	install -D -m644 -t ${DESTDIR}/doc ${MAN1:%=doc/%.1.md} ${MAN5:%=doc/%.5.md}

install-docker:
	$(call install_bin,install-docker,${DESTDIR}/bin/)

clean:
	rm -f $(ALL)
