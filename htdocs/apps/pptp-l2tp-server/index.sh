#!/bin/sh

main()
{
check_pptp_l2tp_installed || warning

pptp_xl2tp_str=`cat $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp-l2tp-server.json`
all_devs=`grep [0-9] /proc/net/dev | sed -e 's/:.*//' -e 's/[ ]*//' | grep -v lo`

pptpd_pid=`ps aux |grep -v grep | grep pptpd | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $pptpd_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $pptpd_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S210pptpd.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#save_pptp').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#save_l2tp').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#pptp_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#l2tp_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#pptpd_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
    setTimeout("window.location.reload();", 1000);
  });
});
$(function(){
  $('#ipsec_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
    setTimeout("window.location.reload();", 1000);
  });
});
$(function(){
  $('#xl2tpd_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=pptp-l2tp-server&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
    setTimeout("window.location.reload();", 1000);
  });
});
</script>
EOF
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
cat <<EOF
<div class="col-md-6">
<legend>PPTP $_LANG_Service</legend>
<div class="controls">
<a class="btn btn-info" href="javascript:;" id="pptp_user_online"><span class="glyphicon glyphicon-file"></span>$_LANG_Online_Users</a>
<a class="btn btn-primary" href="/index.cgi?app=pptp-l2tp-server&action=pptp_user_control"><span class="glyphicon glyphicon-user"></span>$_LANG_Users_Control</a>
<p>
<form class="form-inline" role="form" id="pptp_dest">
<label>Nat from</label>
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$pptp_xl2tp_str" | jq '.["pptp"]["dest"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="pptp_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
<p>
</div>
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="pptpd_service">
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
					$_LANG_pptpd_service
						<select name="pptpd_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="pptpd_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<form id="save_pptp">
<table class="table">
<tr><td>local_ip</td><td><input type="text" class="form-control" name="pptpd_local_ip" placeholder="10.10.1.1" value="`echo "$pptp_xl2tp_str" | jq -r '.["pptp"]["local_ip"]'`"></td></tr>
<tr><td>ip_range</td><td><input type="text" class="form-control" name="pptpd_ip_range" placeholder="10.10.1.2-10.10.1.254" value="`echo "$pptp_xl2tp_str" | jq -r '.["pptp"]["ip_range"]'`"></td></tr>
<tr><td>ms_dns</td><td><input type="text" class="form-control" name="pptpd_ms_dns" placeholder="8.8.8.8 8.8.4.4" value="`echo "$pptp_xl2tp_str" | jq -r '.["pptp"]["ms_dns"]'`"></td></tr>
<tr><td>option</td><td><button type="submit" class="btn btn-primary">$_LANG_Save</button></td></tr>
</table>
<input type="hidden" name="action" value="save_pptp">
</form>
</div>
<div class="col-md-6">
<legend>IPSEC L2TP $_LANG_Service</legend>
<div class="controls">
<a class="btn btn-info" href="javascript:;" id="l2tp_user_online"><span class="glyphicon glyphicon-file"></span>$_LANG_Users_Log</a>
<a class="btn btn-primary" href="/index.cgi?app=pptp-l2tp-server&action=l2tp_user_control"><span class="glyphicon glyphicon-user"></span>$_LANG_Users_Control</a>
<p>
<form class="form-inline" role="form" id="l2tp_dest">
<label>Nat from</label>
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$pptp_xl2tp_str" | jq '.["l2tp"]["dest"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="l2tp_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
<p>
</div>
EOF
ipsec_pid=`ps aux |grep -v grep | grep ipsec | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $ipsec_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $ipsec_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S220ipsec.init
then
ipsec_on_selected="selected=\"selected\""
else
ipsec_off_selected="selected=\"selected\""
fi
cat <<EOF
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="ipsec_service">
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
					$_LANG_ipsec_service
						<select name="ipsec_enable">
						  <option value="1" $ipsec_on_selected>$_LANG_On</option>
						  <option value="0" $ipsec_off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="ipsec_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

EOF
xl2tpd_pid=`ps aux |grep -v grep | grep xl2tpd | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $xl2tpd_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $xl2tpd_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/pptp-l2tp-server/S230xl2tpd.init
then
l2tp_on_selected="selected=\"selected\""
else
l2tp_off_selected="selected=\"selected\""
fi
cat <<EOF
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="xl2tpd_service">
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
					$_LANG_xl2tpd_service
						<select name="xl2tpd_enable">
						  <option value="1" $l2tp_on_selected>$_LANG_On</option>
						  <option value="0" $l2tp_off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="xl2tpd_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<form id="save_l2tp">
<table class="table">
<tr><td>local_ip</td><td><input type="text" class="form-control" name="xl2tpd_local_ip" placeholder="10.10.2.1" value="`echo "$pptp_xl2tp_str" | jq -r '.["l2tp"]["local_ip"]'`"></td></tr>
<tr><td>ip_range</td><td><input type="text" class="form-control" name="xl2tpd_ip_range" placeholder="10.10.1.2-10.10.1.254" value="`echo "$pptp_xl2tp_str" | jq -r '.["l2tp"]["ip_range"]'`"></td></tr>
<tr><td>ms_dns</td><td>
<input type="text" class="form-control" name="xl2tpd_ms_dns" placeholder="8.8.8.8 8.8.4.4" value="`echo "$pptp_xl2tp_str" | jq -r '.["l2tp"]["ms_dns"]'`"></td></tr>
<tr><td>combine_ip</td><td>
	<select class="form-control" name="xl2tpd_combine_dev">
EOF
xl2tpd_combine_dev=`echo "$pptp_xl2tp_str" | jq -r '.["l2tp"]["combine_dev"]'`
for dev in $all_devs
do
dev_ip=`ifconfig ${dev} | grep "inet addr:" | sed 's/Bcast.*//' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
cat <<EOF
								  <option value="${dev}" `[ "$xl2tpd_combine_dev" = "${dev}" ] && echo selected=\"selected\"`>${dev} `[ -n "$dev_ip" ] && echo "($dev_ip)"`</option>
EOF
done
cat <<EOF
	</select>
</td></tr>
<tr><td>ipsec_share_key</td><td><input type="text" class="form-control" name="xl2tpd_ipsec_share_key" placeholder="YourSharedSecret" value="`echo "$pptp_xl2tp_str" | jq -r '.["l2tp"]["ipsec_share_key"]'`"></td></tr>
<tr><td>option</td><td><button type="submit" class="btn btn-primary">$_LANG_Save</button></td></tr>
</table>
<input type="hidden" name="action" value="save_l2tp">
</form>
</div>
EOF

cat <<EOF
<div class="modal fade" id="pptp_user_onlineModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_LANG_Online_Users</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 500px;">
		<p id="pptp_user_online_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
<script>
\$('#pptp_user_online').on('click', function(){
	var url = 'index.cgi?app=pptp-l2tp-server&action=pptp_user_online';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		\$('#pptp_user_online_content').html(data);
		\$('#pptp_user_onlineModal').modal('show');
	}, 1);
});
</script>
<div class="modal fade" id="l2tp_user_onlineModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_LANG_Users_Log</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 500px;">
		<p id="l2tp_user_online_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
<script>
\$('#l2tp_user_online').on('click', function(){
	var url = 'index.cgi?app=pptp-l2tp-server&action=l2tp_user_online';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		\$('#l2tp_user_online_content').html(data);
		\$('#l2tp_user_onlineModal').modal('show');
	}, 1);
});
</script>
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
        <h4 class="modal-title">$_PS_Install_pptp_l2tp</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_pptp_l2tp" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_pptp_l2tp_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=pptp-l2tp-server&action=pre_install_pptp_l2tp';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_pptp_l2tp()
{
var url = 'index.cgi?app=pptp-l2tp-server&action=install_pptp_l2tp';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_pptp_l2tp').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_pptp_l2tp()", 5000);

});
</script>
EOF
}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/pptp-l2tp-server/pptp_l2tp_server_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi