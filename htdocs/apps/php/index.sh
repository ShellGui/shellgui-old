#!/bin/sh

main()
{
check_php_installed || warning
if
[ ! -x /usr/local/mysql/bin/mysqld ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_install_need_mysql_first" \
				detail="_NOTICE_php_install_need_mysql_first" \
				uniqid="php_install_need_mysql_first" \
				time="" \
				ergen="red" \
				dest="mysql" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="unmark_uniq" uniqid="php_install_need_mysql_first" >/dev/null 2>&1
fi

cat <<'EOF'
<script>
$(function(){
  $('#base_setting_fpm').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#base_setting_socket').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#php_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#change_mysqli_default_socket').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#change_time_zone').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#save_php_ini').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#save_php_fpm_conf').on('submit', function(e){
    e.preventDefault();
    var data = "app=php&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
</script>
EOF


listen=`grep -v "^;" /usr/local/php/etc/php-fpm.conf | grep -P '[\w]' | grep "^listen[ ]*=[ ]*" | awk -F "=" {'print $2'} | sed 's/[ ]*//g'`
if
echo "$listen" | grep -qE "^/"
then
mode="socket"
socket_bind_address=`echo $listen`
socket_listen_owner=`grep "^listen.owner[ ]*=[ ]*" /usr/local/php/etc/php-fpm.conf | awk -F "=" {'print $2'} | sed 's/[ ]*//g'`
socket_listen_group=`grep "^listen.group[ ]*=[ ]*" /usr/local/php/etc/php-fpm.conf | awk -F "=" {'print $2'} | sed 's/[ ]*//g'`
socket_listen_mode=`grep "^listen.group[ ]*=[ ]*" /usr/local/php/etc/php-fpm.conf | grep -Po '[0-9]*'`
else
mode="fpm"
fpm_bind_address=`echo $listen | sed 's/:.*//'`
fpm_port=`echo $listen | sed 's/.*://'`
fi

cat <<EOF
<div class="row">
	<div class="col-md-6">
	<legend>$_LANG_Base_setting</legend>
<label>$_LANG_Mode</label>
  <ul class="nav nav-tabs">
    <li `[ "$mode" = "fpm" ] && echo "class=\"active\""`><a href="#div_fpm" data-toggle="tab" >fpm/fcgi</a></li>
    <li `[ "$mode" = "socket" ] && echo "class=\"active\""`><a href="#div_socket" data-toggle="tab" >socket</a></li>
  </ul>
  <div class="tab-content">
    <div class="tab-pane `[ "$mode" = "fpm" ] && echo "active"`" id="div_fpm">
		<form id="base_setting_fpm">
		<table class="table">
		<tr>
		<td>
		$_LANG_Bind_address
		</td>
		<td>
		<input type="text" class="form-control" name="fpm_bind_address" placeholder="127.0.0.1 or 0.0.0.0" value="`[ -n "$fpm_bind_address" ] && echo "$fpm_bind_address" || echo "127.0.0.1"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Port
		</td>
		<td>
		<input type="text" class="form-control" name="fpm_port" placeholder="9000" value="`[ -n "$fpm_port" ] && echo "$fpm_port" || echo "9000"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Option
		</td>
		<td>
		<input type="hidden" name="action" value="base_setting_fpm">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
		</td>
		</tr>
		</table>
		</form>
    </div>
    <div class="tab-pane `[ "$mode" = "socket" ] && echo "active"`" id="div_socket">
		<form id="base_setting_socket">
		<table class="table">
		<tr>
		<td>
		$_LANG_Bind_address
		</td>
		<td>
		<input type="text" class="form-control" name="socket_bind_address" placeholder="/dev/shm/php5.sock" value="`[ -n "$socket_bind_address" ] && echo "$socket_bind_address" || echo "/dev/shm/php5.sock"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Listen_Owner
		</td>
		<td>
		<input type="text" class="form-control" name="socket_listen_owner" placeholder="www" value="`[ -n "$socket_listen_owner" ] && echo "$socket_listen_owner" || echo "www"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Listen_Group
		</td>
		<td>
		<input type="text" class="form-control" name="socket_listen_group" placeholder="www" value="`[ -n "$socket_listen_group" ] && echo "$socket_listen_group" || echo "www"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Listen_Permission
		</td>
		<td>
		<input type="text" class="form-control" name="socket_listen_mode" placeholder="0660" value="`[ -n "$socket_listen_mode" ] && echo "$socket_listen_mode" || echo "0660"`">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Option
		</td>
		<td>
		<input type="hidden" name="action" value="base_setting_socket">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
		</td>
		</tr>
		</table>
		</form>
    </div>
  </div>
EOF
mysqli_default_socket=`grep -E "^mysqli.default_socket[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`

cat <<EOF
	<label>Mysql socket</label>
	<div class="row">
	<form id="change_mysqli_default_socket">
		<div class="col-md-8">
		<input type="text" class="form-control" name="mysqli_default_socket" placeholder="/dev/shm/mysqld.sock" value="`[ -n "$mysqli_default_socket" ] && echo "$mysqli_default_socket" || echo "/dev/shm/mysqld.sock"`">
		</div>
		<div class="col-md-4">
		<input type="hidden" name="action" value="change_mysqli_default_socket">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
		</div>
	</form>
	</div>

	<label>Time zone</label>
	<div class="row">
	<form id="change_time_zone">
		<div class="col-md-8">
			<select name="zonename" class="form-control">
EOF
tz_now=`grep -E "^date\.timezone[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`
for tz in $(for i in `find /usr/share/zoneinfo/ -type d -maxdepth 1 | grep -v "/$"`; do find ${i} -type f; done | grep -vE "right|Etc|posix" | sed 's#/usr/share/zoneinfo/##g' | sort -n)
do
echo "<option value=\"${tz}\" `echo "$tz_now" | grep -q "${tz}" && echo selected`>${tz}</option>"
done
cat <<EOF

			</select>
		</div>
		<div class="col-md-4">
		<input type="hidden" name="action" value="change_time_zone">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
		</div>
	</form>
	</div>

<legend>$_LANG_Text_of_etc_php_fpm_conf</legend>
<form id="save_php_fpm_conf">
<textarea style="width:100%;height:260px" name="php_fpm_conf_str" class="bg-warning">
EOF
cat /usr/local/php/etc/php-fpm.conf
cat <<EOF
</textarea>
<input type="hidden" name="action" value="save_php_fpm_conf">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>

	</div>
	<div class="col-md-6">
	
EOF
php_fpm_pid=`ps aux |grep -v grep | grep php-fpm | grep "www" | sed -n 1p | awk {'print $2'}`
if
echo $php_fpm_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $php_fpm_pid`
if
ls /etc/rc?.d | grep -q "S.*php-fpm$"
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
	<form id="php_service">
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
		$_LANG_PHP_service
			<select name="php_enable">
			  <option value="1" $on_selected>$_LANG_On</option>
			  <option value="0" $off_selected>$_LANG_Off</option>
			</select>
		</td>
		<td>
			<input type="hidden" name="action" value="php_service">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</td>
		</tr>
		</table>
	</form>
</div>
      </div>
	</div>

	
<legend>$_LANG_Text_of_etc_php_ini</legend>
<form id="save_php_ini">
<textarea style="width:100%;height:260px" name="php_ini_str" class="bg-warning">
EOF
cat /usr/local/php/etc/php.ini
cat <<EOF
</textarea>
<input type="hidden" name="action" value="save_php_ini">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>


	</div>
	
	<legend>php-cli info</legend>
	<iframe src="/index.cgi?app=php&action=php_info" id="phpinfo" frameborder="0" scrolling="yes" width="100%" style="min-height:500px"></iframe>

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
        <h4 class="modal-title">$_PS_Install_php</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_php" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_PHP_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=php&action=pre_install_php';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_php()
{
var url = 'index.cgi?app=php&action=install_php';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_php').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_php()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/php/php_lib.sh

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi