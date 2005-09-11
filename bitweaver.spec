# Command to build: rpmbuild -ba --target noarch bitweaver.spec

%define name bitweaver
%define version 1.0
%define release 4

Summary: Modular CMS and PHP Application framework
Name: %{name}
Version: %{version}
Release: %{release}
Copyright: LGPL
URL: http://www.bitweaver.org
Packager: Stephan Borg <wolff_borg@yahoo.com.au>
AutoReqProv: no
Requires: php-mysql 
Group: Applications/Internet
Source: http://prdownloads.sourceforge.net/%{name}/%{name}_%{version}.%{release}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-root
Prefix: /var/www/html
Vendor: The TikiWiki Community

%description
Modular CMS framework with: tiki & pear wiki, cms, articles / news, phpBB forum bulletin board, blogs, image photo gallery, file sharing. tikiwiki upgrade. PHP,MySQL,Postgres,Oracle,FireBird,IIS/MS-SQL on Windows & Linux 

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/var/www/html
cd $RPM_BUILD_ROOT/var/www/html
tar xvzf $RPM_SOURCE_DIR/%{name}-%{version}.tar.gz
#tar xvzf $RPM_SOURCE_DIR/%{name}-%{version}%{release}.tar.gz
mv %{name}-%{version} tiki-1.8
#mv %{name}-%{version}%{release} tiki-1.8
# Change ownership and permissions
chown -R apache:apache *
cd tiki-1.8
find . -name "*.php" -exec chmod 644 {} \;
find . -name "*.sql" -exec chmod 644 {} \;
./setup.sh apache apache
# Remove unneeded files
rm -rf templates_c/*
rm -f modules/cache/*.cache
find . -name "CVS" -type d -print|xargs rm -rf
find . -name ".cvsignore" -exec rm -f {} \;

%clean
rm -rf $RPM_BUILD_ROOT

%preun
# Remove unneeded files
rm -rf templates_c/*
rm -f modules/cache/*.cache

%files
%defattr(-,apache,apache)
%config /var/www/html/tiki-1.8/db/tiki-db.php
#%doc /var/www/html/tiki-1.8/README
/*

%changelog

