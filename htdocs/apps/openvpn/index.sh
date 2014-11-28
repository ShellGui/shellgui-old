#!/bin/sh

main()
{
check_openvpn_installed || warning

cat <<'EOF'
<script>
$(function(){
  $('#wan_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=openvpn&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'wan_dest');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#openvpn_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=openvpn&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#save_openvpn_conf').on('submit', function(e){
    e.preventDefault();
    var data = "app=openvpn&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=openvpn&"+$(this).serialize();
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
openvpn_pid=`ps aux | grep "openvpn[ ]*" | grep -v grep  | grep "^openv" | sed -n 1p | awk {'print $2'}`
if
echo $openvpn_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $openvpn_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/openvpn/S901openvpn.init
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
	<form id="openvpn_service">
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
		$_LANG_OpenVPN_service
			<select name="openvpn_enable">
			  <option value="1" $on_selected>$_LANG_On</option>
			  <option value="0" $off_selected>$_LANG_Off</option>
			</select>
		</td>
		<td>
			<input type="hidden" name="action" value="openvpn_service">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			<a class="btn btn-info" href="javascript:;" id="openvpn_status"><span class="glyphicon glyphicon-th"></span>Status</a>
		</td>
		</tr>
		</table>
	</form>
</div>
      </div>
	</div>
EOF
port=`grep -E "^port[ ]*[0-9][0-9]*" /etc/openvpn/openvpn.conf | grep -Po '[0-9]*'`
proto=`grep "^proto" /etc/openvpn/openvpn.conf | awk {'print $2'}`
server_str=`grep -E "^server[ ]*(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])[ ]*(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])" /etc/openvpn/openvpn.conf`
server_ip=`echo "$server_str" | awk {'print $2'}`
server_mask=`echo "$server_str" | awk {'print $3'}`
dns_str=`grep "^push \"dhcp-option " /etc/openvpn/openvpn.conf | grep -Po '((25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|[1-9])'`
dns1=`echo "$dns_str" | sed -n 1p`
dns2=`echo "$dns_str" | sed -n 2p`
push_route=`grep "^push \"route " /etc/openvpn/openvpn.conf | grep -Po '\".*\"' | grep -Po '[0-9].*[0-9]'`
cat <<EOF
<form id="base_setting">
<table class="table">
<tr>
<td>port</td>
<td>
<input class="form-control" placeholder="1194" name="port" value="$port">
</td>
</tr>
<tr>
<td>proto</td>
<td>
<select class="form-control" name="proto">
	<option value="udp" `echo "$proto" | grep -q "udp" && echo "selected"`>udp</option>
	<option value="tcp" `echo "$proto" | grep -q "tcp" && echo "selected"`>tcp</option>
</select>
</td>
</tr>
<tr>
<td>server_ip</td>
<td>
<input class="form-control" placeholder="10.0.0.0" name="server_ip" value="$server_ip">
</td>
</tr>
<tr>
<td>server_mask</td>
<td>
<input class="form-control" placeholder="255.255.255.0" name="server_mask" value="$server_mask">
</td>
</tr>
<tr>
<td>dns1</td>
<td>
<input class="form-control" placeholder="8.8.8.8" name="dns1" value="$dns1">
</td>
</tr>
<tr>
<td>dns2</td>
<td>
<input class="form-control" placeholder="114.114.114.114" name="dns2" value="$dns2">
</td>
</tr>
<tr>
<td>push_route</td>
<td>
<input class="form-control" placeholder="192.168.2.0 255.255.255.0" name="push_route" value="$push_route">
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
eval `cat $DOCUMENT_ROOT/apps/openvpn/openvpn_extra.conf`
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
<legend>$_LANG_Text_of_etc_openvpn_ini</legend>
<form id="save_openvpn_conf">
<textarea style="width:100%;height:260px" name="openvpn_conf_str" class="bg-warning">
EOF
cat /etc/openvpn/openvpn.conf
cat <<EOF
</textarea>
<input type="hidden" name="action" value="save_openvpn_conf">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>


	</div>

	<div class="col-md-6">
	<legend>证书管理</legend>
EOF

eval `grep -vE "^$|^#|^;" /etc/openvpn/easy-rsa/vars | grep "="`
cat <<'EOF'
<script>
$('#openvpn_status').on('click', function(){
	var url = 'index.cgi?app=openvpn&action=openvpn_status';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#ssl_detail_content').html(data);
		$('#ssl_detail_Modal').modal('show');
	}, 1);
});
$(function(){
  $('#build_new').on('submit', function(e){
    e.preventDefault();
    var data = "app=openvpn&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
	setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF

cat <<EOF
<form id="build_new">
<table class="table">
<tr>
<td>
$_LANG_Country
</td>
<td>
<input class="form-control" placeholder="Country" name="SSL_C" value="$KEY_COUNTRY">
</td>
</tr>
<tr>
<td>
$_LANG_Provinces
</td>
<td>
<input class="form-control" placeholder="State" name="SSL_ST" value="$KEY_PROVINCE">
</td>
</tr>
<tr>
<td>
$_LANG_City
</td>
<td>
<input class="form-control" placeholder="Location" name="SSL_L" value="$KEY_CITY">
</td>
</tr>
<tr>
<td>
$_LANG_Organization
</td>
<td>
<input class="form-control" placeholder="Organization" name="SSL_O" value="$KEY_ORG">
</td>
</tr>
<tr>
<td>
$_LANG_Organizational_unit
</td>
<td>
<input class="form-control" placeholder="Organizational Unit" name="SSL_OU" value="$KEY_OU">
</td>
</tr>
<tr>
<td>
$_LANG_Common_name
</td>
<td>
<input class="form-control" placeholder="Common Name" name="SSL_CN" value="">
</td>
</tr>
<tr>
<td>
E-Mail
</td>
<td>
<input class="form-control" placeholder="Common Name" name="KEY_EMAIL" value="example@examlpe.com">
</td>
</tr>
<tr>
<td>
$_LANG_Guarantee
</td>
<td>
<div class="row">
	<div class="col-md-6">
<input class="form-control" placeholder="Common Name" name="SSL_Guarantee" value="$CA_EXPIRE">
	</div>
	<div class="col-md-6">
	$_LANG_Days
	</div>
</div>
</td>
</tr>
<tr>
<td>
当前证书大小
</td>
<td>
$key_size
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="build_new">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>

<script>
function get_ssl_detail_html(file)
{
	var url = 'index.cgi?app=openvpn&action=get_ssl_detail_html&file=' + file;
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		\$('#ssl_detail_content').html(data);
		\$('#ssl_detail_Modal').modal('show');
	}, 1);
};
function del_ssl(crt_file)
{
if (confirm("Do you wan to del " + crt_file)) {
    var data = 'app=openvpn&action=del_ssl&crt_file=' + crt_file;
    var url = 'index.cgi';
	Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
</script>

<div class="modal fade" id="ssl_detail_Modal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">SSL 信息</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<div id="ssl_detail_content"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
      </div>
    </div>
  </div>
</div>

<table class="table">
EOF
	for crt_file in `echo ca.crt && echo server.crt && ls /etc/openvpn/easy-rsa/keys/ | grep "\.crt$" | grep -vE "ca.crt|server.crt"`
	do
cat <<EOF
<tr><td><a onclick="get_ssl_detail_html('${crt_file}');">${crt_file}</a></td><td>
EOF
if
[ "${crt_file}" != "ca.crt" ] && [ "${crt_file}" != "server.crt" ]
then
cat <<EOF
<a class="btn btn-primary" href="/index.cgi?app=openvpn&action=download&crt_file=${crt_file}" type="button">$_LANG_Download</a>
<a class="btn btn-danger" onclick="del_ssl('${crt_file}');"  type="button">$_LANG_Del</a>
EOF
fi
cat <<EOF
</td></tr>
EOF
	done

cat <<EOF
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
        <h4 class="modal-title">$_PS_Install_openvpn</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_openvpn" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_OpenVPN_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=openvpn&action=pre_install_openvpn';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_openvpn()
{
var url = 'index.cgi?app=openvpn&action=install_openvpn';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_openvpn').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_openvpn()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/openvpn/openvpn_lib.sh

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi
