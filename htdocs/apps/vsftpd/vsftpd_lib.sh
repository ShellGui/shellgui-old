#!/sibn/sh

install_vsftpd_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
# yum remove -y vsftpd
(yum update -y && yum install -y db4-utils pam-devel libcap-devel vsftpd 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
# apt-get remove -y vsftpd 
(apt-get update --fix-missing && (apt-get build-dep -y vsftpd && apt-get install vsftpd || apt-get install -y debhelper gettext html2text intltool-debian libcap-dev libcroco3 libgettextpo0 libpam0g-dev libunistring0 libwrap0-dev po-debconf vsftpd) 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
# apt-get remove -y vsftpd
(apt-get update --fix-missing && (apt-get build-dep -y vsftpd && apt-get install vsftpd || apt-get install -y debhelper gettext html2text intltool-debian libcap-dev libcroco3 libgettextpo0 libpam0g-dev libunistring0 libwrap0-dev po-debconf vsftpd) 2>&1) || exit 1
fi
}

download_vsftpd()
{
# export download_json='{
# "file_name":"vsftpd-3.0.2.tar.gz",
# "downloader":"aria2 curl wget",
# "save_dest":"$DOCUMENT_ROOT/../sources/vsftpd-3.0.2.tar.gz",
# "useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
# "timeout":20,
# "md5sum":"8b00c749719089401315bd3c44dddbb2",
	# "download_urls":{
	# "security.appspot.com":"https://security.appspot.com/downloads/vsftpd-3.0.2.tar.gz",
	# "fossies.org":"http://fossies.org/linux/misc/vsftpd-3.0.2.tar.gz",
	# "mirror.pw":"http://mirror.pw/slackware/slackware-14.1/source/n/vsftpd/vsftpd-3.0.2.tar.gz"
	# }
# }'
# main.sbin download
echo "Do notihing"
}

make_vsftpd()
{
# cd $DOCUMENT_ROOT/../sources/
# rm -rf vsftpd-3.0.2
# tar zxvf vsftpd-3.0.2.tar.gz

# cd $DOCUMENT_ROOT/../sources/vsftpd-3.0.2
# if
# echo "$OS" | grep -iqE "ubuntu|debian"
# then
	# if
	# ls /lib/$(uname -m)-linux-gnu 2>&1
	# then
	# sed -i "s#/lib/#/lib/$(uname -m)-linux-gnu/#g" ./vsf_findlibs.sh
	#########sed -i "s#/lib64/#/lib64/$(uname -m)-linux-gnu/#g" ./vsf_findlibs.sh
	# sed -i "s#/usr/#/#g" ./vsf_findlibs.sh
	# else
	# tar_lib=`find /lib/ -type d -maxdepth 1 | grep "\-linux-gnu" | sed -n 1p`
	# sed -i "s#/lib/#$tar_lib/#g" ./vsf_findlibs.sh
	##########sed -i "s#/lib64/#/lib64/$tar_lib/#g" ./vsf_findlibs.sh
	# sed -i "s#/usr/#/#g" ./vsf_findlibs.sh
	# fi
# fi
# make && mkdir -p /usr/local/man/man5/ && make install
groupadd ftp
useradd ftp -g ftp -s /usr/sbin/nologin -d /data/ftp -M -c "FTP User"
mkdir -p /data/ftp
chown ftp.ftp /data/ftp

for var in anon_root pasv_min_port pasv_max_port userlist_file
do
sed -i "/^${var}=/d" $vsftpd_config_dir/vsftpd.conf
done
echo "anon_root=/data/ftp" >>$vsftpd_config_dir/vsftpd.conf
echo "pasv_min_port=10100" >>$vsftpd_config_dir/vsftpd.conf
echo "pasv_max_port=10190" >>$vsftpd_config_dir/vsftpd.conf
echo " userlist_file=/etc/ftpusers" >>$vsftpd_config_dir/vsftpd.conf
# cp RedHat/vsftpd.pam /etc/pam.d/ftp
}
config_vsftpd()
{

echo "$OS" | grep -i "centos" && chkconfig --add vsftpd && chkconfig mysqld off
echo "$OS" | grep -i "ubuntu" && update-rc.d -f vsftpd remove #defaults
echo "$OS" | grep -i "debian" && update-rc.d -f vsftpd remove
service vsftpd start
}

do_install_vsftpd()
{
check_vsftpd_installed && echo "vsftpd binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_vsftpd" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_vsftpd_Dependence\":\"0\",\"_PS_3_Make_install_vsftpd\":\"0\",\"_PS_4_Config_vsftpd\":\"0\",\"_PS_5_vsftpd_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log" app="vsftpd" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="30"
download_vsftpd > $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_vsftpd" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_2_Make_install_vsftpd_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="45"
install_vsftpd_dependence > $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_3_Make_install_vsftpd"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="60"
make_vsftpd >> $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_vsftpd" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_4_Config_vsftpd"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="80"

main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_5_vsftpd_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_vsftpd" schedule_now="_PS_5_vsftpd_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_vsftpd" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_vsftpd" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="vsftpd_binary_need_install" >/dev/null 2>&1
}

check_vsftpd_installed()
{
if
[ -x /usr/sbin/vsftpd ]
then
return 0
else
return 1
fi
}
install_vsftpd()
{
check_vsftpd_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_vsftpd" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/vsftpd_ins_detail.log ] || do_install_vsftpd &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_vsftpd"
get_pregress_schedule_notice_detail
}
###########################################
pre_install_vsftpd()
{

echo "$_LANG_Ready_to_Install"
}

vsftpd_service()
{
if
[ "$FORM_vsftpd_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add vsftpd && chkconfig vsftpd on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f vsftpd defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f vsftpd defaults >/dev/null 2>&1
service vsftpd start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_vsftpd_service_enable" \
				detail="_NOTICE_vsftpd_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="vsftpd" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add vsftpd && chkconfig vsftpd off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f vsftpd remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f vsftpd remove >/dev/null 2>&1
service vsftpd stop >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_vsftpd_service_disable" \
				detail="_NOTICE_vsftpd_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="vsftpd" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}

#################################

edit_config_file()
{
for var in `env | grep "^FORM_.*=" | grep -vE "^FORM_app=|^FORM_action=" | sed -e 's/^FORM_//g' -e 's/=.*//g'`
do
sed -i "/^${var}=/d" $vsftpd_config_dir/vsftpd.conf
value=$(eval echo '$'FORM_${var})
[ -n "$value" ] && echo "${var}=$value" >>$vsftpd_config_dir/vsftpd.conf
done
}

access_control_setting()
{
echo "$FORM_vsftpd_user_list" > /etc/ftpusers
unset FORM_vsftpd_user_list
edit_config_file
}

anonymous_setting()
{
edit_config_file
}

file_setting()
{
edit_config_file
}

global_setting()
{
edit_config_file
}

infomation_setting()
{
sed -i '/^ftpd_banner=/d' $vsftpd_config_dir/vsftpd.conf
[ -n "$FORM_ftpd_banner" ] && echo "ftpd_banner=\"$FORM_ftpd_banner\"" >>$vsftpd_config_dir/vsftpd.conf
unset FORM_ftpd_banner
edit_config_file
}

local_user_setting()
{
edit_config_file
}

pam_auth_setting()
{
edit_config_file
}

path_setting()
{
edit_config_file
}

security_setting()
{
edit_config_file
}

server_performance_setting()
{
edit_config_file
}

server_setting()
{
edit_config_file
}

timeout_setting()
{
edit_config_file
}

transfer_setting()
{
edit_config_file
}

user_options_setting()
{
edit_config_file
}

wan_dest()
{
dest=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
sed -i '/^dest_wan=/d' $DOCUMENT_ROOT/apps/vsftpd/vsftpd_extra.conf
echo "dest_wan=\"$dest\"" >> $DOCUMENT_ROOT/apps/vsftpd/vsftpd_extra.conf
(echo "Success" | main.sbin output_json 0) || exit 0
}

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
