#!/bin/sh
main()
{
dnsmasq_pid=`ps aux | grep -v grep | grep "dnsmasq" | grep "^nobody" | sed -n 1p | awk {'print $2'}`
if
echo $dnsmasq_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $dnsmasq_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/dnsmasq/S390dnsmasq.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

dnsmasq_setting=`cat $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_setting.conf`
cat <<'EOF'
<script>
$(function(){
  $('#dnsmasq_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnsmasq&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnsmasq&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-base_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF

check_dnsmasq_installed || warning
server_str=`echo "$dnsmasq_setting" | jq -r '.["server"] | keys' | grep -Po '[\w].*[\w]'`
addn_hosts_str=`for each in $(echo "$dnsmasq_setting" | jq -r '.["addn-hosts"] | keys' | grep -Po '[\w].*[\w]')
do
echo ${each} $(echo "$dnsmasq_setting" | jq -r '.["addn-hosts"]["'${each}'"]')
done`
bogus_nxdomain_str=`echo "$dnsmasq_setting" | jq -r '.["bogus-nxdomain"] | keys' | grep -Po '[\w].*[\w]'`
cat <<EOF
<div class="col-md-6">
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="dnsmasq_service">
					<table class="table">
					<tr>
					<td>
						$status_icon
						$_LANG_Start_at:$pid_start_date
					</td>
					<td>
						$_LANG_Runed:$pid_runs
					</td>
					</tr>
					<tr>
					<td>
					$_LANG_DNSmasq_service
						<select name="dnsmasq_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="dnsmasq_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<div class="row" id="ajax-base_setting">
<legend>DNSmasq base-setting</legend>
<form id="base_setting">
<table class="table">
<tr>
<th>
no-resolv
</th>
<td>
<select name="no_resolv">
  <option value="1" `[ $(echo "$dnsmasq_setting" | jq -r '.["no-resolv"]') -eq 1 ] && echo "selected=\"selected\""`>开</option>
  <option value="0" `[ $(echo "$dnsmasq_setting" | jq -r '.["no-resolv"]') -ne 1 ] && echo "selected=\"selected\""`>关</option>
</select>
</td>
</tr>
<tr>
<th>
server
</th>
<td>
<textarea style="width:100%;height:140px" name="server" placeholder="8.8.8.8" class="bg-warning">$server_str</textarea>
</td>
</tr>
<tr>
<th>addn-hosts</th>
<td>
<textarea style="width:100%;height:140px" name="addn_hosts" placeholder="8.8.8.8 www.xx.com" class="bg-warning">$addn_hosts_str</textarea>
</td>
</tr>
<tr>
<th>bogus-nxdomain</th>
<td>
<textarea style="width:100%;height:140px" name="bogus_nxdomain" placeholder="202.106.199.34" class="bg-warning">$bogus_nxdomain_str</textarea>
</td>
</tr>
<tr>
<th>Option
</th>
<td>
<input type="hidden" name="action" value="base_setting">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>
</div>

<div class="row">
<legend>dhcp.leases</legend>
<pre>`cat /tmp/dhcp.leases`</pre>
</div>

</div>
<div class="col-md-6">
EOF
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
for lan_zone in `echo "$netzone_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
start_ip=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'${lan_zone}'"]["start_ip"]'`
end_ip=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'${lan_zone}'"]["end_ip"]'`
expand_time=`echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'${lan_zone}'"]["expand_time"]'`
[ "$start_ip" = "null" ] && start_ip=""
[ "$end_ip" = "null" ] && end_ip=""
[ "$expand_time" = "null" ] && expand_time=""

cat <<EOF
<script>
\$(function(){
  \$('#set_lanzone_${lan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnsmasq&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-${lan_zone}');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
<div id="ajax-${lan_zone}">
<form id="set_lanzone_${lan_zone}">
<label>${lan_zone}</label>
<table class="table">
<tr>
<th>DHCP Server</th>
<td><input type="checkbox" name="enable" value="1" `[ "$(echo "$dnsmasq_setting" | jq -r '.["interfaces"]["'${lan_zone}'"]["enable"]')" = "1" ] && echo checked`></td>
</tr>
<tr>
<tr>
<th>Gateway IP</th>
<td>`echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["ip"]'`</td>
</tr>
<th>Start IP</th>
<td><input class="form-control" type="text" placeholder="100" name="start_ip" value="$start_ip"></td>
</tr>
<tr>
<th>End IP</th>
<td><input class="form-control" type="text" placeholder="254" name="end_ip" value="$end_ip"></td>
</tr>
<tr>
<th>Expand time</th>
<td><input class="form-control" type="text" placeholder="24h" name="expand_time" value="$expand_time"></td>
</tr>
<tr>
<th>Option</th>
<td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button></td>
</tr>
</table>
<input type="hidden" name="action" value="set_lanzone_${lan_zone}">
<input type="hidden" name="lan_zone" value="${lan_zone}">
</form>
</div>

EOF
done

cat <<EOF
</div>
</div>
EOF
}

warning()
{
cat <<EOF
<div class="container">
<div class="modal fade" id="fix_Modal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_PS_Install_DNSmasq</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_dnsmasq" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_DNSmasq_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=dnsmasq&action=pre_install_dnsmasq';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_dnsmasq()
{
var url = 'index.cgi?app=dnsmasq&action=install_dnsmasq';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_dnsmasq').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_dnsmasq()", 5000);

});
</script>
EOF
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf` >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/dnsmasq/dnsmasq_lib.sh >/dev/null 2>&1
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ] && echo "$FORM_action" | grep -q "set_lanzone_"
then
set_lanzone
else
$FORM_action
fi