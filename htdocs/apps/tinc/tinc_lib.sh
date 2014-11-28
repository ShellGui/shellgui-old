#!/bin/sh

install_tinc_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y lzo lzo-devel pam-devel 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y liblzo2-dev libpam0g-dev 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y liblzo2-dev libpam0g-dev 2>&1) || exit 1
fi
}

download_tinc()
{
export download_json='{
"file_name":"tinc-1.0.24.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/tinc-1.0.24.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"14a91eb2e85bdc0451a815612521b708",
	"download_urls":{
	"www.tinc-vpn.org":"http://www.tinc-vpn.org/packages/tinc-1.0.24.tar.gz",
	"fossies.org":"http://fossies.org/linux/privat/tinc-1.0.24.tar.gz",
	"ftp.de.debian.org":"http://ftp.de.debian.org/debian/pool/main/t/tinc/tinc_1.0.24.orig.tar.gz",
	"archive.ubuntu.com":"http://archive.ubuntu.com/ubuntu/pool/universe/t/tinc/tinc_1.0.24.orig.tar.gz"
	}
}'
main.sbin download

}

make_tinc()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf tinc-1.0.24
tar zxvf tinc-1.0.24.tar.gz
cd tinc-1.0.24
mkdir -p /data/tinc/etc
./configure --prefix=/usr/local/tinc --sysconfdir=/data/tinc/etc --localstatedir=/var
make
make install

}
config_tinc()
{
mkdir -p /data/tinc/etc/tinc/default/hosts
rm -f /data/tinc/etc/tinc/default/rsa_key.priv
cat <<EOF > /data/tinc/etc/tinc/default/tinc.conf
Name = server
AddressFamily = ipv4
Interface = tinc-server
Port = 655

EOF

cat <<'EOF' > /data/tinc/etc/tinc/default/tinc-up
#!/bin/sh
VPN_GATEWAY="10.10.0.1"
ifconfig $INTERFACE $VPN_GATEWAY netmask 255.255.255.0

EOF
chmod +x /data/tinc/etc/tinc/default/tinc-up

cat <<'EOF' > /data/tinc/etc/tinc/default/tinc-down
#!/bin/sh
ifconfig $INTERFACE down

EOF
chmod +x /data/tinc/etc/tinc/default/tinc-down
[ -n "$SERVER_NAME" ] || SERVER_NAME="1.2.3.4"
cat <<EOF >  /data/tinc/etc/tinc/default/hosts/server
Address = $SERVER_NAME
Subnet = 0.0.0.0/0

EOF
echo "\n\n\n\n" | /usr/local/tinc/sbin/tincd -n default -K 4096 2>&1
}

do_install_tinc()
{
[ ! +x /usr/local/sbin/dnsmasq ] && echo "Please install dnsmasq First." && exit 1
check_tinc_installed && echo "tinc binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_tinc" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_Tinc_Dependence\":\"0\",\"_PS_3_Make_install_Tinc\":\"0\",\"_PS_4_Config_Tinc\":\"0\",\"_PS_5_Tinc_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/tinc_ins_detail.log" app="tinc" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="30"
download_tinc > $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_tinc" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_2_Make_install_Tinc_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="45"
install_tinc_dependence > $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_3_Make_install_Tinc"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="60"
make_tinc >> $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_tinc" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_4_Config_Tinc"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="80"
config_tinc >> $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_5_Tinc_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_tinc" schedule_now="_PS_5_Tinc_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_tinc" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_tinc" status_now="success"

}

check_tinc_installed()
{
if
[ -x /usr/local/tinc/sbin/tincd ]
then
return 0
else
return 1
fi
}

