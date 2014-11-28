#!/bin/sh

main()
{
check_mysql_installed || warning


cat <<'EOF'
<script>
$(function(){
  $('#base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#change_pass').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#mysql_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
        setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#save_my_cnf').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#change_socket_bind_address').on('submit', function(e){
    e.preventDefault();
    var data = "app=mysql&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#mysql_passwd_default').on('click', function(e){
    e.preventDefault();
    if (confirm('Do you want to change mysql password to root?')) {
      var data = "app=mysql&action=mysql_passwd_default";
      var url = 'index.cgi';
      Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
    }
  });
});
</script>
EOF

datadir=`grep "^datadir=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
port=`grep "^port=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
log_error=`grep "^log-error=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
bind_address=`grep "^bind-address=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`
sock=`grep "^socket=" /usr/local/mysql/etc/my.cnf | awk -F "=" {'print $2'}`

cat <<EOF
<div class="row">
	<div class="col-md-6">
	<legend>$_LANG_Base_setting</legend>
	<form id="base_setting">
	<table class="table">
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
	$_LANG_Bind_address
	</td>
	<td>
	<input type="text" class="form-control" name="bind_address" placeholder="localhost or 0.0.0.0" value="`[ -n "$bind_address" ] && echo "$bind_address" || echo "localhost"`">
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
	<input type="text" class="form-control" name="log_error" placeholder="/var/log/mysql/mysqld.log" value="`[ -n "$log_error" ] && echo "$log_error" || echo "/var/log/mysql/mysqld.log"`">
	</td>
	</tr>
	<tr>
	<td>
	$_LANG_Option
	</td>
	<td>
	<input type="hidden" name="action" value="base_setting">
	<button type="submit" class="btn btn-primary">$_LANG_Save</button>
	</td>
	</tr>

	</table>
	</form>
	
	<label>$_LANG_Change_Socket_bind_address</label>
	<div class="row">
	<form id="change_socket_bind_address">
		<div class="col-md-2">
			<select name="mysql_sock_enable">
			  <option value="1" `[ -n "$sock" ] && echo "selected=\"selected\""`>$_LANG_On</option>
			  <option value="0" `[ -z "$sock" ] && echo "selected=\"selected\""`>$_LANG_Off</option>
			</select>
		</div>
		<div class="col-md-8">
		<input type="text" class="form-control" name="socket_bind_address" placeholder="/dev/shm/mysqld.sock" value="`[ -n "$sock" ] && echo "$sock" || echo "/dev/shm/mysqld.sock"`">
		</div>
		<div class="col-md-2">
		<input type="hidden" name="action" value="change_socket_bind_address">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
		</div>
	</form>
	</div>
	
	<legend>$_LANG_Change_password</legend>
	<p class="bg-danger">$_LANG_Only_suitable_for_the_user_to_change_its_own_password</p>
	<form id="change_pass">
	<table class="table">
	<tr>
	<td>
	<label>$_LANG_Username</label>
	<input type="text" class="form-control" name="my_username" placeholder="root">
	<label>$_LANG_Password</label>
	<input type="password" class="form-control" name="my_password" placeholder="$_LANG_root_password_empty_when_new_installtion">
	</td>
	<td>
	<label>$_LANG_New_Password</label>
	<input type="password" class="form-control" name="my_new_passwd" placeholder="Enter a Password">
	<label>$_LANG_Confirm_Password</label>
	<input type="password" class="form-control" name="my_new_passwd_cf" placeholder="Confirm the Password">
	</td>
	</tr>
	<tr>
	<td>
	$_LANG_Option
	</td>
	<td>
	<input type="hidden" name="action" value="change_pass">
	<button type="submit" class="btn btn-primary">$_LANG_Change</button>
	</td>
	</tr>
	</table>
	</form>
	
	<label>Change MySQL password to "root"</label>
	<button type="button" id="mysql_passwd_default" class="btn btn-primary">$_LANG_Change</button>
	
	</div>

	<div class="col-md-6">
	
EOF

mysqld_pid=`ps aux |grep -v grep | grep mysqld | grep "^mysql" | sed -n 1p | awk {'print $2'}`
if
echo $mysqld_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $mysqld_pid`
if
ls /etc/rc?.d | grep -q "S.*mysqld$"
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

cat <<EOF
<div class="controls">
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">$_LANG_Service_Status</h3>
      </div>
      <div class="panel-body">
<div id="ajax-service">
    <form id="mysql_service">
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
        $_LANG_Mysql_service
            <select name="mysql_enable">
              <option value="1" $on_selected>$_LANG_On</option>
              <option value="0" $off_selected>$_LANG_Off</option>
            </select>
        </td>
        <td>
            <input type="hidden" name="action" value="mysql_service">
            <button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
        </td>
        </tr>
        </table>
    </form>
</div>
      </div>
    </div>
  </div>
	
<legend>$_LANG_Text_of_etc_my_cnf</legend>
<form id="save_my_cnf">
<textarea style="width:100%;height:260px" name="my_cnf_str" class="bg-warning">
EOF
cat /usr/local/mysql/etc/my.cnf
cat <<EOF
</textarea>
<input type="hidden" name="action" value="save_my_cnf">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>

<div class="panel panel-warning">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#aria2-setting" class="collapsed">
          <span class="glyphicon glyphicon-comment"></span>$_LANG_Error_log</a>
      </h4>
    </div>
    <div id="aria2-setting" class="panel-collapse collapse" style="height: 0px;">
      <div class="panel-body">
<pre>
EOF
cat $log_error
cat <<EOF
</pre>
	  </div>
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
        <h4 class="modal-title">$_PS_Install_mysql</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-primary" id="install_mysql" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Mysql_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-primary" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=mysql&action=pre_install_mysql';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_mysql()
{
var url = 'index.cgi?app=mysql&action=install_mysql';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_mysql').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_mysql()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/mysql/mysql_lib.sh

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi