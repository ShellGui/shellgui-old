#!/bin/sh

main()
{




aria2_pid=`ps aux | grep -v grep | grep "aria2c" | grep "^root" | sed -n 1p | awk {'print $2'}`
if
echo $aria2_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $aria2_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/aria2/S800aria2c.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi



cat <<'EOF'
<script>
$(function(){
  $('#aria_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=aria2&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout(function(){
	iframepage.window.location.reload();
	},5000)
  });
});
$(function(){
  $('#aria_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=aria2&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
	setTimeout(function(){
	iframepage.window.location.reload();
	},5000)
  });
});
</script>
EOF
check_aria2_installed || warning
cat <<EOF
  <div class="row">
    <div class="col-md-12">
  <div class="controls">
  
  
  
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="aria_service">
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
					$_LANG_Aria2_service
						<select name="aria2_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="aria_service">
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
  
<form id="aria_setting">
<div class="panel panel-primary">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#aria2-setting" class="collapsed">
          <span class="glyphicon glyphicon-comment"></span>$_LANG_Aria2_Setting</a>
      </h4>
    </div>
    <div id="aria2-setting" class="panel-collapse collapse" style="height: 0px;">
      <div class="panel-body">

		<div class="col-md-6">
		<legend>$_LANG_Base_Setting</legend>
		<table class="table">
		<tr>
		<td>
		$_LANG_Dir		</td>
		<td>
		<input name="dir" type="text" value="`echo "$aria2_config_str" | grep "^dir=" | sed 's/.*=//'`" placeholder="/tmp" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_File_allocation		</td>
		<td>
			<select name="file_allocation" class="form-control">
			<option value="none" `[ "$(echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//')" = "none" ] && echo "selected=\"selected\""`>none</option>
			<option value="prealloc" `[ "$(echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//')" = "prealloc" ] && echo "selected=\"selected\""`>prealloc</option>
			<option value="falloc" `[ "$(echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//')" = "falloc" ] && echo "selected=\"selected\""`>falloc</option>
			<option value="trunc" `[ "$(echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//')" = "trunc" ] && echo "selected=\"selected\""`>trunc</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Input_file		</td>
		<td>
		<input name="input_file" type="text" value="`echo "$aria2_config_str" | grep "^input-file=" | sed 's/.*=//'`" placeholder="$DOCUMENT_ROOT/apps/aria2/aria2.session" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Save_session		</td>
		<td>
		<input name="save_session" type="text" value="`echo "$aria2_config_str" | grep "^save-session=" | sed 's/.*=//'`" placeholder="$DOCUMENT_ROOT/apps/aria2/aria2.session" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Save_session_interval		</td>
		<td>
		<input name="save_session_interval" type="text" value="`echo "$aria2_config_str" | grep "^save-session-interval=" | sed 's/.*=//'`" placeholder="60" class="form-control">
		</td>
		</tr>
		</table>
		
		</div>
		<div class="col-md-6">
		<legend>$_LANG_Speed_setting</legend>
		<table class="table">
		<tr>
		<td>
		$_LANG_Max_concurrent_downloads		</td>
		<td>
		<input name="max_concurrent_downloads" type="text" value="`echo "$aria2_config_str" | grep "^max-concurrent-downloads=" | sed 's/.*=//'`" placeholder="3" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Continue		</td>
		<td>
			<select name="continue" class="form-control">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^continue=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^continue=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Max_connection_per_server		</td>
		<td>
		<input name="max_connection_per_server" type="text" value="`echo "$aria2_config_str" | grep "^max-connection-per-server=" | sed 's/.*=//'`" placeholder="5" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Min_split_size		</td>
		<td>
		<input name="min_split_size" type="text" value="`echo "$aria2_config_str" | grep "^min-split-size=" | sed 's/.*=//'`" placeholder="10" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Split		</td>
		<td>
		<input name="split" type="text" value="`echo "$aria2_config_str" | grep "^split=" | sed 's/.*=//'`" placeholder="10" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Max_overall_download_limit		</td>
		<td>
		<input name="max_overall_download_limit" type="text" value="`echo "$aria2_config_str" | grep "^max-overall-download-limit=" | sed 's/.*=//'`" placeholder="0" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Max_download_limit		</td>
		<td>
		<input name="max_download_limit" type="text" value="`echo "$aria2_config_str" | grep "^max-download-limit=" | sed 's/.*=//'`" placeholder="0" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Max_overall_upload_limit		</td>
		<td>
		<input name="max_overall_upload_limit" type="text" value="`echo "$aria2_config_str" | grep "^max-overall-upload-limit=" | sed 's/.*=//'`" placeholder="0" class="form-control" disabled="disabled">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Max_upload_limit		</td>
		<td>
		<input name="max_upload_limit" type="text" value="`echo "$aria2_config_str" | grep "^max-upload-limit=" | sed 's/.*=//'`" placeholder="0" class="form-control" disabled="disabled">
		</td>
		</tr>

		</table>
		</div>
		
		<div class="col-md-6">
		<legend>$_LANG_BT_Setting</legend>
		<table class="table">
		<tr>
		<td>
		$_LANG_BT_enable_lpd		</td>
		<td>
			<select name="bt_enable_lpd" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^bt-enable-lpd=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^bt-enable-lpd=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_BT_max_peers		</td>
		<td>
		<input name="bt_max_peers" type="text" value="`echo "$aria2_config_str" | grep "^bt-max-peers=" | sed 's/.*=//'`" placeholder="55" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_BT_require_crypto		</td>
		<td>
			<select name="bt_require_crypto" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^bt-require-crypto=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^bt-require-crypto=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Listen_port		</td>
		<td>
		<input name="listen_port" type="text" value="`echo "$aria2_config_str" | grep "^listen-port=" | sed 's/.*=//'`" placeholder="0" class="form-control">
		</td>
		</tr>
		</table>
		</div>

		<div class="col-md-6">
		<legend>$_LANG_PT_Setting</legend>
		<table class="table">
				<tr>
		<td>
		$_LANG_Enable_dht		</td>
		<td>
			<select name="enable_dht" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^enable-dht=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^enable-dht=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Enable_Peer_Exchange		</td>
		<td>
			<select name="enable_peer_exchange" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^enable-peer-exchange=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^enable-peer-exchange=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_User_agent		</td>
		<td>
		<input name="user_agent" type="text" value="`echo "$aria2_config_str" | grep "^user-agent=" | sed 's/.*=//'`" placeholder="uTorrent/2210(25130)" class="form-control">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Peer_id_Prefix		</td>
		<td>
		<input name="peer_id_prefix" type="text" value="`echo "$aria2_config_str" | grep "^peer-id-prefix=" | sed 's/.*=//'`" placeholder="-UT2210-" class="form-control" disabled="disabled">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Seed_ratio		</td>
		<td>
		<input name="seed_ratio" type="text" value="`echo "$aria2_config_str" | grep "^seed-ratio=" | sed 's/.*=//'`" placeholder="0" class="form-control" disabled="disabled">
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Force_Save		</td>
		<td>
			<select name="force_save" class="form-control">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^force-save=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^force-save=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_BT_hash_check_Seed		</td>
		<td>
			<select name="bt_hash_check_seed" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^bt-hash-check-seed=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^bt-hash-check-seed=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_BT_Seed_Unverified		</td>
		<td>
			<select name="bt_seed_unverified" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^bt-seed-unverified=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^bt-seed-unverified=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_BT_Save_metadata		</td>
		<td>
			<select name="bt_save_metadata" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^bt-save-metadata=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^bt-save-metadata=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>
		$_LANG_Save_Session_interval		</td>
		<td>
			<select name="follow_torrent" class="form-control" disabled="disabled">
			<option value="true" `[ "$(echo "$aria2_config_str" | grep "^follow-torrent=" | sed 's/.*=//')" = "true" ] && echo "selected=\"selected\""`>$_LANG_True</option>
			<option value="false" `[ "$(echo "$aria2_config_str" | grep "^follow-torrent=" | sed 's/.*=//')" = "false" ] && echo "selected=\"selected\""`>$_LANG_False</option>
			</select>
		</td>
		</tr>
		</table>
		
	<input type="hidden" name="action" value="aria_setting">
	<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</div>
</form>

	  </div>
    </div>
  </div>


<iframe src="/apps/aria2/yaaw.cgi" id="iframeyaaw" name="iframepage" frameBorder=0 scrolling=yes width="100%" style="min-height:500px"></iframe>
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
        <h4 class="modal-title">$_PS_Install_Aria2</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_aria2" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Aira2_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=aria2&action=pre_install_aria2';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_aria2()
{
var url = 'index.cgi?app=aria2&action=install_aria2';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_aria2').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_aria2()", 5000);

});
</script>
EOF
}

aria_setting()
{
old_dir=`echo "$aria2_config_str" | grep "^dir=" | sed 's/.*=//'`
old_file_allocation=`echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//'`
old_file_allocation=`echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//'`
old_file_allocation=`echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//'`
old_file_allocation=`echo "$aria2_config_str" | grep "^file-allocation=" | sed 's/.*=//'`
old_input_file=`echo "$aria2_config_str" | grep "^input-file=" | sed 's/.*=//'`
old_save_session=`echo "$aria2_config_str" | grep "^save-session=" | sed 's/.*=//'`
old_save_session_interval=`echo "$aria2_config_str" | grep "^save-session-interval=" | sed 's/.*=//'`
old_max_concurrent_downloads=`echo "$aria2_config_str" | grep "^max-concurrent-downloads=" | sed 's/.*=//'`
old_continue=`echo "$aria2_config_str" | grep "^continue=" | sed 's/.*=//'`
old_max_connection_per_server=`echo "$aria2_config_str" | grep "^max-connection-per-server=" | sed 's/.*=//'`
old_min_split_size=`echo "$aria2_config_str" | grep "^min-split-size=" | sed 's/.*=//'`
old_split=`echo "$aria2_config_str" | grep "^split=" | sed 's/.*=//'`
old_max_overall_download_limit=`echo "$aria2_config_str" | grep "^max-overall-download-limit=" | sed 's/.*=//'`
old_max_download_limit=`echo "$aria2_config_str" | grep "^max-download-limit=" | sed 's/.*=//'`
old_max_overall_upload_limit=`echo "$aria2_config_str" | grep "^max-overall-upload-limit=" | sed 's/.*=//'`
old_max_upload_limit=`echo "$aria2_config_str" | grep "^max-upload-limit=" | sed 's/.*=//'`
old_bt_enable_lpd=`echo "$aria2_config_str" | grep "^bt-enable-lpd=" | sed 's/.*=//'`
old_bt_max_peers=`echo "$aria2_config_str" | grep "^bt-max-peers=" | sed 's/.*=//'`
old_bt_require_crypto=`echo "$aria2_config_str" | grep "^bt-require-crypto=" | sed 's/.*=//'`
old_bt_require_crypto=`echo "$aria2_config_str" | grep "^bt-require-crypto=" | sed 's/.*=//'`
old_listen_port=`echo "$aria2_config_str" | grep "^listen-port=" | sed 's/.*=//'`
old_enable_dht=`echo "$aria2_config_str" | grep "^enable-dht=" | sed 's/.*=//'`
old_enable_dht=`echo "$aria2_config_str" | grep "^enable-dht=" | sed 's/.*=//'`
old_enable_peer_exchange=`echo "$aria2_config_str" | grep "^enable-peer-exchange=" | sed 's/.*=//'`
old_user_agent=`echo "$aria2_config_str" | grep "^user-agent=" | sed 's/.*=//'`
old_peer_id_prefix=`echo "$aria2_config_str" | grep "^peer-id-prefix=" | sed 's/.*=//'`
old_seed_ratio=`echo "$aria2_config_str" | grep "^seed-ratio=" | sed 's/.*=//'`
old_force_save=`echo "$aria2_config_str" | grep "^force-save=" | sed 's/.*=//' | sed -n 1p`
old_bt_hash_check_seed=`echo "$aria2_config_str" | grep "^bt-hash-check-seed=" | sed 's/.*=//'`
old_bt_seed_unverified=`echo "$aria2_config_str" | grep "^bt-seed-unverified=" | sed 's/.*=//'`
old_bt_save_metadata=`echo "$aria2_config_str" | grep "^bt-save-metadata=" | sed 's/.*=//'`
old_follow_torrent=`echo "$aria2_config_str" | grep "^follow-torrent=" | sed 's/.*=//'`
[ -z "$FORM_enable_rpc" ] || sed -i "s/^enable-rpc=.*/enable-rpc=$FORM_enable_rpc/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_rpc_allow_origin_all" ] || sed -i "s/^rpc-allow_origin-all=.*/rpc-allow_origin-all=$FORM_rpc_allow_origin_all/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_rpc_listen_all" ] || sed -i "s/^rpc-listen-all=.*/rpc-listen-all=$FORM_rpc_listen_all/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_concurrent_downloads" ] || sed -i "s/^max-concurrent-downloads=.*/max-concurrent-downloads=$FORM_max_concurrent_downloads/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_continue" ] || sed -i "s/^continue=.*/continue=$FORM_continue/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_connection_per_server" ] || sed -i "s/^max-connection-per-server=.*/max-connection-per-server=$FORM_max_connection_per_server/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_min_split_size" ] || sed -i "s/^min-split-size=.*/min-split-size=$FORM_min_split_size/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_split" ] || sed -i "s/^split=.*/split=$FORM_split/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_overall_download_limit" ] || sed -i "s/^max-overall-download-limit=.*/max-overall-download-limit=$FORM_max_overall_download_limit/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_download_limit" ] || sed -i "s/^max-download-limit=.*/max-download-limit=$FORM_max_download_limit/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_overall_upload_limit" ] || sed -i "s/^max-overall-upload-limit=.*/max-overall-upload-limit=$FORM_max_overall_upload_limit/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_max_upload_limit" ] || sed -i "s/^max-upload-limit=.*/max-upload-limit=$FORM_max_upload_limit/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_input_file" ] || sed -i "s#^input-file=.*#input-file=$FORM_input_file#g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_save_session" ] || sed -i "s#^save-session=.*#save-session=$FORM_save_session#g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_save_session_interval" ] || sed -i "s/^save-session-interval=.*/save-session-interval=$FORM_save_session_interval/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_dir" ] || sed -i "s#^dir=.*#dir=$FORM_dir#g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_file_allocation" ] || sed -i "s/^file-allocation=.*/file-allocation=$FORM_file_allocation/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_bt_enable_lpd" ] || sed -i "s/^bt-enable-lpd=.*/bt-enable-lpd=$FORM_bt_enable_lpd/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_follow_torrent" ] || sed -i "s/^follow-torrent=.*/follow-torrent=$FORM_follow_torrent/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_enable_dht" ] || sed -i "s/^enable-dht=.*/enable-dht=$FORM_enable_dht/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_enable_peer_exchange" ] || sed -i "s/^enable-peer-exchange=.*/enable-peer-exchange=$FORM_enable_peer_exchange/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_user_agent" ] || sed -i "s#^user-agent=.*#user-agent=$FORM_user_agent#g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_peer_id_prefix" ] || sed -i "s/^peer-id-prefix=.*/peer-id-prefix=$FORM_peer_id_prefix/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_seed_ratio" ] || sed -i "s/^seed-ratio=.*/seed-ratio=$FORM_seed_ratio/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_force_save" ] || sed -i "s/^force-save=.*/force-save=$FORM_force_save/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_bt_hash_check_seed" ] || sed -i "s/^bt-hash-check-seed=.*/bt-hash-check-seed=$FORM_bt_hash_check_seed/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_bt_seed_unverified" ] || sed -i "s/^bt-seed-unverified=.*/bt-seed-unverified=$FORM_bt_seed_unverified/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
[ -z "$FORM_bt_save_metadata" ] || sed -i "s/^bt-save-metadata=.*/bt-save-metadata=$FORM_bt_save_metadata/g" $DOCUMENT_ROOT/apps/aria2/aria2.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_aria2_modified" \
				detail="_NOTICE_aria2_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="aria2" \
				dest_type="app" \
					variable="{\
						\"enable_rpc\":\"$FORM_enable_rpc\", \
						\"rpc_allow_origin_all\":\"$FORM_rpc_allow_origin_all\", \
						\"rpc_listen_all\":\"$FORM_rpc_listen_all\", \
						\"max_concurrent_downloads\":\"$FORM_max_concurrent_downloads\", \
						\"continue\":\"$FORM_continue\", \
						\"max_connection_per_server\":\"$FORM_max_connection_per_server\", \
						\"min_split_size\":\"$FORM_min_split_size\", \
						\"split\":\"$FORM_split\", \
						\"max_overall_download_limit\":\"$FORM_max_overall_download_limit\", \
						\"max_download_limit\":\"$FORM_max_download_limit\", \
						\"max_overall_upload_limit\":\"$FORM_max_overall_upload_limit\", \
						\"max_upload_limit\":\"$FORM_max_upload_limit\", \
						\"input_file\":\"$FORM_input_file\", \
						\"save_session\":\"$FORM_save_session\", \
						\"save_session_interval\":\"$FORM_save_session_interval\", \
						\"dir\":\"$FORM_dir\", \
						\"file_allocation\":\"$FORM_file_allocation\", \
						\"bt_enable_lpd\":\"$FORM_bt_enable_lpd\", \
						\"follow_torrent\":\"$FORM_follow_torrent\", \
						\"enable_dht\":\"$FORM_enable_dht\", \
						\"enable_peer_exchange\":\"$FORM_enable_peer_exchange\", \
						\"user_agent\":\"$FORM_user_agent\", \
						\"peer_id_prefix\":\"$FORM_peer_id_prefix\", \
						\"seed_ratio\":\"$FORM_seed_ratio\", \
						\"force_save\":\"$FORM_force_save\", \
						\"bt_hash_check_seed\":\"$FORM_bt_hash_check_seed\", \
						\"bt_seed_unverified\":\"$FORM_bt_seed_unverified\", \
						\"bt_save_metadata\":\"$FORM_bt_save_metadata\", \
						\"old_enable_rpc\":\"$old_enable_rpc\", \
						\"old_rpc_allow_origin_all\":\"$old_rpc_allow_origin_all\", \
						\"old_rpc_listen_all\":\"$old_rpc_listen_all\", \
						\"old_max_concurrent_downloads\":\"$old_max_concurrent_downloads\", \
						\"old_continue\":\"$old_continue\", \
						\"old_max_connection_per_server\":\"$old_max_connection_per_server\", \
						\"old_min_split_size\":\"$old_min_split_size\", \
						\"old_split\":\"$old_split\", \
						\"old_max_overall_download_limit\":\"$old_max_overall_download_limit\", \
						\"old_max_download_limit\":\"$old_max_download_limit\", \
						\"old_max_overall_upload_limit\":\"$old_max_overall_upload_limit\", \
						\"old_max_upload_limit\":\"$old_max_upload_limit\", \
						\"old_input_file\":\"$old_input_file\", \
						\"old_save_session\":\"$old_save_session\", \
						\"old_save_session_interval\":\"$old_save_session_interval\", \
						\"old_dir\":\"$old_dir\", \
						\"old_file_allocation\":\"$old_file_allocation\", \
						\"old_bt_enable_lpd\":\"$old_bt_enable_lpd\", \
						\"old_follow_torrent\":\"$old_follow_torrent\", \
						\"old_enable_dht\":\"$old_enable_dht\", \
						\"old_enable_peer_exchange\":\"$old_enable_peer_exchange\", \
						\"old_user_agent\":\"$old_user_agent\", \
						\"old_peer_id_prefix\":\"$old_peer_id_prefix\", \
						\"old_seed_ratio\":\"$old_seed_ratio\", \
						\"old_force_save\":\"$old_force_save\", \
						\"old_bt_hash_check_seed\":\"$old_bt_hash_check_seed\", \
						\"old_bt_seed_unverified\":\"$old_bt_seed_unverified\", \
						\"old_bt_save_metadata\":\"$old_bt_save_metadata\" \
					}" >/dev/null 2>&1
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
}

aria_service()
{
sed -i "s/^enable=.*/enable=$FORM_aria2_enable/g" $DOCUMENT_ROOT/apps/aria2/S800aria2c.init
result=`$DOCUMENT_ROOT/apps/aria2/S800aria2c.init >/dev/null 2>&1`
if
[ $FORM_aria2_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_aria2_service_enable" \
				detail="_NOTICE_aria2_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="aria2" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_aria2_service_disable" \
				detail="_NOTICE_aria2_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="aria2" \
				dest_type="app" >/dev/null 2>&1
fi
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/$FORM_app/aria2_lib.sh
aria2_config_str=`cat $DOCUMENT_ROOT/apps/aria2/aria2.conf`
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi