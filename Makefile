# Copyright (c) 2016-2017 Hewlett Packard Enterprise Development LP
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
