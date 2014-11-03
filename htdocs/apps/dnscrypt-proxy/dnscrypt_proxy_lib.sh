#!/sibn/sh

install_dnscrypt_proxy_dependence()
{
echo "Nothing to do"
}

download_dnscrypt_proxy()
{
export download_json='{
"file_name":"libsodium-1.0.0.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libsodium-1.0.0.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"3093dabe4e038d09f0d150cef064b2f7",
	"download_urls":{
	"ftp.frugalware.org":"http://ie.archive.ubuntu.com/ftp.frugalware.org/pub/frugalware/frugalware-current/source/lib-extra/libsodium/libsodium-1.0.0.tar.gz",
	"ftp.netbsd.org":"http://ftp.netbsd.org/pub/pkgsrc/distfiles/libsodium-1.0.0.tar.gz",
	"www.mirrorservice.org":"http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libsodium-1.0.0.tar.gz"
	}
}'
main.sbin download
export download_json='{
"file_name":"dnscrypt-proxy-1.4.1.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/dnscrypt-proxy-1.4.1.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"f2bf4195b7264813138e3c6c8da86190",
	"download_urls":{
	"entware.dyndns.info":"http://entware.dyndns.info/sources/dnscrypt-proxy-1.4.1.tar.gz",
	"dnscrypt.org":"http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.4.1.tar.gz",
	"ftp.fr.openbsd.org":"http://ftp.fr.openbsd.org/pub/OpenBSD/distfiles/dnscrypt-proxy-1.4.1.tar.gz"
	}
}'
main.sbin download


}

make_dnscrypt_proxy()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf libsodium-1.0.0
tar zxvf libsodium-1.0.0.tar.gz

cd $DOCUMENT_ROOT/../sources/
rm -rf dnscrypt-proxy-1.4.1
tar zxvf dnscrypt-proxy-1.4.1.tar.gz


cd $DOCUMENT_ROOT/../sources/libsodium-1.0.0
./configure
make && make install

cd $DOCUMENT_ROOT/../sources/dnscrypt-proxy-1.4.1
ldconfig
ldconfig -p | grep "libsodium.so" || return 1
./configure --prefix=/usr/local/dnscrypt-proxy
make && make install && useradd dnscrypt-proxy -m
return 0
}
config_dnscrypt_proxy()
{
echo "Nothing to do"
}

do_install_dnscrypt_proxy()
{
[ ! -x /usr/local/sbin/dnsmasq ] && echo "dnscrypt-dnsmasq need install" && exit 1
check_dnscrypt_proxy_installed && echo "dnscrypt-proxy binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_dnscrypt_proxy" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_DNScrypt_proxy_Dependence\":\"0\",\"_PS_3_Make_install_DNScrypt_proxy\":\"0\",\"_PS_4_Config_DNScrypt_proxy\":\"0\",\"_PS_5_DNScrypt_proxy_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log" app="dnscrypt-proxy" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="30"
download_dnscrypt_proxy > $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnscrypt_proxy" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_2_Make_install_DNScrypt_proxy_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="45"
install_dnscrypt_proxy_dependence > $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_3_Make_install_DNScrypt_proxy"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="60"
make_dnscrypt_proxy >> $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnscrypt_proxy" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_4_Config_DNScrypt_proxy"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="80"
config_dnscrypt_proxy >> $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_5_DNScrypt_proxy_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_dnscrypt_proxy" schedule_now="_PS_5_DNScrypt_proxy_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnscrypt_proxy" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnscrypt_proxy" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="dnscrypt_proxy_binary_need_install" >/dev/null 2>&1
cat <<EOF > $DOCUMENT_ROOT/apps/dnscrypt-proxy/root.cron
0 0 0 * * eval \`$DOCUMENT_ROOT/../bin/main.sbin shellgui_env\` && . $DOCUMENT_ROOT/apps/dnscrypt-proxy/dnscrypt_proxy_lib.sh && update_dnscrypt_resolvers_csv
EOF
$DOCUMENT_ROOT/apps/scheduled/S300scheduled.init
}

check_dnscrypt_proxy_installed()
{
if
[ -x /usr/local/dnscrypt-proxy/sbin/dnscrypt-proxy ]
then
return 0
else
return 1
fi
}
install_dnscrypt_proxy()
{
check_dnscrypt_proxy_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_dnscrypt_proxy" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/dnscrypt_proxy_ins_detail.log ] || do_install_dnscrypt_proxy &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_dnscrypt_proxy"
get_pregress_schedule_notice_detail
}
###########################################
pre_install_dnscrypt_proxy()
{

echo "$_LANG_Ready_to_Install"
}

dnscrypt_proxy_service()
{
sed -i "s/^enable=.*/enable=$FORM_dnscrypt_proxy_enable/g" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init
$DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init >/dev/null 2>&1
if
[ $FORM_dnscrypt_proxy_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_dnscrypt_proxy_service_enable" \
				detail="_NOTICE_dnscrypt_proxy_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="dnscrypt-proxy" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_dnscrypt_proxy_service_disable" \
				detail="_NOTICE_dnscrypt_proxy_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="dnscrypt-proxy" \
				dest_type="app" >/dev/null 2>&1
fi
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}

bind_setting()
{
sed -i "s/^bind_ip=.*/bind_ip=\"$FORM_bind_ip\"/g" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init
sed -i "s/^bind_port=.*/bind_port=$FORM_bind_port/g" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init

if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}
dnscrypt_proxy_server()
{
sed -i "s/^resolv_name=.*/resolv_name=\"$FORM_server\"/g" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}

update_dnscrypt_resolvers_csv()
{
rm -f $DOCUMENT_ROOT/../tmp/dnscrypt-resolvers.csv
export download_json='{
"file_name":"dnscrypt-resolvers.csv",
"downloader":"curl wget aria2",
"save_dest":"$DOCUMENT_ROOT/../tmp/dnscrypt-resolvers.csv",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"indefinite",
	"download_urls":{
	"github":"https://github.com/jedisct1/dnscrypt-proxy/raw/master/dnscrypt-resolvers.csv"
	}
}'
main.sbin download
[ $(grep -Po ',' $DOCUMENT_ROOT/../tmp/dnscrypt-resolvers.csv | wc -l) -gt 100 ] && cp -R $DOCUMENT_ROOT/../tmp/dnscrypt-resolvers.csv /usr/local/dnscrypt-proxy/share/dnscrypt-proxy/dnscrypt-resolvers.csv && rm -f $DOCUMENT_ROOT/../tmp/dnscrypt-resolvers.csv

}