install_tinc()
{
check_tinc_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_tinc" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/tinc_ins_detail.log ] || do_install_tinc &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_tinc"
get_pregress_schedule_notice_detail
}
pre_tinc_install_config()
{
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
pre_install_tinc()
{
echo "$_LANG_Ready_to_Install"

}

############################
save_client()
{
for client in `env | grep "^FORM_ip_" | sed 's/^FORM_ip_//g' | awk -F "=" {'print $1'}`
do
ip_now=`eval echo '$'FORM_ip_${client}`
sed -i "s#^Subnet[ ]*=.*#Subnet = $ip_now#" /data/tinc/etc/tinc/default/hosts/${client}
done
(echo "Success" | main.sbin output_json 0) || exit 0
}

new_client()
{
[ -n "$FORM_new_client_name" ] || [ -n "$FORM_new_client_subnet" ] || (echo "Username & Subnet Can not be empty." | main.sbin output_json 1) || exit 1
port=`grep -E "^Port[ ]*=[ ]*[0-9]*" /data/tinc/etc/tinc/default/tinc.conf | grep -Po '[0-9]*'`

rm -rf /data/tinc/etc/tinc/gen_test_new/
mkdir -p /data/tinc/etc/tinc/gen_test_new/hosts/
cat <<EOF > /data/tinc/etc/tinc/gen_test_new/tinc.conf
Name = $FORM_new_client_name
AddressFamily = ipv4
ConnectTo = server
Interface = tinc-user
Port = $port

EOF
cat <<EOF > /data/tinc/etc/tinc/gen_test_new/hosts/$FORM_new_client_name
Subnet = $FORM_new_client_subnet

EOF
mkdir -p /data/tinc/priv/
echo "\n\n\n\n" | /usr/local/tinc/sbin/tincd -n gen_test_new -K 4096 >/dev/null 2>&1
mv /data/tinc/etc/tinc/gen_test_new/rsa_key.priv /data/tinc/priv/$FORM_new_client_name"_rsa_key".priv
mv /data/tinc/etc/tinc/gen_test_new/hosts/$FORM_new_client_name /data/tinc/etc/tinc/default/hosts/
rm -rf /data/tinc/etc/tinc/gen_test_new
(echo "Success" | main.sbin output_json 0) || exit 0
}

del_client_file()
{
rm -f /data/tinc/etc/tinc/default/hosts/$FORM_client_file
(echo "Success" | main.sbin output_json 0) || exit 0
}

download()
{
port=`grep -E "^Port[ ]*=[ ]*[0-9]*" /data/tinc/etc/tinc/default/tinc.conf | grep -Po '[0-9]*'`
Server_Address=`grep -E "Address[ ]*=" /data/tinc/etc/tinc/default/hosts/server | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`
VPN_GATEWAY=`grep -E "VPN_GATEWAY" /data/tinc/etc/tinc/default/tinc-up | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`
Client_ip=`grep -E "^Subnet[ ]*=[ ]*[0-9]*" /data/tinc/etc/tinc/default/hosts/$FORM_client_file | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`

rm -rf /tmp/gen_test_new
mkdir -p /tmp/gen_test_new/default/hosts
cp /data/tinc/etc/tinc/default/hosts/$FORM_client_file /tmp/gen_test_new/default/hosts
cp /data/tinc/etc/tinc/default/hosts/server /tmp/gen_test_new/default/hosts
cp /data/tinc/priv/$FORM_client_file"_rsa_key".priv /tmp/gen_test_new/default/rsa_key.priv
cat <<EOF > /tmp/gen_test_new/default/tinc.conf
Name = $FORM_client_file
AddressFamily = ipv4
ConnectTo = server
Interface = tinc-user
Port = $port

EOF
sed -i 's/$/\r/g' /tmp/gen_test_new/default/tinc.conf
cat <<EOF > /tmp/gen_test_new/default/start-default.bat
@echo ON
SET START_DIR=%~dp0
SET TINC_INTERFACE_NAME="tinc-user"
SET TINC_INTERFACE_ADDR=$Client_ip
SET TINC_INTERFACE_MASK=255.255.255.0
SET TINC_INTERFACE_GATEWAY=$VPN_GATEWAY
SET TINC_INTERFACE_DNS=8.8.8.8
SET TINC_INTERFACE_DNS2=$VPN_GATEWAY
SET SERVER_IP=$Server_Address
SET SERVER_GTW=$VPN_GATEWAY
setlocal enableextensions enabledelayedexpansion
for /f "tokens=4" %%a in ('route print 0.0.0.0 ^| findstr 0.0.0.0') do (IF "!DEFAULT_GATEWAY!"=="" set DEFAULT_GATEWAY=%%a)


if exist "%windir%\SysWOW64" (
SET SYS_ARC=64
)else (
SET SYS_ARC=32
)

REM 判断是否安装tinc TAP

for /f  %%i in ('ipconfig /all^|findstr /i "tinc-user:"') do set TINC_INTERFACE_INSTALLED=%%i

IF "%TINC_INTERFACE_INSTALLED%" == "" (
IF  "%SYS_ARC%" == "64" (
	ECHO ".............64................"
	copy /y ..\tap-win64\* .
	tapinstall.exe install OemWin2k.inf tap0901
)ELSE  (
	ECHO ".............32................"
	copy /y ..\tap-win32\* .
   	tapinstall.exe install OemWin2k.inf tap0901
)
)



REM 查找新增网络连接名称

for /f "tokens=*" %%a in ('wmic path Win32_NetworkAdapter get NetConnectionID ^| findstr .') do SET name2=%%a
for /f "delims=" %%i in ("%name2%") do SET name=%%~nxi

ECHO "name->[%name%]"


REM 设置网络参数
netsh interface set interface name="%name%" newname=%TINC_INTERFACE_NAME%


echo 正在配置%name%,请稍等...  
echo 正在配置首选DNS:%dns%...
netsh interface ip set dns name=%TINC_INTERFACE_NAME% source=static addr=%TINC_INTERFACE_DNS%

echo 正在配置ip、mask和gateway：%ipaddress% %mask% %gateway%...
netsh interface ip set address name=%TINC_INTERFACE_NAME% source=static addr=%TINC_INTERFACE_ADDR% mask=%TINC_INTERFACE_MASK% gateway=%TINC_INTERFACE_GATEWAY%
netsh interface ip set address name=%TINC_INTERFACE_NAME% static  %TINC_INTERFACE_ADDR%  %TINC_INTERFACE_MASK% %TINC_INTERFACE_GATEWAY% 1
echo ip配置成功!

REM CD %START_DIR%

cd ..
tincd -k --net=default
tincd -n default
ping %SERVER_GTW%
rem route add %SERVER_IP% %DEFAULT_GATEWAY%
route add 0.0.0.0 mask 0.0.0.0 %SERVER_GTW%
pause
EOF
sed -i 's/$/\r/g' /tmp/gen_test_new/default/start-default.bat
cat <<EOF > /tmp/gen_test_new/default/stop-default.bat
@echo OFF
cd ..
tincd -k --net=default
pause
EOF
sed -i 's/$/\r/g' /tmp/gen_test_new/default/stop-default.bat
cd /tmp/gen_test_new/
rm -rf /tmp/tinc_ssl.tar.gz
tar czf /tmp/tinc_ssl.tar.gz default
main.sbin http_download /tmp/tinc_ssl.tar.gz $Server_Address"_"$FORM_client_file"_tinc_ssl.tar.gz"
}

wan_dest()
{
dest=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
sed -i '/^dest_wan=/d' $DOCUMENT_ROOT/apps/tinc/tinc_extra.conf
echo "dest_wan=\"$dest\"" >> $DOCUMENT_ROOT/apps/tinc/tinc_extra.conf
(echo "Success" | main.sbin output_json 0) || exit 0
}

tinc_service()
{
if
[ "$FORM_tinc_enable" = "1" ]
then
sed -i "s/^enable=.*/enable=$FORM_tinc_enable/g" $DOCUMENT_ROOT/apps/tinc/S902tinc.init
$DOCUMENT_ROOT/apps/tinc/S902tinc.init start
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_tinc_service_enable" \
				detail="_NOTICE_tinc_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="tinc" \
				dest_type="app" >/dev/null 2>&1
main.sbin fw_init
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
sed -i "s/^enable=.*/enable=$FORM_tinc_enable/g" $DOCUMENT_ROOT/apps/tinc/S902tinc.init
$DOCUMENT_ROOT/apps/tinc/S902tinc.init stop
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_tinc_service_disable" \
				detail="_NOTICE_tinc_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="tinc" \
				dest_type="app" >/dev/null 2>&1
main.sbin fw_init
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}

base_setting()
{
sed -i "s/Port[ ]*=[ ]*.*/Port = $FORM_port/" /data/tinc/etc/tinc/default/tinc.conf
sed -i "s/Address[ ]*=[ ]*.*/Address = $FORM_Server_Address/" /data/tinc/etc/tinc/default/hosts/server
sed -i "s/^VPN_GATEWAY=.*/VPN_GATEWAY=\"$FORM_VPN_GATEWAY\"/" /data/tinc/etc/tinc/default/tinc-up
(echo "Success" | main.sbin output_json 0) || exit 0
}

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh

