#!/bin/sh

download_php_ext()
{

export download_json='{
"file_name":"imagick-3.1.2.tgz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/imagick-3.1.2.tgz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"f2fd71b026debe056e0ec8d76c2ffe94",
	"download_urls":{
	"php":"http://pecl.php.net/get/imagick-3.1.2.tgz",
	"vpser":"http://soft.vpser.net/web/imagick/imagick-3.1.2.tgz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/imagick-3.1.2.tgz | awk {'print $1'})" != "f2fd71b026debe056e0ec8d76c2ffe94" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/imagick-3.1.2.tgz
# aria2c http://pecl.php.net/get/imagick-3.1.2.tgz \
# http://soft.vpser.net/web/imagick/imagick-3.1.2.tgz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"MagickWandForPHP-1.0.9-2.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/MagickWandForPHP-1.0.9-2.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"76190a585a9f6b90c9884ebd150c64b3",
	"download_urls":{
	"magickwand":"http://www.magickwand.org/download/php/releases/MagickWandForPHP-1.0.9-2.tar.bz2",
	"go-parts":"http://mirrors-usa.go-parts.com/mirrors/ImageMagick/php/MagickWandForPHP-1.0.9-2.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/MagickWandForPHP-1.0.9-2.tar.gz | awk {'print $1'})" != "76190a585a9f6b90c9884ebd150c64b3" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/MagickWandForPHP-1.0.9-2.tar.gz
# aria2c http://www.magickwand.org/download/php/releases/MagickWandForPHP-1.0.9-2.tar.bz2 \
# http://mirrors-usa.go-parts.com/mirrors/ImageMagick/php/MagickWandForPHP-1.0.9-2.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"memcache-3.0.8.tgz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/memcache-3.0.8.tgz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"24505e9b263d2c77f8ae5e9b4725e7d1",
	"download_urls":{
	"php":"http://pecl.php.net/get/memcache-3.0.8.tgz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/memcache-3.0.8.tgz | awk {'print $1'})" != "24505e9b263d2c77f8ae5e9b4725e7d1" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/memcache-3.0.8.tgz
# aria2c http://pecl.php.net/get/memcache-3.0.8.tgz \
# http://pecl.php.net/get/memcache-3.0.8.tgz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"igbinary-1.2.1.tgz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/igbinary-1.2.1.tgz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"04a2474ff5eb99c7d0007bf9f4e8a6ec",
	"download_urls":{
	"php":"http://pecl.php.net/get/igbinary-1.2.1.tgz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/igbinary-1.2.1.tgz | awk {'print $1'})" != "04a2474ff5eb99c7d0007bf9f4e8a6ec" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/igbinary-1.2.1.tgz
# aria2c http://pecl.php.net/get/igbinary-1.2.1.tgz  --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"redis-2.2.5.tgz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/redis-2.2.5.tgz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"60151c2a837cd4a94f420d45e6114b0b",
	"download_urls":{
	"php":"http://pecl.php.net/get/redis-2.2.5.tgz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/redis-2.2.5.tgz | awk {'print $1'})" != "60151c2a837cd4a94f420d45e6114b0b" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/redis-2.2.5.tgz
# aria2c http://pecl.php.net/get/redis-2.2.5.tgz  --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"xcache-3.2.0.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/xcache-3.2.0.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"8b0a6f27de630c4714ca261480f34cda",
	"download_urls":{
	"php":"http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/xcache-3.2.0.tar.gz | awk {'print $1'})" != "8b0a6f27de630c4714ca261480f34cda" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/xcache-3.2.0.tar.gz
# aria2c http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz  --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"ioncube_loaders_lin_x86.tar.gz",
"downloader":"curl wget aria2",
"save_dest":"$DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"indefinite",
	"download_urls":{
	"php":"http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86.tar.gz | awk {'print $1'})" != "c269ee885323aa43b94784d222499423" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86.tar.gz
# aria2c http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz  --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
export download_json='{
"file_name":"ioncube_loaders_lin_x86-64.tar.gz",
"downloader":"curl wget aria2",
"save_dest":"$DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86-64.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"indefinite",
	"download_urls":{
	"php":"http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86-64.tar.gz | awk {'print $1'})" != "471f19ccc7cff907e6e67e6bbf3c23c3" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/ioncube_loaders_lin_x86-64.tar.gz
# aria2c http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz  --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
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
make_php_ext()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf igbinary-1.2.1
tar zxvf igbinary-1.2.1.tgz
cd igbinary-1.2.1
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf imagick-3.1.2
tar zxvf imagick-3.1.2.tgz
cd imagick-3.1.2
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-imagick=/usr/local/imagemagick
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf MagickWandForPHP-1.0.9
tar zxvf MagickWandForPHP-1.0.9-2.tar.gz
cd MagickWandForPHP-1.0.9
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --enable-shared --with-magickwand=/usr/local/imagemagick
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf memcache-3.0.8
tar zxvf memcache-3.0.8.tgz
cd memcache-3.0.8
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --enable-memcached-igbinary --enable-memcached-json
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf redis-2.2.5
tar zxvf redis-2.2.5.tgz
cd redis-2.2.5
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --enable-redis-igbinary
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf xcache-3.2.0
tar zxvf xcache-3.2.0.tar.gz
cd xcache-3.2.0
/usr/local/php/bin/phpize
./configure --enable-xcache --enable-xcache-coverager --enable-xcache-optimizer --with-php-config=/usr/local/php/bin/php-config
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf php-5.5.16
tar jxvf php-5.5.16.tar.bz2
cd php-5.5.16/ext/opcache
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install || return 1

cd $DOCUMENT_ROOT/../sources/
rm -rf ioncube
uname -m | grep -iE "i386|i686" && tar zxvf ioncube_loaders_lin_x86.tar.gz
uname -m | grep -i "x86_64" && tar zxvf ioncube_loaders_lin_x86-64.tar.gz
rm -rf /usr/local/php/lib/php/zend_extension/ioncube/
mkdir -p /usr/local/php/lib/php/zend_extension/
cp -R ioncube /usr/local/php/lib/php/zend_extension/

}
del_php_ext_setting()
{
line=`grep -n "; End:" /usr/local/php/etc/php.ini  | awk -F ":" {'print $1'}`
sed -i "`expr $line + 1`,\$d" /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*imagick.so["]*/d' /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*magickwand.so["]*/d' /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*memcache.so["]*/d' /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*igbinary.so["]*/d' /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*redis.so["]*/d' /usr/local/php/etc/php.ini
sed -i '/^extension[ ]*=[ ]*["]*xcache.so["]*/d' /usr/local/php/etc/php.ini
}
save_php_ext_setting()
{
old_enable_ext=""
grep -Eq "^extension[ ]*=[ ]*.*imagick.so" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext imagick"
grep -Eq "^extension[ ]*=[ ]*.*magickwand.so" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext magickwand"
grep -Eq "^extension[ ]*=[ ]*.*memcache.so" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext memcache"
grep -Eq "^extension[ ]*=[ ]*.*igbinary.so" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext igbinary"
grep -Eq "^extension[ ]*=[ ]*.*redis.so" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext redis"
grep -Eq "^zend_extension[ ]*=.*opcache" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext opcache"
grep -Eq "^extension[ ]*=.*xcache" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext xcache"
grep -Eq "^zend_extension[ ]*=.*ioncube" /usr/local/php/etc/php.ini && old_enable_ext="$old_enable_ext ioncube"

del_php_ext_setting
new_enable_ext=""
[ -n "$FORM_imagick" ] && sed -i "/extension=modulename.extension/a\extension=imagick.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext imagick"
[ -n "$FORM_magickwand" ] && sed -i "/extension=modulename.extension/a\extension=magickwand.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext magickwand"
[ -n "$FORM_memcache" ] && sed -i "/extension=modulename.extension/a\extension=memcache.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext memcache"
[ -n "$FORM_igbinary" ] && sed -i "/extension=modulename.extension/a\extension=igbinary.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext igbinary"
[ -n "$FORM_redis" ] && sed -i "/extension=modulename.extension/a\extension=redis.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext redis"
[ -n "$FORM_xcache" ] && sed -i "/extension=modulename.extension/a\extension=xcache.so" /usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext xcache"

[ -n "$FORM_ioncube" ] && cat <<EOF >>/usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext ioncube"
[ionCube Loader]
zend_extension="/usr/local/php/lib/php/zend_extension/ioncube/ioncube_loader_lin_5.5.so"
EOF
[ -n "$FORM_opcache" ] && echo '' >>/usr/local/php/etc/php.ini && cat $DOCUMENT_ROOT/apps/php-ext/opcache.conf >>/usr/local/php/etc/php.ini && new_enable_ext="$new_enable_ext opcache"
[ -n "$FORM_xcache" ] && echo '' >>/usr/local/php/etc/php.ini && cat $DOCUMENT_ROOT/apps/php-ext/xcache.conf >>/usr/local/php/etc/php.ini
service php-fpm reload >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_ext_enabled_modified" \
				detail="_NOTICE_php_ext_enabled_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php-ext" \
				dest_type="app" \
					variable="{\
					\"new_enable_ext\":\"$new_enable_ext\", \
					\"old_enable_ext\":\"$old_enable_ext\" \
					}" >/dev/null 2>&1
(echo "Success save" | main.sbin output_json 0) || exit 0
}
save_php_opcache_conf()
{
echo "$FORM_php_opcache_conf" > $DOCUMENT_ROOT/apps/php-ext/opcache.conf
(echo "Success save" | main.sbin output_json 0) || exit 0
}
save_php_xcache_conf()
{
echo "$FORM_php_xcache_conf" > $DOCUMENT_ROOT/apps/php-ext/xcache.conf
(echo "Success save" | main.sbin output_json 0) || exit 0
}
do_install_php_ext()
{
[ ! -x /usr/local/php/bin/php ] && echo "Please Install PHP First."  && exit 1
[ ! -x /usr/local/imagemagick/bin/convert ] && echo "Please Install ImageMagick First."  && exit 1
check_php_ext_installed && echo "php-ext binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_PHP_ext" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_PHP_ext\":\"0\",\"_PS_3_PHP_ext_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log" app="php-ext" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="30"
download_php_ext > $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_PHP_ext" status_now="fail"
exit 1
fi

# main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_2_Make_install_ImageMagick_Dependence"
# main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="45"
# install_imagemagick_dependence > $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_2_Make_install_PHP_ext"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="60"
make_php_ext >> $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_PHP_ext" status_now="fail"
exit 1
fi

# main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_4_Config_ImageMagick"
# main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="80"
# config_imagemagick >> $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_3_PHP_ext_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_PHP_ext" schedule_now="_PS_3_PHP_ext_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_PHP_ext" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_PHP_ext" status_now="success"

}
install_php_ext()
{
[ ! -x /usr/local/php/bin/php ] && echo "Please Install PHP First."  && exit 1
[ ! -x /usr/local/imagemagick/bin/convert ] && echo "Please Install ImageMagick First."  && exit 1
check_php_ext_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_PHP_ext" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/php_ext_ins_detail.log ] || do_install_php_ext &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_PHP_ext"
get_pregress_schedule_notice_detail
}
check_php_ext_installed()
{
if
[ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/imagick.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/memcache.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/redis.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/igbinary.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/magickwand.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/opcache.so ] && [ -f /usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/xcache.so ] && [ -d /usr/local/php/lib/php/zend_extension/ioncube ]
then
return 0
else
return 1
fi
}
pre_install_php_ext()
{
[ ! -x /usr/local/php/bin/php ] && echo "Please Install PHP First."  && exit 1
[ ! -x /usr/local/imagemagick/bin/convert ] && echo "Please Install ImageMagick First."  && exit 1
echo "$_LANG_Ready_to_Install"


}
