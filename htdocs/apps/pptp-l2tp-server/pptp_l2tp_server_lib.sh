check_pptp_l2tp_env()
{
EXIT_STR="
系统不能安装pptp & l2tp
system can not install pptp & l2tp

你可尝试OpenVpn，或者请求系统管理员开启 TUN/TAP/PPP
You can try OpenVpn, Or ask administrator to turn On TUN/TAP/PPP"

modprobe ppp-compress-18 > /dev/null 2>&1 
if
[ $? -ne 0 ]
then
echo "$EXIT_STR" 
exit 1
fi
cat /dev/net/tun > /dev/null 2>&1
if
[ $? -eq 0 ]
then
echo "$EXIT_STR"
exit 1
fi
# if
# [ -x /usr/sbin/pppd ]
# then
# [ `strings '/usr/sbin/pppd' |grep -i mppe | wc --lines` -gt 0 ] || echo "pppd ver canot used,remove "&& yum remove -y pppd
# fi
}

install_pptp_l2tp_dependence()
{
# check_pptp_l2tp_env
if
echo "$OS" | grep -iq "centos"
then
release_ver=$(echo "$OS" | grep -Po '[0-9|\.][0-9|\.]*' | sed 's/\..*//')
(yum update -y && echo -e y"\n" | rpm -Uhv http://poptop.sourceforge.net/yum/stable/rhel$release_ver/pptp-release-current.noarch.rpm || rpm -Uvh http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-1.noarch.rpm
yum remove -y pppd && yum install -y ppp pptpd gmp-devel bison flex libpcap-devel policycoreutils lsof 2>&1) || exit 1
chkconfig pptpd off >/dev/null 2>&1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get -y --purge autoremove pptpd ppp && \
rm -rf /etc/pptpd.conf && \
rm -rf /etc/ppp && \
apt-get -y install ppp pptpd libgmp3-dev bison flex libpcap-dev lsof 2>&1) || exit 1
update-rc.d -f pptpd remove >/dev/null 2>&1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get -y --purge autoremove pptpd ppp && \
rm -rf /etc/pptpd.conf && \
rm -rf /etc/ppp && \
apt-get -y install ppp pptpd libgmp3-dev bison flex libpcap-dev lsof 2>&1) || exit 1
update-rc.d -f pptpd remove >/dev/null 2>&1
fi
}

download_pptp_l2tp()
{
export download_json='{
"file_name":"openswan-2.6.32.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/openswan-2.6.32.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"02f5e13f03399b62aad9be4030cfd42b",
	"download_urls":{
	"openswan":"https://download.openswan.org/openswan/old/openswan-2.6/openswan-2.6.32.tar.gz",
	"freeswan":"https://www.freeswan.org/old-openswan/openswan-2.6.32.tar.gz"
	}
}'
main.sbin download

export download_json='{
"file_name":"rp-l2tp-0.4.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/rp-l2tp-0.4.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"0e45d11cb4fa6c56cce6b1d119733ed9",
	"download_urls":{
	"github":"http://nchc.dl.sourceforge.net/project/rp-l2tp/rp-l2tp/0.4/rp-l2tp-0.4.tar.gz"
	}
}'
main.sbin download

export download_json='{
"file_name":"xl2tpd-1.3.0.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/xl2tpd-1.3.0.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"28264284552c442b24cf421755a2bb48",
	"download_urls":{
	"www.xelerance.com":"https://www.xelerance.com/wp-content/uploads/software/xl2tpd/xl2tpd-1.3.0.tar.gz",
	"mirror.linux.org":"ftp://mirror.linux.org.au/gentoo/gentoo/distfiles/xl2tpd-1.3.0.tar.gz"
	}
}'
main.sbin download


# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/openswan-2.6.32.tar.gz | awk {'print $1'})" != "02f5e13f03399b62aad9be4030cfd42b" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/openswan-2.6.32.tar.gz
# $DOCUMENT_ROOT/../bin/aria2c https://download.openswan.org/openswan/old/openswan-2.6/openswan-2.6.32.tar.gz https://www.freeswan.org/old-openswan/openswan-2.6.32.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# [ $0 -ne 0 ] || download_pptp_l2tp
# fi
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/rp-l2tp-0.4.tar.gz | awk {'print $1'})" != "0e45d11cb4fa6c56cce6b1d119733ed9" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/rp-l2tp-0.4.tar.gz
# $DOCUMENT_ROOT/../bin/aria2c "http://nchc.dl.sourceforge.net/project/rp-l2tp/rp-l2tp/0.4/rp-l2tp-0.4.tar.gz" --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/xl2tpd-1.3.0.tar.gz | awk {'print $1'})" != "28264284552c442b24cf421755a2bb48" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/xl2tpd-1.3.0.tar.gz
# $DOCUMENT_ROOT/../bin/aria2c https://www.xelerance.com/wp-content/uploads/software/xl2tpd/xl2tpd-1.3.0.tar.gz ftp://mirror.linux.org.au/gentoo/gentoo/distfiles/xl2tpd-1.3.0.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}
make_pptp_l2tp()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf openswan-2.6.32 rp-l2tp-0.4 xl2tpd-1.3.0
tar zxf openswan-2.6.32.tar.gz
tar zxf rp-l2tp-0.4.tar.gz
tar zxf xl2tpd-1.3.0.tar.gz
cd $DOCUMENT_ROOT/../sources/openswan-2.6.32
echo "$distribution" | grep -iqE "debian|ubuntu|centos-7" && sed -i 's/WERROR:=.*/WERROR:=/g' $DOCUMENT_ROOT/../sources/openswan-2.6.32/programs/Makefile.program
make programs install

cd $DOCUMENT_ROOT/../sources/rp-l2tp-0.4
./configure
make
cp handlers/l2tp-control /usr/local/sbin/
mkdir /var/run/xl2tpd/
ln -s /usr/local/sbin/l2tp-control /var/run/xl2tpd/l2tp-control


cd $DOCUMENT_ROOT/../sources/xl2tpd-1.3.0
make
make install

}

config_pptp_l2tp()
{
WANIP=`ifconfig  | grep "inet addr:" | sed 's/Bcast.*//' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | grep -vE "127.0.0.1|255.[0|255]"`
mv /etc/ipsec.conf /etc/ipsec.conf.bak
cat <<EOF > /etc/ipsec.conf
config setup
        dumpdir=/var/run/pluto
        virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12
        nat_traversal=yes
        oe=off
        protostack=netkey

conn ipsec-l2tp
        auto=add
        authby=secret
        pfs=no
        type=transport
        left=$WANIP
        leftprotoport=17/1701
        right=%any
        rightprotoport=17/%any
        rekey=no
        keyingtries=5

EOF

cat <<EOF > /etc/ipsec.secrets
$WANIP %any: PSK "YourSharedSecret"

EOF

mkdir /etc/xl2tpd
mv /etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf.bak
cat <<EOF > /etc/xl2tpd/xl2tpd.conf
[global]
ipsec saref = yes

[lns default]
ip range = 10.10.1.2-10.10.1.254
local ip = 10.10.1.1
refuse chap = yes
refuse pap = yes
require authentication = yes
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes

EOF
mv /etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd.bak
cat <<EOF > /etc/ppp/options.xl2tpd
require-mschap-v2
ms-dns 8.8.8.8
ms-dns 8.8.4.4
asyncmap 0
auth
crtscts
lock
hide-password
modem
debug
name l2tp
proxyarp
lcp-echo-interval 30
lcp-echo-failure 4

EOF

mv /etc/ppp/options.pptpd /etc/ppp/options.pptpd.bak
cat <<EOF > /etc/ppp/options.pptpd
name pptp
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
idle 2592000

ms-dns 8.8.8.8
ms-dns 8.8.4.4

EOF

mv /etc/pptpd.conf /etc/pptpd.conf.bak
cat <<EOF > /etc/pptpd.conf
option /etc/ppp/options.pptpd
logwtmp
localip 10.10.2.1
remoteip 10.10.2.2-254

EOF

sysctl -w net.ipv4.ip_forward=1
sysctl -p
}

chap_secrets_set()
{
mv /etc/ppp/chap-secrets /etc/ppp/chap-secrets.bak
cat <<EOF > /etc/ppp/chap-secrets
# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
turbo	vpn	turbo	*

EOF
}


do_install_pptp_l2tp()
{
check_pptp_l2tp_installed && echo "pptp-l2tp binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_pptp_l2tp" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_pptp_l2tp_Dependence\":\"0\",\"_PS_3_Make_install_pptp_l2tp\":\"0\",\"_PS_4_Config_pptp_l2tp\":\"0\",\"_PS_5_pptp_l2tp_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log" app="pptp-l2tp" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="30"
download_pptp_l2tp > $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_pptp_l2tp" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_2_Make_install_pptp_l2tp_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="45"
install_pptp_l2tp_dependence > $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_3_Make_install_pptp_l2tp"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="60"
make_pptp_l2tp >> $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_pptp_l2tp" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_4_Config_pptp_l2tp"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="80"
config_pptp_l2tp >> $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log 2>&1
chap_secrets_set >> $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_5_Mysql_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_pptp_l2tp" schedule_now="_PS_5_Mysql_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_pptp_l2tp" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_pptp_l2tp" status_now="success"

}
check_pptp_l2tp_installed()
{
which pptpd>/dev/null 2>&1 && which ipsec >/dev/null 2>&1 && which xl2tpd >/dev/null 2>&1 && return 0
[ $? -ne 0 ] && return 1
}
# make_pptp_l2tp
# config_pptp_l2tp
# chap_secrets_set
save_pptp()
{
(echo "$FORM_pptpd_local_ip" | main.sbin regx_str isip_ipv4) || (echo "local_ip Fail" | main.sbin output_json 1) || exit 1
ip1=`echo "$FORM_pptpd_ip_range" | sed 's/-.*//'`
ip2=`echo "$FORM_pptpd_ip_range" | sed 's/.*-//'`
echo "$ip1" | main.sbin regx_str isip_ipv4 || (echo "ip_range Fail" | main.sbin output_json 1) || exit 1
echo "$ip2" | main.sbin regx_str isip_ipv4 || (echo "$ip2" | main.sbin regx_str islang_alb && [ $ip2 -le 255 ]) || (echo "ip_range Fail" | main.sbin output_json 1) || exit 1

for dns in $FORM_pptpd_ms_dns
do
echo "${dns}" | main.sbin regx_str isip_ipv4 || (echo "ms-dns Fail" | main.sbin output_json 1) || exit 1
done
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["pptp"]["local_ip"] = "'"$FORM_pptpd_local_ip"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["pptp"]["ip_range"] = "'"$FORM_pptpd_ip_range"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["pptp"]["ms_dns"] = "'"$FORM_pptpd_ms_dns"'"'`
if
echo "$pptp_xl2tp_str" | jq '.' >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "unknown Fail" | main.sbin output_json 1) || exit 1
fi
}
save_l2tp()
{
(echo "$FORM_xl2tpd_local_ip" | main.sbin regx_str isip_ipv4) || (echo "local_ip Fail" | main.sbin output_json 1) || exit 1
ip1=`echo "$FORM_xl2tpd_ip_range" | sed 's/-.*//'`
ip2=`echo "$FORM_xl2tpd_ip_range" | sed 's/.*-//'`
echo "$ip1" | main.sbin regx_str isip_ipv4 || (echo "ip_range Fail" | main.sbin output_json 1) || exit 1
echo "$ip2" | main.sbin regx_str isip_ipv4 || (echo "$ip2" | main.sbin regx_str islang_alb && [ $ip2 -le 255 ]) || (echo "ip_range Fail" | main.sbin output_json 1) || exit 1

for dns in $FORM_xl2tpd_ms_dns
do
echo "${dns}" | main.sbin regx_str isip_ipv4 || (echo "ms-dns Fail" | main.sbin output_json 1) || exit 1
done
[ -n "$FORM_xl2tpd_ipsec_share_key" ]  || (echo "ipsec_share_key can not be empty" | main.sbin output_json 1) || exit 1
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["local_ip"] = "'"$FORM_xl2tpd_local_ip"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["ip_range"] = "'"$FORM_xl2tpd_ip_range"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["ms_dns"] = "'"$FORM_xl2tpd_ms_dns"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["combine_dev"] = "'"$FORM_xl2tpd_combine_dev"'"'`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["ipsec_share_key"] = "'"$FORM_xl2tpd_ipsec_share_key"'"'`
if
echo "$pptp_xl2tp_str" | jq '.' >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init >/dev/null 2>&1
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "unknown Fail" | main.sbin output_json 1) || exit 1
fi
}
pptp_user_online()
{
user_list=`last | grep still | grep ppp`
[ -n "$user_list" ] || echo "none" &&  echo "$user_list"
}
l2tp_user_online()
{
echo "<pre>"
tail -n 200 /var/log/auth.log
echo "</pre>"
}
pptp_user_control()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
_LANG_App_name="$_LANG_App_name -> PPTP $_LANG_Users_Control"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<EOF
<script>
function del_pptp_user(username)
{
if (confirm("$_LANG_Do_you_want_to " + username)) {
EOF
cat <<'EOF'
    var data = 'app=pptp-l2tp-server&action=del_pptp_user&username=' + username;
    var url = 'index.cgi';
	Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}

$(function(){
  $('#pptp_users_save').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#pptp_user_add').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  });
});
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

cat <<EOF
<legend>PPTP $_LANG_Users_Control</legend>
<table class="table">
<tr><th>$_LANG_Username</th><th>$_LANG_Password</th><th>$_LANG_Option</th></tr>
<form id="pptp_users_save">
EOF
for user in `echo "$pptp_xl2tp_str" | jq '.["pptp_users"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<tr><td>${user}</td><td><input type="text" class="form-control" value="`echo "$pptp_xl2tp_str" | jq -r '.["pptp_users"]["'"${user}"'"]'`" name="password_${user}" placeholder="Enter Password"></td>
<td>
<button type="button" onclick="del_pptp_user('${user}');" class="btn btn-danger">X</button>
<input type="hidden" name="action" value="pptp_users_save">
<input type="hidden" name="username_${user}" value="${user}">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
EOF
done

cat <<EOF
</form>
<form id="pptp_user_add">
<tr>
<td><input type="text" class="form-control" name="username" placeholder="Enter Username"></td><td><input type="text" name="password" class="form-control" placeholder="Enter Password"></td>
<td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button></td>
</tr>
<input type="hidden" name="action" value="pptp_user_add">
</form>
</table>
EOF
cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
pptp_users_save()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
for username in `env | grep "^FORM_username_" |awk -F "=" {'print $2'}`
do
passowd_now=`eval echo '$'FORM_password_${username}`
[ "${passowd_now}" = "$(echo ${passowd_now} | grep -Po '[\w][\w]*')" ] || (echo "${username} Passowd Invalid" | main.sbin output_json 1) || exit 1
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["pptp_users"]["'"${username}"'"] = "'$passowd_now'"'`
done
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
del_pptp_user()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq 'del(.["pptp_users"]["'"$FORM_username"'"])'`
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
(echo "Del success" | main.sbin output_json 0) || exit 0
}
pptp_user_add()
{
[ -n "$FORM_username" ] || (echo "Username Can not be empty" | main.sbin output_json 1) || exit 1
[ -n "$FORM_password" ] || (echo "Password Can not be empty" | main.sbin output_json 1) || exit 1
[ "$FORM_username" = "$(echo $FORM_username | grep -Po '[\w][\w]*')" ] || (echo "Username Valid" | main.sbin output_json 1) || exit 1
[ "$FORM_password" = "$(echo $FORM_password | grep -Po '[\w][\w]*')" ] || (echo "Password Valid" | main.sbin output_json 1) || exit 1

pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["pptp_users"]["'"$FORM_username"'"] = "'$FORM_password'"'`
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
(echo "Del success" | main.sbin output_json 0) || exit 0
}

l2tp_user_control()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
_LANG_App_name="$_LANG_App_name -> L2TP $_LANG_Users_Control"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<'EOF'
<script>
function del_l2tp_user(username)
{
if (confirm("你是想删除 " + username)) {
    var data = 'app=pptp-l2tp-server&action=del_l2tp_user&username=' + username;
    var url = 'index.cgi';
	Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}

$(function(){
  $('#l2tp_users_save').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#l2tp_user_add').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  });
});
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

cat <<EOF
<legend>L2TP $_LANG_Users_Control</legend>
<table class="table">
<tr><th>$_LANG_Username</th><th>$_LANG_Password</th><th>$_LANG_Option</th></tr>
<form id="l2tp_users_save">
EOF
for user in `echo "$pptp_xl2tp_str" | jq '.["l2tp_users"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<tr><td>${user}</td><td><input type="text" class="form-control" value="`echo "$pptp_xl2tp_str" | jq -r '.["l2tp_users"]["'"${user}"'"]'`" name="password_${user}" placeholder="Enter Password"></td>
<td>
<button type="button" onclick="del_l2tp_user('${user}');" class="btn btn-danger">X</button>
<input type="hidden" name="action" value="l2tp_users_save">
<input type="hidden" name="username_${user}" value="${user}">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
EOF
done

cat <<EOF
</form>
<form id="l2tp_user_add">
<tr>
<td><input type="text" class="form-control" name="username" placeholder="Enter Username"></td><td><input type="text" name="password" class="form-control" placeholder="Enter Password"></td>
<td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button></td>
</tr>
<input type="hidden" name="action" value="l2tp_user_add">
</form>
</table>
EOF
cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
l2tp_users_save()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
for username in `env | grep "^FORM_username_" |awk -F "=" {'print $2'}`
do
passowd_now=`eval echo '$'FORM_password_${username}`
[ "${passowd_now}" = "$(echo ${passowd_now} | grep -Po '[\w][\w]*')" ] || (echo "${username} Passowd Invalid" | main.sbin output_json 1) || exit 1
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp_users"]["'"${username}"'"] = "'$passowd_now'"'`
done
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init >/dev/null 2>&1
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
del_l2tp_user()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq 'del(.["l2tp_users"]["'"$FORM_username"'"])'`
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init >/dev/null 2>&1
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
(echo "Del success" | main.sbin output_json 0) || exit 0
}
l2tp_user_add()
{
[ -n "$FORM_username" ] || (echo "Username Can not be empty" | main.sbin output_json 1) || exit 1
[ -n "$FORM_password" ] || (echo "Password Can not be empty" | main.sbin output_json 1) || exit 1
[ "$FORM_username" = "$(echo $FORM_username | grep -Po '[\w][\w]*')" ] || (echo "Username Valid" | main.sbin output_json 1) || exit 1
[ "$FORM_password" = "$(echo $FORM_password | grep -Po '[\w][\w]*')" ] || (echo "Password Valid" | main.sbin output_json 1) || exit 1

pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
pptp_xl2tp_str=`echo "$pptp_xl2tp_str" | jq '.["l2tp_users"]["'"$FORM_username"'"] = "'$FORM_password'"'`
if
echo "$pptp_xl2tp_str" | jq '.' | grep -q "{" >/dev/null 2>&1
then
echo "$pptp_xl2tp_str" > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init >/dev/null 2>&1
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init >/dev/null 2>&1
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
(echo "Del success" | main.sbin output_json 0) || exit 0
}
pre_install_pptp_l2tp()
{
check_pptp_l2tp_env && echo "Ready to install"
}
install_pptp_l2tp()
{

check_pptp_l2tp_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_pptp_l2tp" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/pptp_l2tp_ins_detail.log ] || do_install_pptp_l2tp &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_pptp_l2tp"
get_pregress_schedule_notice_detail
}

pptpd_service()
{
sed -i "s/^enable=.*/enable=$FORM_pptpd_enable/g" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init >/dev/null 2>&1
if
[ $FORM_pptpd_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_pptpd_service_enable" \
				detail="_NOTICE_pptpd_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="pptp-l2tp-server" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_pptpd_service_disable" \
				detail="_NOTICE_pptpd_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="pptp-l2tp-server" \
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

ipsec_service()
{
sed -i "s/^enable=.*/enable=$FORM_ipsec_enable/g" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init >/dev/null 2>&1
if
[ $FORM_pptpd_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_ipsec_service_enable" \
				detail="_NOTICE_ipsec_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="pptp-l2tp-server" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_ipsec_service_disable" \
				detail="_NOTICE_ipsec_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="pptp-l2tp-server" \
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

xl2tpd_service()
{
sed -i "s/^enable=.*/enable=$FORM_xl2tpd_enable/g" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init
$DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init >/dev/null 2>&1
if
[ $FORM_pptpd_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_xl2tpd_service_enable" \
				detail="_NOTICE_xl2tpd_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="pptp-l2tp-server" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_xl2tpd_service_disable" \
				detail="_NOTICE_xl2tpd_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="pptp-l2tp-server" \
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
pptp_dest()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
dest=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
echo "$pptp_xl2tp_str" | jq '.["pptp"]["dest"] = "'"$dest"'"' > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
main.sbin fw_init >/dev/null 2>&1
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
}
l2tp_dest()
{
pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
dest=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
echo "$pptp_xl2tp_str" | jq '.["l2tp"]["dest"] = "'"$dest"'"' > $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json
main.sbin fw_init >/dev/null 2>&1
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
}
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
