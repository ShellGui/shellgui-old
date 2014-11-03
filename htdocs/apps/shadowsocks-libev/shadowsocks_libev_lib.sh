#!/bin/sh

install_shadowsocks_libev_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y unzip curl curl-devel zlib-devel openssl-devel perl perl-devel cpio expat-devel gettext-devel polarssl-devel 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y unzip libpolarssl-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y unzip libpolarssl-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
}
download_shadowsocks_libev()
{
rm -f $DOCUMENT_ROOT/../sources/shadowsocks-libev-master.zip
# . $DOCUMENT_ROOT/apps/curl/curl_lib.sh
# curl_load no_max_time=1
# curl $curl_args -L https://github.com/madeye/shadowsocks-libev/archive/master.zip -o $DOCUMENT_ROOT/../sources/shadowsocks-libev-master.zip 2>&1

export download_json='{
"file_name":"shadowsocks-libev-master.zip",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/shadowsocks-libev-master.zip",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"indefinite",
	"download_urls":{
	"github":"https://github.com/madeye/shadowsocks-libev/archive/master.zip"
	}
}'
main.sbin download
}
make_shadowsocks_libev()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf shadowsocks-libev-master
unzip shadowsocks-libev-master.zip
cd shadowsocks-libev-master
# if
# echo "$OS" | grep -iq "centos"
# then
./configure --prefix="/usr/local/shadowsocks-libev" --with-crypto-library=openssl --with-openssl=/usr/include/openssl/
# else 
# ./configure --prefix="/usr/local/shadowsocks-libev" --with-crypto-library=polarssl --with-polarssl=/usr/include/polarssl
# fi
make && make install
}
do_install_shadowsocks_libev()
{
check_shadowsocks_libev_installed && echo "shadowsocks-libev binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_Shadowsocks_libev" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_Shadowsocks_libev_Dependence\":\"0\",\"_PS_3_Make_install_Shadowsocks_libev\":\"0\",\"_PS_4_Config_Shadowsocks_libev\":\"0\",\"_PS_5_Shadowsocks_libev_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log" app="shadowsocks-libev" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="30"
download_shadowsocks_libev > $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_Shadowsocks_libev" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_2_Make_install_Shadowsocks_libev_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="45"
install_shadowsocks_libev_dependence > $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_3_Make_install_Shadowsocks_libev"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="60"
make_shadowsocks_libev >> $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_Shadowsocks_libev" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_4_Config_Shadowsocks_libev"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="80"
echo "Finished" >> $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log 2>&1
useradd shadowsocks
mkdir -p /usr/local/shadowsocks-libev/etc/
cat <<EOF > /usr/local/shadowsocks-libev/etc/server.json
{
	"server":"0.0.0.0",
	"server_port":8388,
	"local_port":1080,
	"password":"shadowsocks-libev",
	"timeout":60,
	"method":"table"
}
EOF
cat <<EOF > /usr/local/shadowsocks-libev/etc/local.json
{
	"server":"8.8.8.8",
	"server_port":8388,
	"local_port":1080,
	"password":"shadowsocks-libev",
	"timeout":60,
	"method":"table"
}
EOF
cat <<EOF > /usr/local/shadowsocks-libev/etc/redir.json
{
	"server":"8.8.8.8",
	"server_port":8388,
	"local_port":1080,
	"password":"shadowsocks-libev",
	"timeout":60,
	"method":"table"
}
EOF
main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_5_Shadowsocks_libev_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_Shadowsocks_libev" schedule_now="_PS_5_Shadowsocks_libev_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Shadowsocks_libev" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_Shadowsocks_libev" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="Shadowsocks_libev_binary_need_install" >/dev/null 2>&1

}
check_shadowsocks_libev_installed()
{
if
[ -x /usr/local/shadowsocks-libev/bin/ss-server ]
then
return 0
else
return 1
fi
}
install_shadowsocks_libev()
{
check_shadowsocks_libev_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_Shadowsocks_libev" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/shadowsocks_libev_ins_detail.log ] || do_install_shadowsocks_libev &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_Shadowsocks_libev"
get_pregress_schedule_notice_detail
}
pre_install_shadowsocks_libev()
{
echo "$_LANG_Ready_to_Install"

}
shadowsocks_libev_server_service()
{
sed -i "s/^enable=.*/enable=$FORM_shadowsocks_libev_server_enable/g" $DOCUMENT_ROOT/apps/shadowsocks-libev/S700shadowsocks_server.init
result=`$DOCUMENT_ROOT/apps/shadowsocks-libev/S700shadowsocks_server.init >/dev/null 2>&1`
if
[ $FORM_shadowsocks_libev_server_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_server_service_enable" \
				detail="_NOTICE_Shadowsocks_libev_server_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="shadowsocks-libev" \
				dest_type="app" >/dev/null 2>&1
main.sbin fw_init
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_server_service_disable" \
				detail="_NOTICE_Shadowsocks_libev_server_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="shadowsocks-libev" \
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
shadowsocks_libev_local_service()
{
sed -i "s/^enable=.*/enable=$FORM_shadowsocks_libev_local_enable/g" $DOCUMENT_ROOT/apps/shadowsocks-libev/S701shadowsocks_local.init
result=`$DOCUMENT_ROOT/apps/shadowsocks-libev/S701shadowsocks_local.init >/dev/null 2>&1`
if
[ $FORM_shadowsocks_libev_local_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_local_service_enable" \
				detail="_NOTICE_Shadowsocks_libev_local_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="shadowsocks-libev" \
				dest_type="app" >/dev/null 2>&1
main.sbin fw_init
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_local_service_disable" \
				detail="_NOTICE_Shadowsocks_libev_local_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="shadowsocks-libev" \
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
shadowsocks_libev_redir_service()
{
sed -i "s/^enable=.*/enable=$FORM_shadowsocks_libev_redir_enable/g" $DOCUMENT_ROOT/apps/shadowsocks-libev/S702shadowsocks_redir.init
result=`$DOCUMENT_ROOT/apps/shadowsocks-libev/S702shadowsocks_redir.init >/dev/null 2>&1`
if
[ $FORM_shadowsocks_libev_redir_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_local_redir_service_enable" \
				detail="_NOTICE_Shadowsocks_libev_local_redir_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="shadowsocks-libev" \
				dest_type="app" >/dev/null 2>&1
main.sbin fw_init
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_Shadowsocks_libev_redir_service_disable" \
				detail="_NOTICE_Shadowsocks_libev_redir_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="shadowsocks-libev" \
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
shadowsocks_libev_server_basesetting()
{
server_config_str=`cat /usr/local/shadowsocks-libev/etc/server.json`
server_config_str=`echo "$server_config_str" | jq '.["server"] = "'$FORM_server'"'`
server_config_str=`echo "$server_config_str" | jq '.["server_port"] = '"$FORM_server_port"''`
server_config_str=`echo "$server_config_str" | jq '.["local_port"] = '"$FORM_local_port"''`
server_config_str=`echo "$server_config_str" | jq '.["timeout"] = '"$FORM_timeout"''`
server_config_str=`echo "$server_config_str" | jq '.["password"] = "'$FORM_password'"'`
server_config_str=`echo "$server_config_str" | jq '.["method"] = "'$FORM_method'"'`
if
echo "$server_config_str" | jq '.' | grep -q "{"
then
echo "$server_config_str" >/usr/local/shadowsocks-libev/etc/server.json
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi

}
shadowsocks_libev_local_basesetting()
{
local_config_str=`cat /usr/local/shadowsocks-libev/etc/local.json`
local_config_str=`echo "$local_config_str" | jq '.["server"] = "'$FORM_server'"'`
local_config_str=`echo "$local_config_str" | jq '.["server_port"] = '"$FORM_server_port"''`
# local_config_str=`echo "$local_config_str" | jq '.["local_port"] = '"$FORM_local_port"''`
local_config_str=`echo "$local_config_str" | jq '.["timeout"] = '"$FORM_timeout"''`
local_config_str=`echo "$local_config_str" | jq '.["password"] = "'$FORM_password'"'`
local_config_str=`echo "$local_config_str" | jq '.["method"] = "'$FORM_method'"'`
if
echo "$local_config_str" | jq '.' | grep -q "{"
then
echo "$local_config_str" >/usr/local/shadowsocks-libev/etc/local.json
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi

}
shadowsocks_libev_redir_basesetting()
{
redir_config_str=`cat /usr/local/shadowsocks-libev/etc/redir.json`
redir_config_str=`echo "$redir_config_str" | jq '.["server"] = "'$FORM_server'"'`
redir_config_str=`echo "$redir_config_str" | jq '.["server_port"] = '"$FORM_server_port"''`
redir_config_str=`echo "$redir_config_str" | jq '.["local_port"] = '"$FORM_local_port"''`
redir_config_str=`echo "$redir_config_str" | jq '.["timeout"] = '"$FORM_timeout"''`
redir_config_str=`echo "$redir_config_str" | jq '.["password"] = "'$FORM_password'"'`
redir_config_str=`echo "$redir_config_str" | jq '.["method"] = "'$FORM_method'"'`
if
echo "$redir_config_str" | jq '.' | grep -q "{"
then
echo "$redir_config_str" >/usr/local/shadowsocks-libev/etc/redir.json
echo "$FORM_transparent_proxy_dest" > $DOCUMENT_ROOT/apps/shadowsocks-libev/transparent_proxy_dest.conf
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi

}
shadowsocks_libev_redir_dest()
{
shadowsocks_libev_str=`cat $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json`
lan_zone=`env | grep "^FORM_lan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
shadowsocks_libev_str=`echo "$shadowsocks_libev_str" | jq '.["shadowsocks_redir"]["lan_zone"] = "'"$lan_zone"'"'`
if
echo "$shadowsocks_libev_str" | jq '.' | grep -q "{"
then
echo "$shadowsocks_libev_str" > $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}
shadowsocks_libev_local_dest()
{
shadowsocks_libev_str=`cat $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json`
wan_zone=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
shadowsocks_libev_str=`echo "$shadowsocks_libev_str" | jq '.["shadowsocks_local"]["wan_zone"] = "'"$wan_zone"'"'`
if
echo "$shadowsocks_libev_str" | jq '.' | grep -q "{"
then
echo "$shadowsocks_libev_str" > $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}
shadowsocks_libev_server_dest()
{
shadowsocks_libev_str=`cat $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json`
wan_zone=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
shadowsocks_libev_str=`echo "$shadowsocks_libev_str" | jq '.["shadowsocks_server"]["wan_zone"] = "'"$wan_zone"'"'`
if
echo "$shadowsocks_libev_str" | jq '.' | grep -q "{"
then
echo "$shadowsocks_libev_str" > $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
