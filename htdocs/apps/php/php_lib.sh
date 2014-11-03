#!/bin/sh

install_php_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y libxml2-devel libcurl-devel 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y libxml2-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y libxml2-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
}

download_php()
{
# jpegsrc.v9.tar.gz
export download_json='{
"file_name":"jpegsrc.v9.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"b397211ddfd506b92cd5e02a22ac924d",
	"download_urls":{
	"misc":"http://fossies.org/linux/misc/jpegsrc.v9.tar.gz",
	"ijg":"http://www.ijg.org/files/jpegsrc.v9.tar.gz",
	"debian":"ftp://ftp2.de.debian.org/fink-distfiles/jpegsrc.v9.tar.gz",
	"videolan":"http://download.videolan.org/contrib/jpegsrc.v9.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz | awk {'print $1'})" != "b397211ddfd506b92cd5e02a22ac924d" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz
# aria2c http://fossies.org/linux/misc/jpegsrc.v9.tar.gz \
# http://www.ijg.org/files/jpegsrc.v9.tar.gz \
# ftp://ftp2.de.debian.org/fink-distfiles/jpegsrc.v9.tar.gz \
# http://download.videolan.org/contrib/jpegsrc.v9.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libpng-1.6.3.tar.gz
export download_json='{
"file_name":"libpng-1.6.3.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"98b652b6c174c35148f1f5f513fe490d",
	"download_urls":{
	"sourceforge":"http://prdownloads.sourceforge.net/libpng/libpng-1.6.3.tar.gz",
	"u-aizu":"ftp://ftp.u-aizu.ac.jp/pub/graphics/image/ImageMagick/simplesystems.org/libpng/png/src/history/libpng16/libpng-1.6.3.tar.gz"
	}
}'
main.sbin download

# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz | awk {'print $1'})" != "98b652b6c174c35148f1f5f513fe490d" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz
# aria2c http://prdownloads.sourceforge.net/libpng/libpng-1.6.3.tar.gz \
# ftp://ftp.u-aizu.ac.jp/pub/graphics/image/ImageMagick/simplesystems.org/libpng/png/src/history/libpng16/libpng-1.6.3.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# freetype-2.4.12.tar.gz
export download_json='{
"file_name":"freetype-2.4.12.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"e3057079a9bb96d7ebf9afee3f724653",
	"download_urls":{
	"askapache":"http://nongnu.askapache.com/freetype/freetype-2.4.12.tar.gz",
	"savannah":"http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz | awk {'print $1'})" != "e3057079a9bb96d7ebf9afee3f724653" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz
# aria2c http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz \
# http://nongnu.askapache.com/freetype/freetype-2.4.12.tar.gz \
# http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# mhash-0.9.9.9.tar.gz
export download_json='{
"file_name":"mhash-0.9.9.9.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"ee66b7d5947deb760aeff3f028e27d25",
	"download_urls":{
	"sourceforge":"http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz",
	"sourceforge":"http://superb-dca2.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz",
	"vpser":"http://soft.vpser.net/web/mhash/mhash-0.9.9.9.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz | awk {'print $1'})" != "ee66b7d5947deb760aeff3f028e27d25" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz
# aria2c http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
# http://superb-dca2.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
# http://soft.vpser.net/web/mhash/mhash-0.9.9.9.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libmcrypt-2.5.8.tar.gz
export download_json='{
"file_name":"libmcrypt-2.5.8.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"0821830d930a86a5c69110837c55b7da",
	"download_urls":{
	"sourceforge":"http://softlayer.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.8.tar.gz",
	"sourceforge":"http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz",
	"sourceforge":"http://softlayer-dal.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz | awk {'print $1'})" != "0821830d930a86a5c69110837c55b7da" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz
# aria2c http://softlayer.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.8.tar.gz \
# http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz \
# http://softlayer-dal.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libevent-2.0.21-stable.tar.gz
export download_json='{
"file_name":"libevent-2.0.21-stable.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"b2405cc9ebf264aa47ff615d9de527a2",
	"download_urls":{
	"github":"http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz",
	"netbsd":"ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/libevent-2.0.21-stable.tar.gz",
	"github":"https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz | awk {'print $1'})" != "b2405cc9ebf264aa47ff615d9de527a2" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz
# aria2c http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz \
# ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/libevent-2.0.21-stable.tar.gz \
# https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libiconv-1.14.tar.gz
export download_json='{
"file_name":"libiconv-1.14.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"e34509b1623cec449dfeb73d7ce9c6c6",
	"download_urls":{
	"gnu.org":"http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz",
	"anl.gov":"http://mirror.anl.gov/pub/gnu/libiconv/libiconv-1.14.tar.gz",
	"jp":"http://ftp.yz.yamagata-u.ac.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz | awk {'print $1'})" != "e34509b1623cec449dfeb73d7ce9c6c6" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz
# aria2c http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://mirror.anl.gov/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://ftp.yz.yamagata-u.ac.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# php-5.5.16.tar.bz2
export download_json='{
"file_name":"php-5.5.16.tar.bz2",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"331a87fb27e100a88b3845d34582f769",
	"download_urls":{
	"php":"http://jp1.php.net/distributions/php-5.5.16.tar.bz2",
	"sohu":"http://mirrors.sohu.com/php/php-5.5.16.tar.bz2",
	"internode":"http://mirror.internode.on.net/pub/php/php-5.5.16.tar.bz2"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2 | awk {'print $1'})" != "331a87fb27e100a88b3845d34582f769" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2
# aria2c http://jp1.php.net/distributions/php-5.5.16.tar.bz2 \
# http://mirrors.sohu.com/php/php-5.5.16.tar.bz2 \
# http://mirror.internode.on.net/pub/php/php-5.5.16.tar.bz2 --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}

make_php()
{
# jpegsrc.v9.tar.gz
# libpng-1.6.3.tar.gz
# freetype-2.4.12.tar.gz
# mhash-0.9.9.9.tar.gz
# libmcrypt-2.5.8.tar.gz
# libevent-2.0.21-stable.tar.gz
# libiconv-1.14.tar.gz
# php-5.5.16.tar.bz2

cd $DOCUMENT_ROOT/../sources/
rm -rf jpegsrc.v9
tar zxvf jpegsrc.v9.tar.gz
rm -rf libpng-1.6.3
tar zxvf libpng-1.6.3.tar.gz
rm -rf freetype-2.4.12
tar zxvf freetype-2.4.12.tar.gz
rm -rf mhash-0.9.9.9
tar zxvf mhash-0.9.9.9.tar.gz
rm -rf libmcrypt-2.5.8
tar zxvf libmcrypt-2.5.8.tar.gz
rm -rf libevent-2.0.21-stable
tar zxvf libevent-2.0.21-stable.tar.gz
rm -rf libiconv-1.14
tar zxvf libiconv-1.14.tar.gz
rm -rf php-5.5.16
tar jxvf php-5.5.16.tar.bz2

cd $DOCUMENT_ROOT/../sources/jpeg-9
./configure --prefix=/usr/local/phpextend --enable-shared --enable-static
make && make install
cd $DOCUMENT_ROOT/../sources/libpng-1.6.3
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/freetype-2.4.12
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/mhash-0.9.9.9
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libiconv-1.14
./configure --prefix=/usr/local/phpextend
echo "$distribution" | grep -iq "centos-7" && sed -i '/gets is a security hole/d' $DOCUMENT_ROOT/../sources/libiconv-1.14/srclib/stdio.h
make && make install
echo "/usr/local/phpextend/lib" > /etc/ld.so.conf.d/phpextend.conf
ldconfig
cd $DOCUMENT_ROOT/../sources/php-5.5.16
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fastcgi \
--with-php=/usr/local/php \
--with-phpi=/usr/local/php/bin/php_config \
--disable-debug --disable-ipv6 \
--with-iconv-dir=/usr/local/phpextend \
--with-freetype-dir=/usr/local/phpextend \
--with-jpeg-dir=/usr/local/phpextend \
--with-png-dir=/usr/local/phpextend \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-fpm \
--enable-mbstring  \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-cli \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--with-pdo-mysql=/usr/local/mysql
grep "^EXTRA_LIBS =" Makefile | grep -q "-liconv" || sed -i 's/EXTRA_LIBS =/EXTRA_LIBS = -liconv /g' Makefile
make && make install

}
config_php()
{
cd /usr/local/php/etc
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
if
grep -qE "^listen.owner[ ]*=[ ]*www" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.owner/d' /usr/local/php/etc/php-fpm.conf
echo "listen.owner = www" >> /usr/local/php/etc/php-fpm.conf
fi
if
grep -qE "^listen.group[ ]*=[ ]*www" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.group/d' /usr/local/php/etc/php-fpm.conf
echo "listen.group = www" >> /usr/local/php/etc/php-fpm.conf
fi
if
grep -qE "^listen.mode[ ]*=[ ]*0660" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.mode/d' /usr/local/php/etc/php-fpm.conf
echo "listen.mode = 0660" >> /usr/local/php/etc/php-fpm.conf
fi
sed -i '/^user.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i '/^group.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\user = www" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\group = www" /usr/local/php/etc/php-fpm.conf

cd $DOCUMENT_ROOT/../sources/php-5.5.16
cp php.ini-development /usr/local/php/etc/php.ini
cp sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
useradd www
service php-fpm start
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm on
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm defaults #remove
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm defaults
}

do_install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
check_php_installed && echo "php binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/php_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_php" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_PHP_Dependence\":\"0\",\"_PS_3_Make_install_PHP\":\"0\",\"_PS_4_Config_PHP\":\"0\",\"_PS_5_PHP_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/php_ins_detail.log" app="php" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="30"
download_php > $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_2_Make_install_PHP_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="45"
install_php_dependence > $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_3_Make_install_PHP"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="60"
make_php >> $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_4_Config_PHP"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="80"
config_php >> $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_5_PHP_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_5_PHP_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="success"

}

check_php_installed()
{
if
[ -x /usr/local/php/bin/php ]
then
return 0
else
return 1
fi
}
install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
check_php_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_php" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/php_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/php_ins_detail.log ] || do_install_php &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_php"
get_pregress_schedule_notice_detail
}
pre_php_install_config()
{
# echo "$FORM_datadir" | grep -q "^/" || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
# echo "$FORM_datadir" | main.sbin regx_str ispath || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
# echo "`dirname $FORM_log_error`" | grep -q "^/" || (echo "log_error Error" | main.sbin output_json 1) || exit 1
# echo "`dirname $FORM_log_error`" | main.sbin regx_str ispath || (echo "log_error Error" | main.sbin output_json 1) || exit 1
# echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
# echo "datadir=$FORM_datadir" > $DOCUMENT_ROOT/../tmp/php.config.tmp
# echo "port=$FORM_port" >> $DOCUMENT_ROOT/../tmp/php.config.tmp
# echo "log_error=$FORM_log_error" >> $DOCUMENT_ROOT/../tmp/php.config.tmp
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
pre_install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
echo "$_LANG_Ready_to_Install"



}
base_setting_fpm()
{
echo "$FORM_fpm_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
[ "$FORM_fpm_bind_address" = "0.0.0.0" ] || ifconfig | grep -q "$FORM_bind_address" || (echo "Bind-address Error" | main.sbin output_json 1) || exit 1

sed -i '/^listen.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen = $FORM_fpm_bind_address:$FORM_fpm_port" /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_modified_to_tcp" \
				detail="_NOTICE_php_modified_to_tcp_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"fpm_bind_address\":\"$FORM_fpm_bind_address\", \
						\"fpm_port\":\"$FORM_fpm_port\" \
					}" >/dev/null 2>&1

(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
base_setting_socket()
{
# echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
# [ "$FORM_bind_address" = "0.0.0.0" ] || ifconfig | grep -q "$FORM_bind_address" || (echo "Bind-address Error" | main.sbin output_json 1) || exit 1

[ -d $(dirname $FORM_socket_bind_address) ] || (echo "目录错误" | main.sbin output_json 1) || exit 1
grep -q "^$FORM_socket_listen_owner" /etc/passwd || (echo "用户不存在" | main.sbin output_json 1) || exit 1
grep -q "^$FORM_socket_listen_group" /etc/group || (echo "用户组不存在" | main.sbin output_json 1) || exit 1
echo "$FORM_socket_listen_mode" | main.sbin regx_str islang_alb || (echo "用户组不存在" | main.sbin output_json 1) || exit 1

sed -i '/^listen.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen = $FORM_socket_bind_address" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.owner = $FORM_socket_listen_owner" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.group = $FORM_socket_listen_group" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.mode = $FORM_socket_listen_mode" /usr/local/php/etc/php-fpm.conf
sed -i '/^user.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i '/^group.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\user = $FORM_socket_listen_owner" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\group = $FORM_socket_listen_group" /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_modified_to_socket" \
				detail="_NOTICE_php_modified_to_socket_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"socket_bind_address\":\"$FORM_socket_bind_address\", \
						\"socket_listen_owner\":\"$FORM_socket_listen_owner\", \
						\"socket_listen_group\":\"$FORM_socket_listen_group\", \
						\"socket_listen_mode\":\"$FORM_socket_listen_mode\" \
					}" >/dev/null 2>&1
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}

php_service()
{
if
[ "$FORM_php_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm defaults >/dev/null 2>&1
service php-fpm start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_service_enable" \
				detail="_NOTICE_php_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm remove >/dev/null 2>&1
service php-fpm stop >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_service_disable" \
				detail="_NOTICE_php_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}
save_php_ini()
{
[ -n "$FORM_php_ini_str" ] || (echo "不能为空" | main.sbin output_json 1) || exit 1
echo "$FORM_php_ini_str" | grep -vE '^$|#|\[.*\]|=|^;' | grep -q [a-zA-Z0-9]
[ $? -ne 0 ] || (echo "配置文件内容有误" | main.sbin output_json 1) || exit 1
echo "$FORM_php_ini_str" > /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_ini_modified" \
				detail="_NOTICE_php_ini_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "保存成功" | main.sbin output_json 0) || exit 0
}
save_php_fpm_conf()
{
[ -n "$FORM_php_fpm_conf_str" ] || (echo "不能为空" | main.sbin output_json 1) || exit 1
echo "$FORM_php_fpm_conf_str" | grep -vE '^$|#|\[.*\]|=|^;' | grep -q [a-zA-Z0-9]
[ $? -ne 0 ] || (echo "配置文件内容有误" | main.sbin output_json 1) || exit 1
echo "$FORM_php_fpm_conf_str" > /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_fpm_conf_modified" \
				detail="_NOTICE_php_fpm_conf_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1

(echo "保存成功" | main.sbin output_json 0) || exit 0
}

change_mysqli_default_socket()
{
old_mysqli_default_socket=`grep -E "^mysqli.default_socket[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`
echo "$FORM_mysqli_default_socket" | grep -q "^/" || (echo "mysqli_default_socket Error" | main.sbin output_json 1) || exit 1
sed -i '/^mysqli.default_socket[ ]*=[ ]*/d' /usr/local/php/etc/php.ini
sed -i "/\[MySQLi\]/a\mysqli.default_socket = $FORM_mysqli_default_socket" /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_change_mysqli_default_socket" \
				detail="_NOTICE_php_change_mysqli_default_socket_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"mysqli_default_socket\":\"$FORM_mysqli_default_socket\", \
						\"old_mysqli_default_socket\":\"$old_mysqli_default_socket\" \
					}" >/dev/null 2>&1
(echo "mysqli_default_socket change Success" | main.sbin output_json 0) || exit 0
}
change_time_zone()
{
old_tz=`grep -E "^date\.timezone[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`
sed -i '/^date\.timezone[ ]*=[ ]*/d' /usr/local/php/etc/php.ini
sed -i "/\[Date\]/a\date.timezone = $FORM_zonename" /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_change_time_zone" \
				detail="_NOTICE_php_change_time_zone_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"tz\":\"$FORM_zonename\", \
						\"old_tz\":\"$old_tz\" \
					}" >/dev/null 2>&1
(echo "time_zone change Success" | main.sbin output_json 0) || exit 0
}
php_info()
{
(su - root -c '/usr/local/php/bin/php-cgi -q <<EOF
<?php phpinfo(); ?>
EOF'
exit)
}
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh

