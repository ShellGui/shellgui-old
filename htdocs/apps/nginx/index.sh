#!/bin/sh

main()
{
check_nginx_installed || warning
if
[ ! -f $DOCUMENT_ROOT/apps/nginx/nginx_config.json ]
then
config_nginx_default && generate_nginx_config
rm -rf $DOCUMENT_ROOT/apps/nginx/*.config
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_lost_default_config" \
				detail="_NOTICE_nginx_lost_default_config" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" >/dev/null 2>&1
fi
if
[ ! -f $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json ]
then
config_vhost_default && generate_nginx_config
rm -rf $DOCUMENT_ROOT/apps/nginx/*.config
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_lost_vhost_config" \
				detail="_NOTICE_nginx_lost_vhost_config" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" >/dev/null 2>&1
fi
nginx_pid=`ps aux |grep -v grep | grep nginx | grep "^www" | sed -n 1p | awk {'print $2'}`
if
echo $nginx_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $nginx_pid`
if
ls /etc/rc?.d | grep -q "S.*nginx$"
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

cat <<'EOF'
<script>
function del_vhost(vhost)
{
EOF
cat <<EOF
  if (confirm("$_LANG_Do_you_want_to_del " + vhost)) {
EOF
cat <<'EOF'
    var data = "app=nginx&action=del_vhost&vhost="+vhost;
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
function do_disabled_vhost(vhost)
{
EOF
cat <<EOF
  if (confirm("$_LANG_Do_you_want_to_stop " + vhost)) {
EOF
cat <<'EOF'
    var data = "app=nginx&action=do_disabled_vhost&vhost="+vhost;
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
function do_enable_vhost(vhost)
{
EOF
cat <<EOF
  if (confirm("$_LANG_Do_you_want_to_start " + vhost)) {
EOF
cat <<'EOF'
    var data = "app=nginx&action=do_enable_vhost&vhost="+vhost;
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
$(function(){
  $('#nginx_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF
cat <<EOF
<div class="col-md-6">
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="nginx_service">
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
					$_LANG_Nginx_service
						<select name="nginx_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="nginx_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<div class="list-group">
  <a href="/index.cgi?app=nginx&action=base_setting" class="list-group-item list-group-item-warning">$_LANG_Base_setting</a>
  <a href="javascript:;" id="nginx_access_log" class="list-group-item list-group-item-info">$_LANG_Access_log</a>
  <a href="javascript:;" id="nginx_error_log" class="list-group-item list-group-item-danger">$_LANG_Error_log</a>
  <a href="/index.cgi?app=nginx&action=log_tpl" class="list-group-item list-group-item-success">$_LANG_Log_TPL</a>
  <a href="/index.cgi?app=nginx&action=cron_log_split" class="list-group-item list-group-item-warning">$_LANG_Cronjpb_log_split</a>
</div>

</div>
EOF

vhost_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json | jq '.'`
default_ip=`echo "$vhost_str" | jq -r '.["default"]["listen"]["ip"]'`
echo "$default_ip" | main.sbin regx_str isip_ipv4 || default_ip=""
disabled_str=`echo "$vhost_str" | jq -r '.["default"]["disabled_option"]'`

cat <<EOF
<div class="col-md-6">
<legend>$_LANG_vhost</legend>
	<div class="list-group">
	  

		<a href="/index.cgi?app=nginx&action=vhost" class="list-group-item list-group-item-warning"><span class="glyphicon glyphicon-plus"></span>$_LANG_Add_a_new_vhost</a>

		<div class="panel panel-`[ -n "$disabled_str" ] && [ "$disabled_str" != "null" ] && echo danger || echo success`">
		  <div class="panel-heading">

		  <div class="panel-title">
		  <div class="row">
			<div class="col-md-4">
			<a target="_blank" href="http://$SERVER_NAME:$(echo "$vhost_str" | jq -r '.["default"]["listen"]["port"]')"><span class="glyphicon glyphicon-globe"></span>default</a>
			</div>
			<div class="col-md-4">
			$default_ip:`echo "$vhost_str" | jq -r '.["default"]["listen"]["port"]'`
			</div>
			<div class="col-md-4">
			<div class="pull-right">
EOF
if
[ -n "$disabled_str" ] && [ "$disabled_str" != "null" ]
then
cat <<EOF
				  <a onclick="do_enable_vhost('default');"><span class="glyphicon glyphicon-play"></span></a>
				  <a href="/index.cgi?app=nginx&action=disabled_vhost&vhost=default"><span class="glyphicon glyphicon-wrench"></span></a>
EOF
else
cat <<EOF
				  <a onclick="do_disabled_vhost('default');"><span class="glyphicon glyphicon-pause"></span></a>
				  <a href="/index.cgi?app=nginx&action=vhost&vhost=default"><span class="glyphicon glyphicon-wrench"></span></a>
EOF
fi
cat <<EOF

			</div>
			</div>
			</div>
		  </div>
		  
		  </div>
		  <div class="panel-body">
			<div class="row">
				<div class="col-md-4">
EOF
index=`echo "$vhost_str" | jq -r '.["default"]["index"]'`
echo "$index" | grep -q "\.htm" && echo '<img src="/apps/nginx/imgs/lang_html.png" title="html" />'
echo "$index" | grep -q "\.php" && echo '<img src="/apps/nginx/imgs/lang_php.png" title="php" />'
echo "$index" | grep -q "\.jsp" && echo '<img src="/apps/nginx/imgs/lang_jsp.png" title="jsp" />'
echo "$index" | grep -q "\.pl" && echo '<img src="/apps/nginx/imgs/lang_pl.png" title="pl" />'
cat <<EOF
				</div>
				<div class="col-md-4">
				<p class="bg-warning">`echo "$vhost_str" | jq -r '.["default"]["root"]'`</p>
				</div>
				<div class="col-md-4">
				$_LANG_Build_at:`echo "$vhost_str" | jq -r '.["default"]["create_time"]'`
				</div>
			</div>
		  </div>
		</div>
EOF
for vhost in `echo "$vhost_str" | jq '. | keys' | grep -Po '[\w].*[\w]' | grep -v "^default$"`
do
vhost_ip=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["listen"]["ip"]'`
echo "$vhost_ip" | main.sbin regx_str isip_ipv4 || vhost_ip=""
disabled_str=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["disabled_option"]'`
cat <<EOF
		<div class="panel panel-`[ -n "$disabled_str" ] && [ "$disabled_str" != "null" ] && echo danger || echo success`">
		  <div class="panel-heading">

		  <div class="panel-title">
		  <div class="row">
			<div class="col-md-4">
EOF
vhost_used_port=$(echo "$vhost_str" | jq -r '.["default"]["listen"]["port"]')
for vhost_domain in `echo "$vhost_str" | jq -r '.["'${vhost}'"]["server_name"]' | sed 's/[ ]+/\n/g'`
do
cat <<EOF
<a target="_blank" href="http://${vhost_domain}:$vhost_used_port"><span class="glyphicon glyphicon-globe"></span>${vhost_domain}</a>
EOF
done
cat <<EOF
			
			</div>
			<div class="col-md-4">
			$vhost_ip:`echo "$vhost_str" | jq -r '.["'${vhost}'"]["listen"]["port"]'`
			</div>
			<div class="col-md-4">
			<div class="pull-right">
EOF
if
[ -n "$disabled_str" ] && [ "$disabled_str" != "null" ]
then
cat <<EOF
				  <a onclick="do_enable_vhost('${vhost}');"><span class="glyphicon glyphicon-play"></span></a>
				  <a onclick="del_vhost('${vhost}');"><span class="glyphicon glyphicon-remove"></span></a>
				  <a href="/index.cgi?app=nginx&action=disabled_vhost&vhost=${vhost}"><span class="glyphicon glyphicon-wrench"></span></a>
EOF
else
cat <<EOF
				  <a onclick="do_disabled_vhost('${vhost}');"><span class="glyphicon glyphicon-pause"></span></a>
				  <a onclick="del_vhost('${vhost}');"><span class="glyphicon glyphicon-remove"></span></a>
				  <a href="/index.cgi?app=nginx&action=vhost&vhost=${vhost}"><span class="glyphicon glyphicon-wrench"></span></a>
EOF
fi
cat <<EOF
			</div>
			</div>
			</div>
		  </div>
		  
		  </div>
		  <div class="panel-body">
			<div class="row">
				<div class="col-md-4">
EOF
index=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["index"]'`
echo "$index" | grep -q "\.htm" && echo '<img src="/apps/nginx/imgs/lang_html.png" title="html" />'
echo "$index" | grep -q "\.php" && echo '<img src="/apps/nginx/imgs/lang_php.png" title="php" />'
echo "$index" | grep -q "\.jsp" && echo '<img src="/apps/nginx/imgs/lang_jsp.png" title="jsp" />'
echo "$index" | grep -q "\.pl" && echo '<img src="/apps/nginx/imgs/lang_pl.png" title="pl" />'
cat <<EOF
				</div>
				<div class="col-md-4">
				<p class="bg-warning">`echo "$vhost_str" | jq -r '.["'${vhost}'"]["root"]'`</p>
				</div>
				<div class="col-md-4">
				$_LANG_Build_at:`echo "$vhost_str" | jq -r '.["'${vhost}'"]["create_time"]'`
				</div>
			</div>
		  </div>
		</div>
EOF
done
cat <<EOF	
	  </div>
	  </div>
	  
	</div>
</div>


<div class="modal fade" id="nginx_access_logModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_LANG_Access_log</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 500px;">
		<p id="nginx_access_log_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
<script>
\$('#nginx_access_log').on('click', function(){
	var url = 'index.cgi?app=nginx&action=nginx_access_log';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		\$('#nginx_access_log_content').html(data);
		\$('#nginx_access_logModal').modal('show');
	}, 1);
});
</script>
<div class="modal fade" id="nginx_error_logModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_LANG_Error_log</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 500px;">
		<p id="nginx_error_log_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
<script>
\$('#nginx_error_log').on('click', function(){
	var url = 'index.cgi?app=nginx&action=nginx_error_log';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		\$('#nginx_error_log_content').html(data);
		\$('#nginx_error_logModal').modal('show');
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
        <h4 class="modal-title">$_PS_Install_nginx</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_nginx" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Nginx_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=nginx&action=pre_install_nginx';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_nginx()
{
var url = 'index.cgi?app=nginx&action=install_nginx';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_nginx').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_nginx()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/nginx/nginx_lib.sh
. $DOCUMENT_ROOT/apps/nginx/base_setting.sh
. $DOCUMENT_ROOT/apps/nginx/vhost.sh
. $DOCUMENT_ROOT/apps/nginx/log_tpl.sh
. $DOCUMENT_ROOT/apps/nginx/cron_log_split.sh

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi