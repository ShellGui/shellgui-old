#!/bin/sh
main()
{
shellinabox_pid=`ps aux | grep -v grep | grep "shellinaboxd" | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $shellinabox_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $shellinabox_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi
eval `grep -q "^style=" $DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init`
cat <<'EOF'
<script>
$(function(){
  $('#shellinabox_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=shellinabox&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#set_shellinaboxd_style').on('submit', function(e){
    e.preventDefault();
    var data = "app=shellinabox&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF

check_shellinabox_installed || warning

cat <<EOF
<div class="col-md-6">
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="shellinabox_service">
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
					$_LANG_SHELLinabox_service
						<select name="shellinabox_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="shellinabox_service">
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
	<label>Style</label>
		<form id="set_shellinaboxd_style" action="" method="post">
		<div class="form-group">
		<div class="col-sm-8">
		<input type="hidden" name="action" value="set_shellinaboxd_style">
		<select class="form-control input-sm" name="shellinabox_style">
		<option value="white-on-black" $([ -z "$style" ] && echo selected)>white-on-black</option>
		<option value="black-on-white" $([ "$style" = "black-on-white" ] && echo selected)>black-on-white</option>
		</select>
		</div>
		<div class="col-sm-4">
		<button type="submit" class="btn btn-info">$_LANG_Save</button>
		</div>
		</div>
		</form>
	</div>
<div class="col-md-12">
EOF

ps aux | grep -v grep | grep -q "shellinaboxd" && cat <<EOF
	<iframe src="/shellinabox/" id="iframeshellinabox" name="iframepage" frameBorder=0 scrolling=no  style="min-height:500px;min-width:800px"></iframe>
EOF

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
        <h4 class="modal-title">$_PS_Install_SHELLinabox</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_shellinabox" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_SHELLinabox_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=shellinabox&action=pre_install_shellinabox';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_shellinabox()
{
var url = 'index.cgi?app=shellinabox&action=install_shellinabox';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_shellinabox').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_shellinabox()", 5000);

});
</script>
EOF
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf` >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/shellinabox/shellinabox_lib.sh >/dev/null 2>&1
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