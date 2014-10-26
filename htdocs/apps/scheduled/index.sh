#!/bin/sh

main()
{

cat <<'EOF'
<script>
$(function(){
  $('#crond_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=scheduled&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service-crond');
        setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#scrond_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=scheduled&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service-scrond');
        setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF
crond_pid=`ps aux |grep -v grep | grep -E "busybox[ ]+crond" | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $crond_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $crond_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/scheduled/S300scheduled.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi
cat <<EOF
<div class="row">
	<div class="col-md-6" id="ajax-service-crond">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="crond_service">
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
					$_LANG_Scheduled_service
						<select name="crond_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="crond_service">
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
scrond_pid=`ps aux |grep -vE "grep|busybox" | grep -E "[0-9]:[0-9]{2}.*cron$" | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $scrond_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $scrond_pid`
if
ls /etc/rc?.d | grep -q "cron$"
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi
cat <<EOF
	<div class="col-md-6" id="ajax-service-scrond">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_System_comes_with_scheduled</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="scrond_service">
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
					$_LANG_Scheduled_service
						<select name="scrond_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="scrond_service">
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
EOF

cat <<EOF
<div class="row">
	<div class="col-md-6">
	<legend>当前后台计划任务</legend>
	<pre>`cat /var/spool/cron/crontabs/root`</pre>
	</div>
	<div class="col-md-6">
		<div class="panel panel-warning">
			<div class="panel-heading">
			  <h4 class="panel-title">
				<a data-toggle="collapse" data-parent="#accordion" href="#aria2-setting" class="collapsed">
				  <span class="glyphicon glyphicon-comment"></span>cron最后日志</a>
			  </h4>
			</div>
			<div id="aria2-setting" class="panel-collapse collapse" style="height: 0px;">
			  <div class="panel-body">
				<pre>`tail /var/log/cron`</pre>
			  </div>
			</div>
		</div>
	</div>
</div>
EOF

}
crond_service()
{
if
[ "$FORM_crond_enable" = "1" ]
then
sed -i 's/^enable=.*/enable=1/' $DOCUMENT_ROOT/apps/scheduled/S300scheduled.init
$DOCUMENT_ROOT/apps/scheduled/S300scheduled.init >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_crond_turn_on" \
				detail="_NOTICE_crond_turn_on" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="scheduled" \
				dest_type="app"  >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
sed -i 's/^enable=.*/enable=0/' $DOCUMENT_ROOT/apps/scheduled/S300scheduled.init
$DOCUMENT_ROOT/apps/scheduled/S300scheduled.init >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_crond_turn_off" \
				detail="_NOTICE_crond_turn_off" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="scheduled" \
				dest_type="app"  >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}
scrond_service()
{
if
[ "$FORM_scrond_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add cron && chkconfig cron on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f cron defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f cron defaults >/dev/null 2>&1
service cron start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_scrond_turn_on" \
				detail="_NOTICE_scrond_turn_on" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="scheduled" \
				dest_type="app"  >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add cron && chkconfig cron off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f cron remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f cron remove >/dev/null 2>&1
scrond_pid=`ps aux |grep -vE "grep|busybox" | grep -E "[0-9]:[0-9]{2}.*cron$" | grep "^root" | sed -n 1p | awk {'print $2'}`
kill -9 $scrond_pid >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_scrond_turn_off" \
				detail="_NOTICE_scrond_turn_off" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="scheduled" \
				dest_type="app"  >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi