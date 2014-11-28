#!/bin/sh

main()
{
check_tinc_installed || warning

cat <<'EOF'
<script>
$(function(){
  $('#wan_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=tinc&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'wan_dest');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#tinc_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=tinc&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=tinc&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
		setTimeout("window.location.reload();", 2000);
  });
});
</script>
EOF

cat <<EOF
<div class="row">
	<div class="col-md-6">
	
EOF
tinc_pid=`ps aux | grep "tincd[ ]*" | grep -v grep  | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $tinc_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $tinc_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/tinc/S902tinc.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi
cat <<EOF
	<div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">$_LANG_Service_Status</h3>
      </div>
      <div class="panel-body">
<div id="ajax-service">
	<form id="tinc_service">
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
		$_LANG_Tinc_service
			<select name="tinc_enable">
			  <option value="1" $on_selected>$_LANG_On</option>
			  <option value="0" $off_selected>$_LANG_Off</option>
			</select>
		</td>
		<td>
			<input type="hidden" name="action" value="tinc_service">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</td>
		</tr>
		</table>
	</form>
</div>
      </div>
	</div>
EOF

port=`grep -E "^Port[ ]*=[ ]*[0-9]*" /data/tinc/etc/tinc/default/tinc.conf | grep -Po '[0-9]*'`
Server_Address=`grep -E "Address[ ]*=" /data/tinc/etc/tinc/default/hosts/server | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`
VPN_GATEWAY=`grep -E "VPN_GATEWAY" /data/tinc/etc/tinc/default/tinc-up | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`

cat <<EOF
<form id="base_setting">
<table class="table">
<tr>
<td>port</td>
<td>
<input class="form-control" placeholder="655" name="port" value="$port">
</td>
</tr>
<tr>
<td>Server Address</td>
<td>
<input class="form-control" placeholder="1.2.3.4" name="Server_Address" value="$Server_Address">
</td>
</tr>
<tr>
<td>VPN GATEWAY</td>
<td>
<input class="form-control" placeholder="10.10.0.1" name="VPN_GATEWAY" value="$VPN_GATEWAY">
</td>
</tr>
<tr>
<td>$_LANG_Option</td>
<td>
<input type="hidden" name="action" value="base_setting">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>
EOF

netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
eval `cat $DOCUMENT_ROOT/apps/tinc/tinc_extra.conf`
cat <<EOF
<form class="form-inline" role="form" id="wan_dest">
<label>Nat From:</label>
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$dest_wan" | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="wan_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>

	</div>

	<div class="col-md-6">
	<legend>证书管理</legend>
EOF

cat <<'EOF'

<script>
function del_client_file(client_file)
{
if (confirm("Do you wan to del " + client_file)) {
    var data = 'app=tinc&action=del_client_file&client_file=' + client_file;
    var url = 'index.cgi';
	Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
$(function(){
  $('#save_client').on('submit', function(e){
    e.preventDefault();
    var data = "app=tinc&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#new_client').on('submit', function(e){
    e.preventDefault();
    var data = "app=tinc&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  });
});
</script>
EOF
cat <<EOF
<table class="table">
<tr><td>Client</td><td>IP/Mask</td><td>Option</td></tr>
<tr>
<form id="new_client">
<td><input class="form-control" placeholder="username" name="new_client_name" value=""></td>
<td><input class="form-control" placeholder="10.10.0.100/32" name="new_client_subnet" value=""></td>
<td>
<input type="hidden" name="action" value="new_client">
<button class="btn btn-primary" id="_submit" type="submit">Add</button>
</td>
</form>
</tr>
<form id="save_client">
EOF
	for client_file in `ls /data/tinc/etc/tinc/default/hosts/ | grep -v "^server$"`
	do
Client_Subnet=`grep -E "^Subnet[ ]*=" /data/tinc/etc/tinc/default/hosts/${client_file} | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])/[1-9][0-9]*'`
cat <<EOF
<tr><td>${client_file}</td><td><input class="form-control" placeholder="10.10.0.100" name="ip_${client_file}" value="$Client_Subnet"></td><td>
<a class="btn btn-primary" href="/index.cgi?app=tinc&action=download&client_file=${client_file}" type="button">$_LANG_Download</a>
<a class="btn btn-danger" onclick="del_client_file('${client_file}');"  type="button">$_LANG_Del</a>
</td></tr>
EOF
	done

cat <<EOF
<tr>
<td>Option</td>
<td>
<input type="hidden" name="action" value="save_client">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</form>
</table>
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
        <h4 class="modal-title">$_PS_Install_tinc</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_tinc" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Tinc_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=tinc&action=pre_install_tinc';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_tinc()
{
var url = 'index.cgi?app=tinc&action=install_tinc';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_tinc').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_tinc()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/tinc/tinc_lib.sh

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi