#!/bin/sh

main()
{
main.sbin home_index

cat <<'EOF'
<script>
var refreshbrand;
refreshbrand = setInterval("refresh_brand_info()", 3000);
function refresh_brand_info()
{
  var url = 'index.cgi?app=home&action=refresh_brand_info';
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#refresh_brand_info').html(data);
  }, 1);
}
</script>
EOF

echo '<div id="refresh_brand_info">'
refresh_brand_info
echo '</div>'
for type in `cat $DOCUMENT_ROOT/../tmp/home.json  | jq '."apps" | keys[]' | sed -e 's/^"//g' -e 's/"$//g'`
do
cat <<EOF
<div class="heading">
	<h1>`cat $DOCUMENT_ROOT/../tmp/home.json | jq '."i18n"["type"]["'${type}'"]["'$lang'"]' | sed -e 's/^"//g' -e 's/"$//g'`</h1>
</div>
<br><br>
<div class="row">
EOF
	for app in `cat $DOCUMENT_ROOT/../tmp/home.json  | jq '."apps"['\"${type}\"'] | keys[]' | sed -e 's/^"//g' -e 's/"$//g'`
	do
lang_app_name=`cat $DOCUMENT_ROOT/../tmp/home.json  | jq '."i18n"["app"]['\"${app}\"']["'$lang'"]' | sed -e 's/^"//g' -e 's/"$//g'`
cat $DOCUMENT_ROOT/../tmp/home.json | jq '.["apps"]['\"${type}\"']['\"${app}\"']["status"]' | grep -q "active" &&  cat <<EOF
<div class="app" title="${app}">
	<div class="thumbnail">
		<a href="index.cgi?app=${app}"><img src="apps/${app}/icon.png" alt="${lang_app_name}"></a>
			<div class="caption">
			<p><a href="index.cgi?app=${app}">${lang_app_name}</a></p>
		</div>
	</div>
</div>

EOF
	done

echo '</div>'
done
}

refresh_status()
{
# main.sbin nav_status
nav_status_str=`main.sbin nav_status`
eval uptimes_days=`echo "$nav_status_str" | jq '.["uptimes"]["days"]'`
eval uptimes_hours=`echo "$nav_status_str" | jq '.["uptimes"]["hours"]'`
eval uptimes_mins=`echo "$nav_status_str" | jq '.["uptimes"]["mins"]'`
eval uptimes_secs=`echo "$nav_status_str" | jq '.["uptimes"]["secs"]'`
eval hwstatus_cpuload=`echo "$nav_status_str" | jq '.["hwstatus"]["cpuload"]'`
eval hwstatus_memload=`echo "$nav_status_str" | jq '.["hwstatus"]["memload"]'`
nav_status_str=''
eval `cat $DOCUMENT_ROOT/apps/home/i18n/$lang/i18n.conf`
cat <<EOF
<a><span>$_LANG_Runed $uptimes_days $_LANG_Days $uptimes_hours $_LANG_Hours $uptimes_mins $_LANG_Mins $uptimes_secs $_LANG_Secs</span><img src="/apps/home/imgs/cpu.png" alt="alttext" title="titletext" /> $hwstatus_cpuload

<img src="/apps/home/imgs/mem.png" alt="alttext" title="titletext" /> $hwstatus_memload
</a>
EOF
}
change()
{
home_data=`cat $DOCUMENT_ROOT/../tmp/home.json`
echo "$home_data" | jq '.["setting"] = .["setting"] + {"default_lang":"'$FORM_lang'"}' > $DOCUMENT_ROOT/../tmp/home.json
if
main.sbin check_admin_session
then
main.sbin header_jump "$HTTP_REFERER"
exit 0
else
main.sbin header_jump "index.cgi?app=login"
exit 1
fi
}
logout()
{
main.sbin create_admin_session logout
main.sbin header_jump "index.cgi?app=login" && exit 0
}


pre_firewall_restart()
{
echo "$_LANG_Are_you_sure_to_restart_Firewall"
}
pre_power_restart()
{
echo "$_LANG_Are_you_sure_to_reboot"
}
pre_network_restart()
{
echo "$_LANG_Are_you_sure_to_restart_the_Network"
}
logread()
{
echo "<pre>"
lastlog
echo "</pre>"
}
do_tcpudp_port_stat_list()
{
str=`netstat -tulnp | grep -vE "Active Internet connections|Proto.*Recv-Q" | awk '{if ($6 == "LISTEN") print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td></tr>" ; else print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>-</td><td>"$6"</td></tr>"}'`
echo '<table class="table"><tr><td>Proto</td><td>Recv-Q</td><td>Send-Q</td><td>Local Address</td><td>Foreign Address</td><td>State</td><td>PID/Program name</td></tr>'"$str"'</table>';
}
do_tcp_port_stat_list()
{
str=`netstat -tlnp | grep -vE "Active Internet connections|Proto.*Recv-Q" | awk '{if ($6 == "LISTEN") print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td></tr>" ; else print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>-</td><td>"$6"</td></tr>"}'`
echo '<table class="table"><tr><td>Proto</td><td>Recv-Q</td><td>Send-Q</td><td>Local Address</td><td>Foreign Address</td><td>State</td><td>PID/Program name</td></tr>'"$str"'</table>';
}
do_udp_port_stat_list()
{
str=`netstat -ulnp | grep -vE "Active Internet connections|Proto.*Recv-Q" | awk '{if ($6 == "LISTEN") print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td></tr>" ; else print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>-</td><td>"$6"</td></tr>"}'`
echo '<table class="table"><tr><td>Proto</td><td>Recv-Q</td><td>Send-Q</td><td>Local Address</td><td>Foreign Address</td><td>State</td><td>PID/Program name</td></tr>'"$str"'</table>';
}
do_firewall_rule_list()
{
echo '<pre>'"`iptables-save`"'</pre>'
}
do_network_list()
{
echo '<pre>'"`ifconfig -a`"'</pre>'
}
do_network_restart()
{
echo "Restarting Network now..."
service network restart || service networking restart 2>&1
$DOCUMENT_ROOT/../bin/busybox start-stop-daemon -S -b -x $DOCUMENT_ROOT/../bin/main.sbin fw_init

}
do_firewall_restart()
{
echo "Restarting Firewall now..."
$DOCUMENT_ROOT/../bin/busybox start-stop-daemon -S -b -x $DOCUMENT_ROOT/../bin/main.sbin fw_init

}
do_power_restart()
{
echo "Rebooting now..."
$DOCUMENT_ROOT/../bin/busybox start-stop-daemon -S -b -x reboot
}
do_power_off()
{
echo "Power off now..."
$DOCUMENT_ROOT/../bin/busybox start-stop-daemon -S -b -x poweroff
}
pre_cleanmem()
{

echo "<legend>$_LANG_Before_clean</legend><pre>"
grep -Ee '^(MemTotal|MemFree|Buffers|Cached|Active|Inactive):' /proc/meminfo
echo "Percent:		`free | awk '/^Mem/ {printf("%u%%", 100*$3/$2);}'`"
echo "</pre>"
}
do_cleanmem()
{
echo "<legend>$_LANG_Before_clean</legend><pre>"
grep -Ee '^(MemTotal|MemFree|Buffers|Cached|Active|Inactive):' /proc/meminfo
echo "Percent:		`free | awk '/^Mem/ {printf("%u%%", 100*$3/$2);}'`"
echo "</pre>"
echo 3 > /proc/sys/vm/drop_caches
echo "<legend>$_LANG_After_clean</legend><pre>"
grep -Ee '^(MemTotal|MemFree|Buffers|Cached|Active|Inactive):' /proc/meminfo
echo "Percent:		`free | awk '/^Mem/ {printf("%u%%", 100*$3/$2);}'`"
echo "</pre>"
}

. $DOCUMENT_ROOT/apps/home/brandwidth.tpl.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi
