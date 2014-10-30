#!/bin/sh

HOME_DIR=$(dirname $(readlink -f $0))
du -s $HOME_DIR/htdocs 2>&1 | grep -q "^[0-9][0-9]*" || HOME_DIR=$HOME_DIR/shellgui
DOCUMENT_ROOT=$HOME_DIR/htdocs
echo $PATH | sed 's/:/\n/g' | grep -q "^/sbin$" || export PATH=$PATH:/sbin
echo $PATH | sed 's/:/\n/g' | grep -q "^/bin$" || export PATH=$PATH:/bin
echo $PATH | sed 's/:/\n/g' | grep -q "^/usr/bin$" || export PATH=$PATH:/usr/bin
echo $PATH | sed 's/:/\n/g' | grep -q "^/usr/sbin$" || export PATH=$PATH:/usr/sbin
echo $PATH | sed 's/:/\n/g' | grep -q "^/usr/local/bin$" || export PATH=$PATH:/usr/local/bin
echo $PATH | sed 's/:/\n/g' | grep -q "^/usr/local/sbin$" || export PATH=$PATH:/usr/local/sbin
PATH=$PATH:$HOME_DIR/bin
if
[ `grep "^$(whoami):" /etc/passwd | cut -d: -f4` -ne 0 ]
then
echo "must run in user of root group"
exit 1
fi
OS=`cat /etc/issue | sed -n 1p | awk -F '\' {'print $1'}`
if
[ -z "$OS" ]
then
	if
	[ -f /etc/system-release ]
	then
	OS=`cat /etc/system-release | sed -n 1p`
	elif
	[ -f /etc/openwrt_release ]
	then
	eval  /etc/openwrt_release
	OS=$DISTRIB_DESCRIPTION
	else
	OS="Unknow"
	fi
fi

if
echo $OS | grep -qi "centos"
then
distribution=centos-$(echo $OS | grep -Po '[0-9].*[0-9]' | sed 's/\..*/\.x/g')
elif
echo $OS | grep -qi "debian"
then
distribution=debian-$(echo $OS | grep -Po '[0-9].*[0-9]' | sed 's/\..*/\.x/g')
elif
echo $OS | grep -qi "ubuntu"
then
distribution=ubuntu-$(echo $OS | grep -Po '[0-9].*[0-9]' | sed 's/\..*/\.x/g')
else
distribution=unknow
fi
ask()
{
echo -n "Bind to(127.0.0.1/0.0.0.0/Your IP:)"
read IP
if
[ "$IP" = "0.0.0.0" ] || ifconfig | grep -q "$IP"
then
echo "Use IP:$IP"
else
echo "Wrong IP!!" && exit 2
fi
echo -n "Bind port(1443/8443/etc:)"
read PORT
if
echo "$PORT" | grep -qE "^[0-9]+$"
then
echo "Use PORT:$PORT"
else
echo "Wrong Port!!" && exit 2
fi
}
download_shellgui()
{
if
du -s $HOME_DIR/htdocs 2>&1 | grep -q "[0-9][0-9]*"
then
echo "Already have docs"
else
curl -k -L "https://github.com/ShellGui/shellgui/archive/master.zip" -o $HOME_DIR/sources/shellgui-master.zip || \
wget --no-check-certificate "https://github.com/ShellGui/shellgui/archive/master.zip" -O $HOME_DIR/sources/shellgui-master.zip
fi
}
do_downloads()
{
if
[ -f $HOME_DIR/sources/lighttpd-1.4.35.tar.gz ] && [ `md5sum $HOME_DIR/sources/lighttpd-1.4.35.tar.gz | awk {'print $1'}` = "69057685df672218d45809539b874917" ]
then
echo "lighttpd-1.4.35.tar.gz checked"
else
curl -k -L "http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.35.tar.gz" -o $HOME_DIR/sources/lighttpd-1.4.35.tar.gz
do_downloads
return 0
fi

if
[ -f $HOME_DIR/sources/apache_1.3.42.tar.gz ] && [ `md5sum $HOME_DIR/sources/apache_1.3.42.tar.gz | awk {'print $1'}` = "b76695ec68f9f8b512c9415fc69c1019" ]
then
echo "apache_1.3.42.tar.gz checked"
else
curl -k -L "http://archive.apache.org/dist/httpd/apache_1.3.42.tar.gz" -o $HOME_DIR/sources/apache_1.3.42.tar.gz
do_downloads
return 0
fi

if
[ -f $HOME_DIR/sources/jq-1.4.tar.gz ] && [ `md5sum $HOME_DIR/sources/jq-1.4.tar.gz | awk {'print $1'}` = "e3c75a4f805bb5342c9f4b3603fb248f" ]
then
echo "jq-1.4.tar.gz checked"
else
curl -k -L "http://stedolan.github.io/jq/download/source/jq-1.4.tar.gz" -o $HOME_DIR/sources/jq-1.4.tar.gz
do_downloads
return 0
fi

if
[ -f $HOME_DIR/sources/busybox-1.22.1.tar.bz2 ] && [ `md5sum $HOME_DIR/sources/busybox-1.22.1.tar.bz2 | awk {'print $1'}` = "337d1a15ab1cb1d4ed423168b1eb7d7e" ]
then
echo "busybox-1.22.1.tar.bz2 checked"
else
curl -k -L "http://busybox.net/downloads/busybox-1.22.1.tar.bz2" -o $HOME_DIR/sources/busybox-1.22.1.tar.bz2
do_downloads
return 0
fi

if
[ -f $HOME_DIR/sources/jemalloc-3.6.0.tar.bz2 ] && [ `md5sum $HOME_DIR/sources/jemalloc-3.6.0.tar.bz2 | awk {'print $1'}` = "e76665b63a8fddf4c9f26d2fa67afdf2" ]
then
echo "jemalloc-3.6.0.tar.bz2 checked"
else
curl -k -L "http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2" -o $HOME_DIR/sources/jemalloc-3.6.0.tar.bz2
do_downloads
return 0
fi
}

build_lighttpd()
{
cd $HOME_DIR/sources/
rm -rf lighttpd-1.4.35
tar zxvf lighttpd-1.4.35.tar.gz
cd lighttpd-1.4.35
./configure --prefix=$HOME_DIR --libdir=$HOME_DIR/lib/lighttpd --sysconfdir=$HOME_DIR/etc/lighttpd --with-openssl --enable-shared --enable-static --disable-rpath --without-attr --without-bzip2 --without-fam --without-gdbm --without-ldap --without-lua --without-memcache --without-mysql --with-pcre --without-valgrind && make && make install

}

build_apache_http_tool()
{
cd $HOME_DIR/sources/
rm -rf apache_1.3.42
tar zxvf apache_1.3.42.tar.gz
cd apache_1.3.42
./configure --prefix=$HOME_DIR || bash ./configure --prefix=$HOME_DIR
make || (sed -i 's/getline/apache_getline/' src/support/htdigest.c && \
sed -i 's/getline/apache_getline/' src/support/htpasswd.c && \
sed -i 's/getline/apache_getline/' src/support/logresolve.c && make)
cp src/support/htpasswd $HOME_DIR/bin

}

build_jq()
{
cd $HOME_DIR/sources/
rm -rf jq-1.4
tar zxvf jq-1.4.tar.gz
cd jq-1.4
./configure --prefix=$HOME_DIR 
make
make install
}

build_busybox()
{
cd $HOME_DIR/sources/
rm -rf busybox-1.22.1
tar jxvf busybox-1.22.1.tar.bz2
cd busybox-1.22.1
make defconfig
make
# make PREFIX=$HOME_DIR install
cp busybox $HOME_DIR/bin
}

build_jemalloc()
{
cd $HOME_DIR/sources/
rm -rf jemalloc-3.6.0
tar jxvf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
echo "/usr/local/jemalloc/lib" > /etc/ld.so.conf.d/jemalloc.conf
./configure --prefix=/usr/local/jemalloc && make && make install && ldconfig

}

install_centos_depends()
{
yum reomove -y jq
yum update -y || exit 1
yum groupinstall "Development Tools" -y || exit 1
yum install -y pcre-devel zlib-devel openssl-devel bc tzdata iptables-devel curl wget bridge-utils unzip || exit 1
# tunctl
}

install_ubuntu_depends()
{
apt-get reomove -y jq
apt-get update --fix-missing || exit 1
apt-get install -y build-essential autoconf openssl libssl-dev libpcre3 libpcre3-dev curl wget zlib1g.dev tzdata iptables-dev bridge-utils unzip || exit 1
# uml-utilities

}
install_debian_depends()
{
apt-get remove -y jq
apt-get update --fix-missing || exit 1
apt-get install -y build-essential autoconf openssl libssl-dev libpcre3 libpcre3-dev curl wget zlib1g.dev tzdata iptables-dev bridge-utils unzip || exit 1
# uml-utilities
}
build_proccgi()
{
rm -f $HOME_DIR/bin/proccgi
cd $HOME_DIR/sources/
gcc proccgi.c -o proccgi
mv proccgi $HOME_DIR/bin
}

lighttpd_config()
{
cat <<EOF > $HOME_DIR/etc/lighttpd/lighttpd.conf
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_modules"
server.network-backend = "write"
server.document-root = "$DOCUMENT_ROOT/../htdocs/"
server.bind = "$IP"
server.port = $PORT
server.errorlog = "$HOME_DIR/logs/error.log"
# server.breakagelog = "$HOME_DIR/logs/cgierror.log"
index-file.names = ( "index.cgi", "index.html", "default.html", "index.htm", "default.htm" )
mimetype.assign = (
        ".pdf"   => "application/pdf",
        ".class" => "application/octet-stream",
        ".pac"   => "application/x-ns-proxy-autoconfig",
        ".swf"   => "application/x-shockwave-flash",
        ".wav"   => "audio/x-wav",
        ".gif"   => "image/gif",
        ".jpg"   => "image/jpeg",
        ".jpeg"  => "image/jpeg",
        ".png"   => "image/png",
        ".svg"   => "image/svg+xml",
        ".css"   => "text/css",
        ".html"  => "text/html",
        ".htm"   => "text/html",
        ".js"    => "text/javascript",
        ".txt"   => "text/plain",
        ".dtd"   => "text/xml",
        ".xml"   => "text/xml"
 )
\$HTTP["url"] =~ "\.pdf$" {
        server.range-requests = "disable"
}
server.pid-file = "$HOME_DIR/tmp/lighttpd.pid"
server.upload-dirs = ( "/tmp" )
setenv.add-environment = ( "PATH" => "$PATH" )
ssl.engine                 = "enable"
ssl.pemfile = "$DOCUMENT_ROOT/../ssl/lighttpd.pem"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_simple_vhost"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_fastcgi"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_cgi"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_htpass"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_proxy"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_webdav"
include_shell "$DOCUMENT_ROOT/../bin/main.sbin httpd_others"
EOF
cat <<EOF > $DOCUMENT_ROOT/apps/home/base.httpd_htpass
# auth.debug = 2
auth.backend = "htpasswd"
auth.backend.htpasswd.userfile = "$HOME_DIR/etc/lighttpd/lighttpd.htpasswd"
auth.require = ("/" => (
        "method"  => "basic",
        "realm"   => "Need Authentication.",
        "require" => "valid-user"
))
EOF
openssl req -new -x509 -days 365 -nodes -out $HOME_DIR/ssl/public.csr -keyout $HOME_DIR/ssl/private.key -subj "/C=`head -n 5 /dev/urandom | md5sum | cut -c 1-2`/ST=`head -n 5 /dev/urandom | md5sum | cut -c 1-6`/L=`head -n 5 /dev/urandom | md5sum | cut -c 1-6`/O=`head -n 5 /dev/urandom | md5sum | cut -c 1-6`/OU=`head -n 5 /dev/urandom | md5sum | cut -c 1-6`/CN=`head -n 5 /dev/urandom | md5sum | cut -c 1-6`"
cat $HOME_DIR/ssl/private.key $HOME_DIR/ssl/public.csr > $HOME_DIR/ssl/lighttpd.pem
rm -f $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.htpasswd
$DOCUMENT_ROOT/../bin/htpasswd -c -b -d $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.htpasswd admin admin 2>&1
}

work()
{
[ -d $HOME_DIR/bin ] || mkdir -p $HOME_DIR/bin
[ -d $HOME_DIR/etc/lighttpd ] || mkdir -p $HOME_DIR/etc/lighttpd
[ -d $HOME_DIR/tmp ] || mkdir $HOME_DIR/tmp
[ -d $HOME_DIR/logs ] || mkdir $HOME_DIR/logs
[ -d $HOME_DIR/sources ] || mkdir $HOME_DIR/sources
[ -d $HOME_DIR/ssl ] || mkdir $HOME_DIR/ssl
echo "$OS" | grep -i "centos" && install_centos_depends
echo "$OS" | grep -i "ubuntu" && install_ubuntu_depends
echo "$OS" | grep -i "debian" && install_debian_depends
if
du -s $HOME_DIR/htdocs 2>&1 | grep -q "^[0-9][0-9]*"
then
echo "Already have docs"
else
download_shellgui
cd $HOME_DIR/sources/
unzip shellgui-master.zip
cd shellgui-master
cp -R * $HOME_DIR
fi
do_downloads

cd $HOME_DIR/bin
ln -s  ../htdocs/apps/home/main.sbin main.sbin
build_jemalloc  || exit 1
build_lighttpd  || exit 1
build_jq || exit 1
build_busybox  || exit 1
build_apache_http_tool  || exit 1
build_proccgi  || exit 1
lighttpd_config
sed -i '/main.sbin/d' /etc/rc.local
sed -i "/^[ ]*exit[ ]*0/i\[ -x $HOME_DIR/bin/main.sbin ] && $HOME_DIR/bin/main.sbin init" /etc/rc.local

cat /etc/rc.local | grep "main.sbin" || echo "[ -x $HOME_DIR/bin/main.sbin ] && $HOME_DIR/bin/main.sbin init" >> /etc/rc.local

killall lighttpd || pkill lighttpd
killall busybox || pkill busybox
killall aria2c || pkill aria2c
sed -i "s/8443/$PORT/g" $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
$HOME_DIR/bin/main.sbin init
cat <<EOF
########################################
You Can visit:
https://[Your-IP|Your-Domain]:$PORT/
to Access the Back-Stage Control panel
########################################
Defaul htpass user and password is:
admin
admin
########################################
EOF
rm -rf $(readlink -f $0)
}
error=0
[ ! -x $HOME_DIR/bin/proccgi ] && error=`expr $error + 1`
[ ! -x $HOME_DIR/bin/jq ] && error=`expr $error + 1`
[ ! -x $HOME_DIR/bin/htpasswd ] && error=`expr $error + 1`
[ ! -x $HOME_DIR/bin/busybox ] && error=`expr $error + 1`
[ ! -f $HOME_DIR/etc/lighttpd/lighttpd.conf ] && error=`expr $error + 1`

if
[ $error -gt 0 ]
then
ask
work
fi
