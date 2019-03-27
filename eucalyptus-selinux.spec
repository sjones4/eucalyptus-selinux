Name:           eucalyptus-selinux
Version:        0.2.5
Release:        1%{?dist}
Summary:        SELinux policy for eucalyptus

License:        ISC
URL:            https://github.com/eucalyptus/eucalyptus-selinux
Source0:        %{name}-%{version}.tar.xz

BuildArch:      noarch

BuildRequires:  selinux-policy-devel

Requires:       libselinux-utils
Requires:       policycoreutils
Requires(post): policycoreutils
Requires(post): selinux-policy-base >= %{_selinux_policy_version}
Requires(postun): policycoreutils

%description
This package installs and sets up the SELinux policy security module
for eucalyptus.


%prep
%autosetup


%build
make


%install
install -Dp -m 0644 eucalyptus.if $RPM_BUILD_ROOT%{_datadir}/selinux/devel/include/contrib/eucalyptus.if
install -Dp -m 0644 eucalyptus.pp $RPM_BUILD_ROOT%{_datadir}/selinux/packages/eucalyptus.pp


%files
%license COPYING
%doc TODO
%{_datadir}/selinux/devel/include/contrib/eucalyptus.if
%{_datadir}/selinux/packages/eucalyptus.pp


%post
if /usr/sbin/selinuxenabled; then
    /usr/sbin/semodule -i %{_datadir}/selinux/packages/eucalyptus.pp >/dev/null || :
    if [ -e /etc/eucalyptus/nc-hooks ]; then
        /usr/sbin/restorecon /etc/eucalyptus/nc-hooks || :
    fi
fi


%postun
if [ $1 -eq 0 ] && /usr/sbin/selinuxenabled; then
    /usr/sbin/semodule -r eucalyptus >/dev/null || :
fi


%changelog
* Wed Mar 27 2019 Steve Jones <steve.jones@appscale.com> - 0.2.5-1
- Version bump (0.2.5)

* Fri Jul  6 2018 Steve Jones <steve.jones@appscale.com> - 0.2.4-1
- Version bump (0.2.4)

* Mon Apr 10 2017 Garrett Holmstrom <gholms@dxc.com> - 0.2.3-1
- Version bump (0.2.3)

* Mon Apr 10 2017 Garrett Holmstrom <gholms@dxc.com> - 0.1.19-1
- Version bump (0.1.19)

* Mon Jan 23 2017 Matt Bacchi <mbacchi@hpe.com> - 0.2.2-1
- Version bump (0.2.2)

* Sat Jan 21 2017 Garrett Holmstrom <gholms@hpe.com> - 0.2.1-1
- Version bump (0.2.1)

* Fri Jan 13 2017 Matt Bacchi <mbacchi@hpe.com> - 0.2.0-1
- Version bump (0.2.0)

* Wed Jan 11 2017 Garrett Holmstrom <gholms@hpe.com> - 0.1.18-1
- Version bump (0.1.18)

* Mon Jan  9 2017 Garrett Holmstrom <gholms@hpe.com> - 0.1.17-1
- Version bump (0.1.17)

* Thu Nov 17 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.16-1
- Version bump (0.1.16)

* Mon Oct 31 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.15-1
- Version bump (0.1.15)

* Wed Oct 26 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.14-1
- Version bump (0.1.14)
- Moved policy to /usr/share/selinux/packages

* Wed Jul  6 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.13-1
- Version bump (0.1.13)

* Wed Jun 29 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.12-1
- Version bump (0.1.12)

* Tue Jun 28 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.11-1
- Version bump (0.1.11)
- Relicensed to ISC

* Fri Jun 24 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.10-1
- Version bump (0.1.10)

* Thu Jun 16 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.9-1
- Version bump (0.1.9)

* Thu Jun  9 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.8-1
- Version bump (0.1.8)

* Thu Jun  9 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.7-1
- Version bump (0.1.7)

* Wed Jun  8 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.6-1
- Version bump (0.1.6)

* Tue Jun  7 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.5-1
- Version bump (0.1.5)

* Fri May 27 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.4-1
- Version bump (0.1.4)

* Wed May 25 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.3-1
- Version bump (0.1.3)

* Mon May 23 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.2-1
- Version bump (0.1.2)

* Mon May 23 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.1-1
- Version bump (0.1.1)

* Mon Apr  4 2016 Garrett Holmstrom <gholms@hpe.com> - 0.1.0-1
- Created
