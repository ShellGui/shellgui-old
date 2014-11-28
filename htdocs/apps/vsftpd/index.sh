#!/bin/sh
main()
{
vsftpd_pid=`ps aux | grep "vsftpd[ ]*" | grep -v grep  | grep "^root" | sed -n 1p | awk {'print $2'}`
echo "$vsftpd_pid" >/tmp/1
if
echo $vsftpd_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $vsftpd_pid`
if
ls /etc/rc?.d | grep -q "S.*vsftpd$"
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

vsftpd_setting=`cat $DOCUMENT_ROOT/apps/vsftpd/vsftpd_setting.conf`
cat <<'EOF'
<script>
$(function(){
  $('#vsftpd_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#access_control_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'access_control_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#anonymous_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'anonymous_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#file_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'file_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#global_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'global_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#infomation_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'infomation_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#local_user_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'local_user_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#pam_auth_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'pam_auth_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#path_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'path_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#security_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'security_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#server_performance_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'server_performance_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#server_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'server_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#timeout_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'timeout_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#transfer_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'transfer_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#user_options_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'user_options_setting');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#wan_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=vsftpd&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'wan_dest');
//	setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF

check_vsftpd_installed || warning
eval `cat $vsftpd_config_dir/vsftpd.conf | grep -v "#"`

cat <<EOF
<div class="col-md-6">
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="vsftpd_service">
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
					$_LANG_vsftpd_service
						<select name="vsftpd_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="vsftpd_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

</div>
<div class="col-md-6">
<legend>Available ftp local users</legend>
EOF
users=`grep -vE "^[a-zA-Z0-9-]*:(\\!|\\$|\\*)*:" /etc/shadow | awk -F ":" '{print $1}'`
for user in `grep -E "^[a-zA-Z0-9-]*$" $vsftpd_config_dir/ftpusers`
do
users=`echo "$users" | grep -v "^${user}$"`
done
echo "$users"
cat <<EOF
</div>
<div class="col-md-12">
EOF
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
eval `cat $DOCUMENT_ROOT/apps/vsftpd/vsftpd_extra.conf`

cat <<EOF
<form class="form-inline" role="form" id="wan_dest">
<label>Enable PASV Port From</label>
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

<ul class="nav nav-tabs" role="tablist">
  <li role="presentation" class="active"><a href="#tab_global_setting" role="tab" data-toggle="tab">$_LANG_global_setting</a></li>
  <li role="presentation"><a href="#tab_anonymous_setting" role="tab" data-toggle="tab">$_LANG_anonymous_setting</a></li>
  <li role="presentation"><a href="#tab_local_user_setting" role="tab" data-toggle="tab">$_LANG_local_user_setting</a></li>
  <li role="presentation"><a href="#tab_pam_setting" role="tab" data-toggle="tab">$_LANG_pam_setting</a></li>
  <li role="presentation"><a href="#tab_access_setting" role="tab" data-toggle="tab">$_LANG_access_setting</a></li>
  <li role="presentation"><a href="#tab_timeout_setting" role="tab" data-toggle="tab">$_LANG_timeout_setting</a></li>
  <li role="presentation"><a href="#tab_server_setting" role="tab" data-toggle="tab">$_LANG_server_setting</a></li>
  <li role="presentation"><a href="#tab_server_performance_setting" role="tab" data-toggle="tab">$_LANG_server_performance_setting</a></li>
  <li role="presentation"><a href="#tab_infomation_setting" role="tab" data-toggle="tab">$_LANG_infomation_setting</a></li>
  <li role="presentation"><a href="#tab_file_setting" role="tab" data-toggle="tab">$_LANG_file_setting</a></li>
  <li role="presentation"><a href="#tab_path_setting" role="tab" data-toggle="tab">$_LANG_path_setting</a></li>
  <li role="presentation"><a href="#tab_user_options_setting" role="tab" data-toggle="tab">$_LANG_user_options_setting</a></li>
  <li role="presentation"><a href="#tab_transfer_setting" role="tab" data-toggle="tab">$_LANG_transfer_setting</a></li>
  <li role="presentation"><a href="#tab_security_setting" role="tab" data-toggle="tab">$_LANG_security_setting</a></li>
</ul>

<!-- Tab panes -->
<div class="tab-content">
  <div role="tabpanel" class="tab-pane active" id="tab_global_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/global_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_anonymous_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/anonymous_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_local_user_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/local_user_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_pam_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/pam_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_access_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/access_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_timeout_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/timeout_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_server_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/server_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_server_performance_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/server_performance_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_infomation_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/infomation_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_file_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/file_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_path_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/path_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_user_options_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/user_options_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_transfer_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/transfer_setting.sh
cat <<EOF
  </div>
  <div role="tabpanel" class="tab-pane" id="tab_security_setting">
EOF
. $DOCUMENT_ROOT/apps/vsftpd/libs/security_setting.sh
cat <<EOF
  </div>
</div>





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
        <h4 class="modal-title">$_PS_Install_vsftpd</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_vsftpd" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_vsftpd_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=vsftpd&action=pre_install_vsftpd';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_vsftpd()
{
var url = 'index.cgi?app=vsftpd&action=install_vsftpd';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_vsftpd').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_vsftpd()", 5000);

});
</script>
EOF
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf` >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/vsftpd/vsftpd_lib.sh >/dev/null 2>&1

if
echo "$OS" | grep -iq "centos"
then
vsftpd_config_dir=/etc/vsftpd
fi
if
echo "$OS" | grep -iq "ubuntu"
then
vsftpd_config_dir=/etc
fi
if
echo "$OS" | grep -iq "debian"
then
vsftpd_config_dir=/etc
fi

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi