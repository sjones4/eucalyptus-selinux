# Copyright 2018-2019 AppScale Systems, Inc
# Portions copyright 2016-2017 Ent. Services Development Corporation LP
#
# SPDX-License-Identifier: BSD-2-Clause

distdir = eucalyptus-selinux-$(shell sed -n '/^policy_module/s/.*, \([0-9.]*\).*/\1/p' eucalyptus.te)

include /usr/share/selinux/devel/Makefile

.PHONY: all clean dist distdir relabel

all: eucalyptus.pp

eucalyptus.if: eucalyptus.te eucalyptus.if.m4 eucalyptus.if.in
	rm -f $@
	@echo "# This is a generated file!  Instead of modifying this file, the" >> $@
	@echo "# $(notdir $@).in or $(notdir $@).m4 file should be modified." >> $@
	@echo "#" >> $@
	$(verbose) cat $@.in >> $@
	$(verbose) grep -E '^[[:blank:]]*eucalyptus_domain_template\(.*\)' eucalyptus.te \
		| $(M4) -D self_contained_policy $(M4PARAM) $(m4divert) eucalyptus.if.m4 $(m4undivert) - \
		| sed -e 's/dollarszero/\$$0/' -e 's/dollarsone/\$$1/' >> $@

relabel:
	restorecon -Riv /etc/eucalyptus /usr/lib/eucalyptus /usr/lib/systemd/system/euca* /usr/sbin/euca* /usr/share/eucalyptus /var/lib/eucalyptus /var/log/eucalyptus /var/run/eucalyptus

distdir: Makefile COPYING TODO eucalyptus.te eucalyptus.fc eucalyptus.if.m4 eucalyptus.if.in eucalyptus-selinux.spec
	rm -rf $(distdir)
	mkdir -p $(distdir)
	cp -pR $^ $(distdir)

dist: distdir
	mkdir -p dist
	tar -cJ -f dist/$(distdir).tar.xz $(distdir)
	rm -rf $(distdir)

clean:
	rm -rf dist
	rm -rf tmp
	rm -rf $(distdir)
	rm -f  eucalyptus.if
	rm -f  eucalyptus.pp
