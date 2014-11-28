#!/bin/sh

main()
{
check_shadowsocks_libev_installed || warning
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
shadowsocks_libev_str=`cat $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev.json`
shadowsocks_libev_server_pid=`ps aux | grep "ss-server" | grep -v grep | grep "\-a shadowsocks" | awk {'print $2'}`
if
echo $shadowsocks_libev_server_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $shadowsocks_libev_server_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/shadowsocks-libev/S700shadowsocks_server.init
then
server_on_selected="selected=\"selected\""
else
server_off_selected="selected=\"selected\""
fi
server_config_str=`cat /usr/local/shadowsocks-libev/etc/server.json`
cat <<EOF
<script>
\$(function(){
  \$('#shadowsocks_libev_server_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
\$(function(){
  \$('#shadowsocks_libev_local_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});
\$(function(){
  \$('#shadowsocks_libev_redir_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
		setTimeout("window.location.reload();", 3000);
  });
});

\$(function(){
  \$('#shadowsocks_libev_server_basesetting').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
\$(function(){
  \$('#shadowsocks_libev_local_basesetting').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
\$(function(){
  \$('#shadowsocks_libev_redir_basesetting').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
\$(function(){
  \$('#shadowsocks_libev_redir_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
\$(function(){
  \$('#shadowsocks_libev_local_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
\$(function(){
  \$('#shadowsocks_libev_server_dest').on('submit', function(e){
    e.preventDefault();
    var data = "app=shadowsocks-libev&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
<div class="col-md-6">
<legend>Shadowsocks Server</legend>
<p>
<form class="form-inline" role="form" id="shadowsocks_libev_server_dest">
<label>Wan in use</label>
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$shadowsocks_libev_str" | jq '.["shadowsocks_server"]["wan_zone"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="shadowsocks_libev_server_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
<p>
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="shadowsocks_libev_server_service">
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
					$_LANG_Shadowsocks_libev_server_service
						<select name="shadowsocks_libev_server_enable">
						  <option value="1" $server_on_selected>$_LANG_On</option>
						  <option value="0" $server_off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="shadowsocks_libev_server_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<legend>Shadowsocks Server Setting</legend>
<form id="shadowsocks_libev_server_basesetting">
<table class="table">
	<tr>
		<td>
		server
		</td>
		<td>
		<input type="text" class="form-control" name="server" placeholder="Enter Server IP" value="`echo "$server_config_str" | jq -r '.["server"]'`">
		</td>
	</tr>
	<tr>
		<td>
		server_port
		</td>
		<td>
		<input type="text" class="form-control" name="server_port" placeholder="Enter Server Port" value="`echo "$server_config_str" | jq -r '.["server_port"]'`">
		</td>
	</tr>
	<tr>
		<td>
		password
		</td>
		<td>
		<input type="text" class="form-control" name="password" placeholder="Enter Password" value="`echo "$server_config_str" | jq -r '.["password"]'`">
		</td>
	</tr>
	<tr>
		<td>
		timeout
		</td>
		<td>
		<input type="text" class="form-control" name="timeout" placeholder="Enter Time Secends" value="`echo "$server_config_str" | jq -r '.["timeout"]'`">
		</td>
	</tr>
	<tr>
		<td>
		method
		</td>
		<td>
			<select class="form-control" name="method">
				<option value="table" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "table" ] && echo selected=\"selected\"`>TABLE</option>
				<option value="rc4" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "rc4" ] && echo selected=\"selected\"`>RC4</option>
				<option value="rc4-md5" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "rc4-md5" ] && echo selected=\"selected\"`>RC4-MD5</option>
				<option value="aes-128-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "aes-128-cfb" ] && echo selected=\"selected\"`>AES-128-CFB</option>
				<option value="aes-192-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "aes-192-cfb" ] && echo selected=\"selected\"`>AES-192-CFB</option>
				<option value="aes-256-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "aes-256-cfb" ] && echo selected=\"selected\"`>AES-256-CFB</option>
				<option value="bf-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "bf-cfb" ] && echo selected=\"selected\"`>BF-CFB</option>
				<option value="camellia-128-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "camellia-128-cfb" ] && echo selected=\"selected\"`>CAMELLIA-128-CFB</option>
				<option value="camellia-192-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "camellia-192-cfb" ] && echo selected=\"selected\"`>CAMELLIA-192-CFB</option>
				<option value="camellia-256-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "camellia-256-cfb" ] && echo selected=\"selected\"`>CAMELLIA-256-CFB</option>
				<option value="cast5-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "cast5-cfb" ] && echo selected=\"selected\"`>CAST5-CFB</option>
				<option value="des-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "des-cfb" ] && echo selected=\"selected\"`>DES-CFB</option>
				<option value="idea-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "idea-cfb" ] && echo selected=\"selected\"`>IDEA-CFB</option>
				<option value="rc2-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "rc2-cfb" ] && echo selected=\"selected\"`>RC2-CFB</option>
				<option value="seed-cfb" `[ "$(echo "$server_config_str" | jq -r '.["method"]')" = "seed-cfb" ] && echo selected=\"selected\"`>SEED-CFB</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
		Option
		</td>
		<td>
			<input type="hidden" name="action" value="shadowsocks_libev_server_basesetting">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</td>
	</tr>
</table>
</form>

</div>
EOF
shadowsocks_libev_local_pid=`ps aux | grep "ss-local" | grep -v grep | grep "\-a shadowsocks" | awk {'print $2'}`
if
echo $shadowsocks_libev_local_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $shadowsocks_libev_local_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/shadowsocks-libev/S701shadowsocks_local.init
then
local_on_selected="selected=\"selected\""
else
local_off_selected="selected=\"selected\""
fi
local_config_str=`cat /usr/local/shadowsocks-libev/etc/local.json`
cat <<EOF
<div class="col-md-6">
<legend>Shadowsocks Local</legend>
<p>
<form class="form-inline" role="form" id="shadowsocks_libev_local_dest">
<label>Wan in use</label>
EOF
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$shadowsocks_libev_str" | jq '.["shadowsocks_local"]["wan_zone"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="shadowsocks_libev_local_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
<p>
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="shadowsocks_libev_local_service">
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
					$_LANG_Shadowsocks_libev_local_service
						<select name="shadowsocks_libev_local_enable">
						  <option value="1" $local_on_selected>$_LANG_On</option>
						  <option value="0" $local_off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="shadowsocks_libev_local_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<legend>Shadowsocks Local Setting</legend>
<form id="shadowsocks_libev_local_basesetting">
<table class="table">
	<tr>
		<td>
		server
		</td>
		<td>
		<input type="text" class="form-control" name="server" placeholder="Enter Server IP" value="`echo "$local_config_str" | jq -r '.["server"]'`">
		</td>
	</tr>
	<tr>
		<td>
		server_port
		</td>
		<td>
		<input type="text" class="form-control" name="server_port" placeholder="Enter Server Port" value="`echo "$local_config_str" | jq -r '.["server_port"]'`">
		</td>
	</tr>
	<tr>
		<td>
		local_port
		</td>
		<td>
		<input type="text" class="form-control" name="local_port" placeholder="Enter Local Port" value="`echo "$local_config_str" | jq -r '.["local_port"]'`">
		</td>
	</tr>
	<tr>
		<td>
		password
		</td>
		<td>
		<input type="text" class="form-control" name="password" placeholder="Enter Password" value="`echo "$local_config_str" | jq -r '.["password"]'`">
		</td>
	</tr>
	<tr>
		<td>
		timeout
		</td>
		<td>
		<input type="text" class="form-control" name="timeout" placeholder="Enter Time Secends" value="`echo "$local_config_str" | jq -r '.["timeout"]'`">
		</td>
	</tr>
	<tr>
		<td>
		method
		</td>
		<td>
			<select class="form-control" name="method">
				<option value="table" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "table" ] && echo selected=\"selected\"`>TABLE</option>
				<option value="rc4" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "rc4" ] && echo selected=\"selected\"`>RC4</option>
				<option value="rc4-md5" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "rc4-md5" ] && echo selected=\"selected\"`>RC4-MD5</option>
				<option value="aes-128-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "aes-128-cfb" ] && echo selected=\"selected\"`>AES-128-CFB</option>
				<option value="aes-192-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "aes-192-cfb" ] && echo selected=\"selected\"`>AES-192-CFB</option>
				<option value="aes-256-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "aes-256-cfb" ] && echo selected=\"selected\"`>AES-256-CFB</option>
				<option value="bf-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "bf-cfb" ] && echo selected=\"selected\"`>BF-CFB</option>
				<option value="camellia-128-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "camellia-128-cfb" ] && echo selected=\"selected\"`>CAMELLIA-128-CFB</option>
				<option value="camellia-192-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "camellia-192-cfb" ] && echo selected=\"selected\"`>CAMELLIA-192-CFB</option>
				<option value="camellia-256-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "camellia-256-cfb" ] && echo selected=\"selected\"`>CAMELLIA-256-CFB</option>
				<option value="cast5-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "cast5-cfb" ] && echo selected=\"selected\"`>CAST5-CFB</option>
				<option value="des-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "des-cfb" ] && echo selected=\"selected\"`>DES-CFB</option>
				<option value="idea-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "idea-cfb" ] && echo selected=\"selected\"`>IDEA-CFB</option>
				<option value="rc2-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "rc2-cfb" ] && echo selected=\"selected\"`>RC2-CFB</option>
				<option value="seed-cfb" `[ "$(echo "$local_config_str" | jq -r '.["method"]')" = "seed-cfb" ] && echo selected=\"selected\"`>SEED-CFB</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
		Option
		</td>
		<td>
			<input type="hidden" name="action" value="shadowsocks_libev_local_basesetting">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</td>
	</tr>
</table>
</form>

</div>
EOF
shadowsocks_libev_redir_pid=`ps aux | grep "ss-redir" | grep -v grep | grep "\-a shadowsocks" | awk {'print $2'}`
if
echo $shadowsocks_libev_redir_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $shadowsocks_libev_redir_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/shadowsocks-libev/S702shadowsocks_redir.init
then
redir_on_selected="selected=\"selected\""
else
redir_off_selected="selected=\"selected\""
fi
redir_config_str=`cat /usr/local/shadowsocks-libev/etc/redir.json`
cat <<EOF
<div class="col-md-6">
<legend>Shadowsocks Redir</legend>
<p>
<form class="form-inline" role="form" id="shadowsocks_libev_redir_dest">
<label>Lan in use</label>
EOF
for dest in `echo "$netzone_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
lan_used=`echo "$shadowsocks_libev_str" | jq -r '.["shadowsocks_redir"]["lan_zone"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
<label class="checkbox-inline">
<input type="checkbox" name="lan_zone_${dest}" value="${dest}" `echo "$lan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF
<input type="hidden" name="action" value="shadowsocks_libev_redir_dest">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
<p>
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="shadowsocks_libev_redir_service">
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
					$_LANG_Shadowsocks_libev_redir_service
						<select name="shadowsocks_libev_redir_enable">
						  <option value="1" $redir_on_selected>$_LANG_On</option>
						  <option value="0" $redir_off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="shadowsocks_libev_redir_service">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
					</td>
					</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
	</div>

<legend>Shadowsocks Redir Setting</legend>
<form id="shadowsocks_libev_redir_basesetting">
<table class="table">
	<tr>
		<td>
		server
		</td>
		<td>
		<input type="text" class="form-control" name="server" placeholder="Enter Server IP" value="`echo "$redir_config_str" | jq -r '.["server"]'`">
		</td>
	</tr>
	<tr>
		<td>
		server_port
		</td>
		<td>
		<input type="text" class="form-control" name="server_port" placeholder="Enter Server Port" value="`echo "$redir_config_str" | jq -r '.["server_port"]'`">
		</td>
	</tr>
	<tr>
		<td>
		local_port
		</td>
		<td>
		<input type="text" class="form-control" name="local_port" placeholder="Enter Local Port" value="`echo "$redir_config_str" | jq -r '.["local_port"]'`">
		</td>
	</tr>
	<tr>
		<td>
		password
		</td>
		<td>
		<input type="text" class="form-control" name="password" placeholder="Enter Password" value="`echo "$redir_config_str" | jq -r '.["password"]'`">
		</td>
	</tr>
	<tr>
		<td>
		timeout
		</td>
		<td>
		<input type="text" class="form-control" name="timeout" placeholder="Enter Time Secends" value="`echo "$redir_config_str" | jq -r '.["timeout"]'`">
		</td>
	</tr>
	<tr>
		<td>
		method
		</td>
		<td>
			<select class="form-control" name="method">
				<option value="table" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "table" ] && echo selected=\"selected\"`>TABLE</option>
				<option value="rc4" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "rc4" ] && echo selected=\"selected\"`>RC4</option>
				<option value="rc4-md5" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "rc4-md5" ] && echo selected=\"selected\"`>RC4-MD5</option>
				<option value="aes-128-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "aes-128-cfb" ] && echo selected=\"selected\"`>AES-128-CFB</option>
				<option value="aes-192-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "aes-192-cfb" ] && echo selected=\"selected\"`>AES-192-CFB</option>
				<option value="aes-256-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "aes-256-cfb" ] && echo selected=\"selected\"`>AES-256-CFB</option>
				<option value="bf-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "bf-cfb" ] && echo selected=\"selected\"`>BF-CFB</option>
				<option value="camellia-128-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "camellia-128-cfb" ] && echo selected=\"selected\"`>CAMELLIA-128-CFB</option>
				<option value="camellia-192-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "camellia-192-cfb" ] && echo selected=\"selected\"`>CAMELLIA-192-CFB</option>
				<option value="camellia-256-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "camellia-256-cfb" ] && echo selected=\"selected\"`>CAMELLIA-256-CFB</option>
				<option value="cast5-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "cast5-cfb" ] && echo selected=\"selected\"`>CAST5-CFB</option>
				<option value="des-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "des-cfb" ] && echo selected=\"selected\"`>DES-CFB</option>
				<option value="idea-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "idea-cfb" ] && echo selected=\"selected\"`>IDEA-CFB</option>
				<option value="rc2-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "rc2-cfb" ] && echo selected=\"selected\"`>RC2-CFB</option>
				<option value="seed-cfb" `[ "$(echo "$redir_config_str" | jq -r '.["method"]')" = "seed-cfb" ] && echo selected=\"selected\"`>SEED-CFB</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
		Transparent Proxy Dest
		</td>
		<td>
		<textarea style="width:100%;height:140px" name="transparent_proxy_dest" placeholder="10.0.0.0/8" class="bg-warning">`cat $DOCUMENT_ROOT/apps/shadowsocks-libev/transparent_proxy_dest.conf`</textarea>
		</td>
	</tr>
	<tr>
		<td>
		Option
		</td>
		<td>
			<input type="hidden" name="action" value="shadowsocks_libev_redir_basesetting">
			<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</td>
	</tr>
</table>
</form>

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
        <h4 class="modal-title">$_PS_Install_Shadowsocks_libev</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_shadowsocks_libev" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Shadowsocks_libev_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=shadowsocks-libev&action=pre_install_shadowsocks_libev';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_shadowsocks_libev()
{
var url = 'index.cgi?app=shadowsocks-libev&action=install_shadowsocks_libev';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_shadowsocks_libev').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_shadowsocks_libev()", 5000);

});
</script>
EOF
}



lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/shadowsocks-libev/shadowsocks_libev_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi