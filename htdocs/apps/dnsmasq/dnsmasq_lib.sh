#!/sibn/sh

install_dnsmasq_dependence()
{
echo "Nothing to do"
}

download_dnsmasq()
{
export download_json='{
"file_name":"dnsmasq-2.72.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/dnsmasq-2.72.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"cf82f81cf09ad3d47612985012240483",
	"download_urls":{
	"thekelleys.org.uk":"http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.72.tar.gz",
	"fossies.org":"https://fossies.org/linux/misc/dns/dnsmasq-2.72.tar.gz",
	"distfiles.alpinelinux.org":"http://distfiles.alpinelinux.org/distfiles/dnsmasq-2.72.tar.gz"
	}
}'
main.sbin download

}

make_dnsmasq()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf dnsmasq-2.72
tar zxvf dnsmasq-2.72.tar.gz

cd $DOCUMENT_ROOT/../sources/dnsmasq-2.72
make all && make install
}
config_dnsmasq()
{
echo "Nothing to do"
}

do_install_dnsmasq()
{
check_dnsmasq_installed && echo "dnsmasq binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_dnsmasq" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_DNSmasq_Dependence\":\"0\",\"_PS_3_Make_install_DNSmasq\":\"0\",\"_PS_4_Config_DNSmasq\":\"0\",\"_PS_5_DNSmasq_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log" app="dnsmasq" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="30"
download_dnsmasq > $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnsmasq" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_2_Make_install_DNSmasq_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="45"
install_dnsmasq_dependence > $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_3_Make_install_DNSmasq"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="60"
make_dnsmasq >> $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnsmasq" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_4_Config_DNSmasq"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="80"

main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_5_DNSmasq_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_dnsmasq" schedule_now="_PS_5_DNSmasq_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_dnsmasq" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_dnsmasq" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="dnsmasq_binary_need_install" >/dev/null 2>&1
}

check_dnsmasq_installed()
{
if
[ -x /usr/local/sbin/dnsmasq ]
then
return 0
else
return 1
fi
}
install_dnsmasq()
{
check_dnsmasq_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_dnsmasq" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/dnsmasq_ins_detail.log ] || do_install_dnsmasq &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_dnsmasq"
get_pregress_schedule_notice_detail
}
###########################################
pre_install_dnsmasq()
{

echo "$_LANG_Ready_to_Install"
}

dnsmasq_service()
{
sed -i "s/^enable=.*/enable=$FORM_dnsmasq_enable/g" $DOCUMENT_ROOT/apps/dnsmasq/S390dnsmasq.init
$DOCUMENT_ROOT/apps/dnsmasq/S390dnsmasq.init >/dev/null 2>&1
if
[ $FORM_dnsmasq_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_dnsmasq_service_enable" \
				detail="_NOTICE_dnsmasq_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="dnsmasq" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_dnsmasq_service_disable" \
				detail="_NOTICE_dnsmasq_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="dnsmasq" \
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

dnsmasq_server()
{
sed -i "s/^resolv_name=.*/resolv_name=\"$FORM_server\"/g" $DOCUMENT_ROOT/apps/dnsmasq/S390dnsmasq.init
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}

set_lanzone()
{
dnsmasq_setting=`cat $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_setting.conf`
dnsmasq_setting=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'"$FORM_lan_zone"'"]["start_ip"] = "'$FORM_start_ip'"'`
dnsmasq_setting=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'"$FORM_lan_zone"'"]["end_ip"] = "'$FORM_end_ip'"'`
dnsmasq_setting=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'"$FORM_lan_zone"'"]["expand_time"] = "'$FORM_expand_time'"'`
if
[ $FORM_enable -eq 1 ]
then
dnsmasq_setting=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'"$FORM_lan_zone"'"]["enable"] = "1"'`
else
dnsmasq_setting=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'"$FORM_lan_zone"'"]["enable"] = "0"'`
fi
echo "$dnsmasq_setting" > $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_setting.conf
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}
base_setting()
{
dnsmasq_setting=`cat $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_setting.conf`
dnsmasq_setting=`echo "$dnsmasq_setting" | jq 'del(.["server"])'`
dnsmasq_setting=`echo "$dnsmasq_setting" | jq '.["no-resolv"] = "'$FORM_no_resolv'"'`


for server in `echo "$FORM_server" | sed 's/\r/\n/g'`
do
[ -n "${server}" ] && \
dnsmasq_setting=`echo "$dnsmasq_setting" | jq '.["server"] = .["server"] + {"'${server}'" : ""}'`
done

dnsmasq_setting=`echo "$dnsmasq_setting" | jq 'del(.["bogus-nxdomain"])'`
for bogus_nxdomain in `echo "$FORM_bogus_nxdomain" | sed 's/\r/\n/g'`
do
dnsmasq_setting=`echo "$dnsmasq_setting" | jq '.["bogus-nxdomain"] = .["bogus-nxdomain"] + {"'${bogus_nxdomain}'" : ""}'`
done

dnsmasq_setting=`echo "$dnsmasq_setting" | jq 'del(.["addn-hosts"])'`
IFS_bak=$IFS
IFS='
'
for addn_hosts in `echo "$FORM_addn_hosts" | sed 's/\r/\n/g'`
do
ip=`echo "${addn_hosts}" | awk {'print $1'}`
domain=`echo "${addn_hosts}" | awk {'print $2'}`
[ -n "$ip" ] && [ -n "$domain" ] && \
dnsmasq_setting=`echo "$dnsmasq_setting" | jq '.["addn-hosts"] = .["addn-hosts"] + {"'${ip}'" : "'${domain}'"}'`
done
IFS=$IFS_bak

if
echo "$dnsmasq_setting" | jq '.' | grep -q "{"
then
echo "$dnsmasq_setting" > $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_setting.conf
fi
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}

