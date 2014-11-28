#!/bin/sh

download_mysql()
{
export download_json='{
"file_name":"mysql-5.6.14.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/mysql-5.6.14.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"52224ce51dbf6ffbcef82be30688cc04",
	"download_urls":{
	"skysql":"http://downloads.skysql.com/archives/mysql-5.6/mysql-5.6.14.tar.gz",
	"mysql":"http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.14.tar.gz",
	"mariadb":"https://downloads.mariadb.com/archives/mysql-5.6/mysql-5.6.14.tar.gz",
	"freebsd":"ftp://ftp.tw.freebsd.org/pub/distfiles/mysql-5.6.14.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/$packagename-$version.$arch | awk {'print $1'})" != "52224ce51dbf6ffbcef82be30688cc04" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/$packagename-$version.$arch
# $DOCUMENT_ROOT/../bin/aria2c "$download_url1$packagename-$version.$arch" "$download_url2$packagename-$version.$arch" "$download_url3$packagename-$version.$arch" --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}

install_mysql_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y cmake bison-devel  ncurses-devel 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y cmake libncurses5-dev bison 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y cmake libncurses5-dev bison 2>&1) || exit 1
fi
}

make_mysql()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf mysql-5.6.14

tar zxvf mysql-5.6.14.tar.gz

cd $DOCUMENT_ROOT/../sources/mysql-5.6.14
eval `cat $DOCUMENT_ROOT/../tmp/mysql.config.tmp`
[ -n "$use_jemalloc" ] && jemalloc_used="-DCMAKE_EXE_LINKER_FLAGS=\"-ljemalloc\" -DWITH_SAFEMALLOC=OFF"
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/ \
	-DMYSQL_DATADIR=$datadir \
	-DSYSCONFDIR=/usr/local/mysql/etc -DWITH_MYISAM_STORAGE_ENGINE=1 \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_MEMORY_STORAGE_ENGINE=1 \
	-DWITH_READLINE=1 \
	-DMYSQL_UNIX_ADDR=/dev/shm/mysqld.sock \
	-DMYSQL_TCP_PORT=3306 \
	-DENABLED_LOCAL_INFILE=1 \
	-DWITH_PARTITION_STORAGE_ENGINE=1 \
	-DEXTRA_CHARSETS=all \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci $jemalloc_used && make install

cd /usr/local/mysql
mkdir -p /usr/local/mysql/etc
cp support-files/my-default.cnf /usr/local/mysql/etc/my.cnf
echo "/usr/local/mysql/lib" > /etc/ld.so.conf.d/mysql_ld.conf

[ -n "$datadir" ] || datadir="/data/mysql"
[ -n "$log_error" ] || log_error="/var/log/mysqld/mysqld.log"
[ -n "$port" ] || port="3306"
sed -i '/^datadir=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\datadir=$datadir" /usr/local/mysql/etc/my.cnf
sed -i '/^log-error=/d' /usr/local/mysql/etc/my.cnf
grep -q "\[mysqld_safe\]" /usr/local/mysql/etc/my.cnf || echo "[mysqld_safe]" >> /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld_safe\]/a\log-error=$log_error" /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\port=$port" /usr/local/mysql/etc/my.cnf
sed -i '/^bind-address=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\bind-address=localhost" /usr/local/mysql/etc/my.cnf
sed -i '/^port=/d' /usr/local/mysql/etc/my.cnf
sed -i "s/^port=.*/port=$port/g" /usr/local/mysql/etc/my.cnf
mkdir -p /var/log/mysqld/
}

config_mysql()
{
datadir=`grep "^datadir=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
mkdir -p $datadir
useradd mysql
cd /usr/local/mysql
./scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=$datadir --user=mysql
cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
echo "$OS" | grep -i "centos" && chkconfig --add mysqld && chkconfig mysqld on
echo "$OS" | grep -i "ubuntu" && update-rc.d -f mysqld defaults #remove
echo "$OS" | grep -i "debian" && update-rc.d -f mysqld defaults
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqld /usr/bin/mysqld
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
service mysqld start
}
do_install_mysql()
{
check_mysql_installed && echo "mysqld binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_mysql" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_Mysql_Dependence\":\"0\",\"_PS_3_Make_install_Mysql\":\"0\",\"_PS_4_Config_Mysql\":\"0\",\"_PS_5_Mysql_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/mysql_ins_detail.log" app="mysql" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="30"
download_mysql > $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_mysql" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_2_Make_install_Mysql_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="45"
install_mysql_dependence > $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_3_Make_install_Mysql"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="60"
make_mysql >> $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_mysql" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_4_Config_Mysql"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="80"
config_mysql >> $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_5_Mysql_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_mysql" schedule_now="_PS_5_Mysql_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_mysql" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_mysql" status_now="success"

}

check_mysql_installed()
{
if
[ -x /usr/local/mysql/bin/mysqld ]
then
return 0
else
return 1
fi
}
install_mysql()
{
check_mysql_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_mysql" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/mysql_ins_detail.log ] || do_install_mysql &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_mysql"
get_pregress_schedule_notice_detail
}
pre_mysql_install_config()
{
echo "$FORM_datadir" | grep -q "^/" || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "$FORM_datadir" | main.sbin regx_str ispath || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "`dirname $FORM_log_error`" | grep -q "^/" || (echo "log_error Error" | main.sbin output_json 1) || exit 1
echo "`dirname $FORM_log_error`" | main.sbin regx_str ispath || (echo "log_error Error" | main.sbin output_json 1) || exit 1
echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
echo "datadir=$FORM_datadir" > $DOCUMENT_ROOT/../tmp/mysql.config.tmp
echo "use_jemalloc=$FORM_use_jemalloc" >> $DOCUMENT_ROOT/../tmp/mysql.config.tmp
echo "port=$FORM_port" >> $DOCUMENT_ROOT/../tmp/mysql.config.tmp
echo "log_error=$FORM_log_error" >> $DOCUMENT_ROOT/../tmp/mysql.config.tmp
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
pre_install_mysql()
{
echo "$_LANG_Ready_to_Install"

eval `cat $DOCUMENT_ROOT/../tmp/mysql.config.tmp`
cat <<'EOF'
<script>
$(function(){
  $('#pre_mysql_install_config').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
</script>
EOF
cat <<EOF
<form id="pre_mysql_install_config">
<table class="table">
<tr>
<td>
Use jemalloc
</td>
<td>
<input type="checkbox" selected="" name="use_jemalloc" value="1" `[ -n "$use_jemalloc" ] && echo checked`>
</td>
</tr>
<tr>
<td>
$_LANG_Datadir
</td>
<td>
<input type="text" class="form-control" name="datadir" placeholder="/data/mysql" value="`[ -n "$datadir" ] && echo "$datadir" || echo "/data/mysql"`">
</td>
</tr>
<tr>
<td>
$_LANG_Port
</td>
<td>
<input type="text" class="form-control" name="port" placeholder="3306" value="`[ -n "$port" ] && echo "$port" || echo "3306"`">
</td>
</tr>
<tr>
<td>
$_LANG_Log_Error
</td>
<td>
<input type="text" class="form-control" name="log_error" placeholder="/var/log/mysqld/mysqld.log" value="`[ -n "$log_error" ] && echo "$log_error" || echo "/var/log/mysqld/mysqld.log"`">
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="pre_mysql_install_config">
<button type="submit" class="btn btn-info">$_LANG_Save</button>
</td>
</tr>

</table>
</form>
EOF

}
base_setting()
{
echo "$FORM_datadir" | grep -q "^/" || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "$FORM_datadir" | main.sbin regx_str ispath || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "`dirname $FORM_log_error`" | grep -q "^/" || (echo "log_error Error" | main.sbin output_json 1) || exit 1
echo "`dirname $FORM_log_error`" | main.sbin regx_str ispath || (echo "log_error Error" | main.sbin output_json 1) || exit 1
echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
[ "$FORM_bind_address" = "localhost" ] || [ "$FORM_bind_address" = "0.0.0.0" ] || ifconfig | grep -q "$FORM_bind_address" || (echo "Bind-address Error" | main.sbin output_json 1) || exit 1

old_datadir=`grep "^datadir=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
old_port=`grep "^port=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
old_log_error=`grep "^log-error=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
old_bind_address=`grep "^bind-address=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`

sed -i '/^datadir=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\datadir=$FORM_datadir" /usr/local/mysql/etc/my.cnf
sed -i '/^port=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\port=$FORM_port" /usr/local/mysql/etc/my.cnf
sed -i '/^log-error=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\log-error=$FORM_log_error" /usr/local/mysql/etc/my.cnf
sed -i '/^bind-address=/d' /usr/local/mysql/etc/my.cnf
sed -i "/\[mysqld\]/a\bind-address=$FORM_bind_address" /usr/local/mysql/etc/my.cnf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_base_setting_modified" \
				detail="_NOTICE_mysql_base_setting_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="mysql" \
				dest_type="app" \
					variable="{\
					\"datadir\":\"$FORM_datadir\", \
					\"port\":\"$FORM_port\", \
					\"log_error\":\"$FORM_log_error\", \
					\"bind_address\":\"$FORM_bind_address\", \
					\"old_datadir\":\"$old_datadir\", \
					\"old_port\":\"$old_port\", \
					\"old_log_error\":\"$old_log_error\", \
					\"old_bind_address\":\"$old_bind_address\" \
					}" >/dev/null 2>&1
(echo "Success save" | main.sbin output_json 0) || exit 0
}
change_socket_bind_address()
{
old_socket=`grep "^socket=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
echo "$FORM_socket_bind_address" | grep -q "^/" || (echo "socket_bind_address error" | main.sbin output_json 1) || exit 1
sed -i '/^socket=/d' /usr/local/mysql/etc/my.cnf
[ $FORM_mysql_sock_enable -ne 0 ] && sed -i "/\[mysqld\]/a\socket=$FORM_socket_bind_address" /usr/local/mysql/etc/my.cnf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_socket_setting_modified" \
				detail="_NOTICE_mysql_socket_setting_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="mysql" \
				dest_type="app" \
					variable="{\
					\"socket\":\"$FORM_socket_bind_address\", \
					\"old_socket\":\"$old_socket\" \
					}" >/dev/null 2>&1
(echo "Success save" | main.sbin output_json 0) || exit 0
}
change_pass()
{
[ "$FORM_my_new_passwd" = "$FORM_my_new_passwd_cf" ] || (echo "两次输入的密码不一致" | main.sbin output_json 1) || exit 1

result=`/usr/local/mysql/bin/mysqladmin -u $FORM_my_username password "$FORM_my_new_passwd_cf" 2>&1 || /usr/local/mysql/bin/mysqladmin -u $FORM_my_username -p"$FORM_my_password" password "$FORM_my_new_passwd_cf" 2>&1`
if
[ $? -eq 0 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_user_password_modified" \
				detail="_NOTICE_mysql_user_password_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="mysql" \
				dest_type="app" \
					variable="{\
						\"my_username\":\"$FORM_my_username\" \
					}" >/dev/null 2>&1
(echo "Change password success" | main.sbin output_json 0) || exit 0
else
result=`echo $result | sed 's/"//g' | tr -d "\'" | tr -d '\n' | tr -d '\a'`
(echo "$result" | main.sbin output_json 1) || exit 1
fi
}
mysql_service()
{
if
[ "$FORM_mysql_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add mysqld && chkconfig mysqld on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f mysqld defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f mysqld defaults >/dev/null 2>&1
$DOCUMENT_ROOT/apps/mysql/S101mysql.init start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_service_enable" \
				detail="_NOTICE_mysql_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="mysql" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn on." | main.sbin output_json 0) || return 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add mysqld && chkconfig mysqld off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f mysqld remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f mysqld remove >/dev/null 2>&1
service mysqld stop >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_service_disable" \
				detail="_NOTICE_mysql_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="mysql" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn off." | main.sbin output_json 0) || return 0
fi
}

save_my_cnf()
{
[ -n "$FORM_my_cnf_str" ] || (echo "不能为空" | main.sbin output_json 1) || exit 1
echo "$FORM_my_cnf_str" | grep -vE '^$|#|\[.*\]|=' | grep -q [a-zA-Z0-9]
[ $? -ne 0 ] || (echo "配置文件内容有误" | main.sbin output_json 1) || exit 1
echo "$FORM_my_cnf_str" >/usr/local/mysql/etc/my.cnf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_mysql_my_cnf_modified" \
				detail="_NOTICE_mysql_my_cnf_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="mysql" \
				dest_type="app" >/dev/null 2>&1
(echo "保存成功" | main.sbin output_json 0) || exit 0
}


mysql_passwd_default()
{
sed -i "/\[mysqld\]/a\skip-grant-tables" /usr/local/mysql/etc/my.cnf
service mysqld stop >/dev/null 2>&1
export FORM_mysql_enable=1
mysql_service >/dev/null 2>&1

/usr/local/mysql/bin/mysql -uroot <<EOF
use mysql;
UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
flush privileges;
EOF

sed -i '/^skip-grant-tables/d' /usr/local/mysql/etc/my.cnf
mysql_service >/dev/null 2>&1
(echo "MySQL Password change to root Success" | main.sbin output_json 0) || return 0
}

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh

