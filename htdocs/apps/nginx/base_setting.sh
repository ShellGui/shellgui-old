base_setting()
{

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`

username=`echo "$config_str" | jq -r '.["system"]["user"]["username"]'`
groupname=`echo "$config_str" | jq -r '.["system"]["user"]["groupname"]'`
worker_processes=`echo "$config_str" | jq -r '.["system"]["worker_processes"]'`
error_log=`echo "$config_str" | jq -r '.["system"]["error_log"]'`
error_log_level=`echo "$config_str" | jq -r '.["system"]["error_log_level"]'`
worker_rlimit_nofile=`echo "$config_str" | jq -r '.["system"]["worker_rlimit_nofile"]'`

use=`echo "$config_str" | jq -r '.["events"]["use"]'`
worker_connections=`echo "$config_str" | jq -r '.["events"]["worker_connections"]'`

include=`echo "$config_str" | jq -r '.["http"]["include"]'`
default_type=`echo "$config_str" | jq -r '.["http"]["default_type"]'`
charset=`echo "$config_str" | jq -r '.["http"]["charset"]'`
autoindex=`echo "$config_str" | jq -r '.["http"]["autoindex"]'`
server_names_hash_bucket_size=`echo "$config_str" | jq -r '.["http"]["server_names_hash_bucket_size"]'`
client_header_buffer_size=`echo "$config_str" | jq -r '.["http"]["client_header_buffer_size"]'`
large_client_header_buffers=`echo "$config_str" | jq -r '.["http"]["large_client_header_buffers"]'`
client_max_body_size=`echo "$config_str" | jq -r '.["http"]["client_max_body_size"]'`
sendfile=`echo "$config_str" | jq -r '.["http"]["sendfile"]'`

tcp_nopush=`echo "$config_str" | jq -r '.["http"]["tcp_nopush"]'`
tcp_nodelay=`echo "$config_str" | jq -r '.["http"]["tcp_nodelay"]'`
keepalive_timeout=`echo "$config_str" | jq -r '.["http"]["keepalive_timeout"]'`
# limit_zone=`echo "$config_str" | jq -r '.["http"]["limit_zone"]'`
# limit_req_zone=`echo "$config_str" | jq -r '.["http"]["limit_req_zone"]'`
fastcgi_connect_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_connect_timeout"]'`
fastcgi_send_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_send_timeout"]'`
fastcgi_read_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_read_timeout"]'`
fastcgi_buffer_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_buffer_size"]'`
fastcgi_buffers=`echo "$config_str" | jq -r '.["http"]["fastcgi_buffers"]'`
fastcgi_busy_buffers_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_busy_buffers_size"]'`
fastcgi_temp_file_write_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_temp_file_write_size"]'`

gzip=`echo "$config_str" | jq -r '.["http"]["gzip"]'`
gzip_min_length=`echo "$config_str" | jq -r '.["http"]["gzip_min_length"]'`
gzip_buffers=`echo "$config_str" | jq -r '.["http"]["gzip_buffers"]'`
gzip_http_version=`echo "$config_str" | jq -r '.["http"]["gzip_http_version"]'`
gzip_comp_level=`echo "$config_str" | jq -r '.["http"]["gzip_comp_level"]'`
gzip_types=`echo "$config_str" | jq -r '.["http"]["gzip_types"]'`
gzip_vary=`echo "$config_str" | jq -r '.["http"]["gzip_vary"]'`



_LANG_App_name="$_LANG_App_name -> $_LANG_Base_setting"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<'EOF'
<script>
$(function(){
  $('#do_base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

cat <<EOF
<div class="container">

<legend>$_LANG_System_Setting</legend>
<form id="do_base_setting">
<div class="row alert alert-warning">

<div class="row">
 <div class="col-md-4">
 user
 </div>
 <div class="col-md-4">
	<div class="row">
		<div class="col-xs-6">
			<input type="text" class="form-control" name="username" placeholder="nobody" value="`[ "$username" != "null" ] && echo "$username" || echo "nobody"`">
		</div>
		<div class="col-xs-6">
			<input type="text" class="form-control" name="groupname" placeholder="nobody" value="`[ "$groupname" != "null" ] && echo "$groupname" || echo "nobody"`">
		</div>
	</div>
  </div>
  <div class="col-md-4">
  $_LANG_Set_user
  </div>
</div>

<div class="row">
  <div class="col-md-4">
  worker_processes
  </div>
  <div class="col-md-4">
  <input type="text" class="form-control" name="worker_processes" placeholder="8" value="`[ "$worker_processes" != "null" ] && echo "$worker_processes" || echo "8"`">
  </div>
  <div class="col-md-4">
  $_LANG_Set_worker_processes
  </div>
</div>

<div class="row">
  <div class="col-md-4">
  error_log
  </div>
  <div class="col-md-4">
	<div class="row">
		<div class="col-xs-6">
			<input class="form-control" list="errorlogfile" name="error_log" placeholder="/var/log/nginx/error.log & /dev/null" value="`[ "$error_log" != "null" ] && echo "$error_log" || echo "/var/log/nginx/error.log"`">
			<datalist id="errorlogfile">
			<option value="/dev/null">/dev/null</option>
			</datalist>
		</div>
		<div class="col-xs-6">
		  <select multiple class="form-control" name="error_log_level">
			<option `[ "$error_log_level" = "crit" ] && echo "selected"`>crit</option>
			<option `[ "$error_log_level" = "notice" ] && echo "selected"`>notice</option>
			<option `[ "$error_log_level" = "info" ] && echo "selected"`>info</option>
			<option `[ "$error_log_level" = "warn" ] && echo "selected"`>warn</option>
			<option `[ "$error_log_level" = "error" ] && echo "selected"`>error</option>
			<option `[ "$error_log_level" = "debug" ] && echo "selected"`>debug</option>
		  </select>
		</div>
	</div>
  </div>
  <div class="col-md-4">
  $_LANG_Set_error_log
  </div>
</div>

<div class="row">
  <div class="col-md-4">
  worker_rlimit_nofile
  </div>
  <div class="col-md-4">
  <input type="text" class="form-control" name="worker_rlimit_nofile" placeholder="65535" value="`[ "$worker_rlimit_nofile" != "null" ] && echo "$worker_rlimit_nofile" || echo "65535"`">
  </div>
  <div class="col-md-4">
  $_LANG_Set_worker_rlimit_nofile
  </div>
</div>

<div class="row">
  <div class="col-md-4">
	$_LANG_extra_config
  </div>
  <div class="col-md-4">
<textarea style="width:100%;height:160px" name="sys_extra" placeholder="#$_LANG_extra_config" class="bg-warning">`cat $DOCUMENT_ROOT/apps/nginx/extra_config/sys_extra.config`</textarea>
  </div>
  <div class="col-md-4">
	$_LANG_extra_config
  </div>
</div>


</div>



<legend>events</legend>
<div class="row alert alert-warning">
	<div class="row">
	  <div class="col-md-4">
	  use
	  </div>
	  <div class="col-md-4">
		  <select multiple class="form-control" name="use">
			<option `[ "$use" = "epoll" ] && echo "selected"`>epoll</option>
			<option `[ "$use" = "kqueue" ] && echo "selected"`>kqueue</option>
			<option `[ "$use" = "rtsig" ] && echo "selected"`>rtsig</option>
			<option `[ "$use" = "/dev/poll" ] && echo "selected"`>/dev/poll</option>
			<option `[ "$use" = "select" ] && echo "selected"`>select</option>
			<option `[ "$use" = "poll" ] && echo "selected"`>poll</option>
		  </select>
	  </div>
	  <div class="col-md-4">
	  $_LANG_Set_use
	  </div>
	</div>

	<div class="row">
	  <div class="col-md-4">
	  worker_connections
	  </div>
	  <div class="col-md-4">
	  <input type="text" class="form-control" name="worker_connections" placeholder="65535" value="`[ "$worker_connections" != "null" ] && echo "$worker_connections" || echo "65535"`">
	  </div>
	  <div class="col-md-4">
	  $_LANG_Set_worker_connections
	  </div>
	</div>

	<div class="row">
	  <div class="col-md-4">
		$_LANG_extra_config
	  </div>
	  <div class="col-md-4">
	<textarea style="width:100%;height:160px" name="events_extra" placeholder="#$_LANG_extra_config"  class="bg-warning">`cat $DOCUMENT_ROOT/apps/nginx/extra_config/events_extra.config`</textarea>
	  </div>
	  <div class="col-md-4">
		$_LANG_extra_config
	  </div>
	</div>

</div>

<legend>http</legend>
<div class="row alert alert-warning">
	<h4 class="bg-danger">$_LANG_Base_setting</h4>
	<div class="row alert alert-info">
		<div class="row">
		  <div class="col-md-4">
		  include
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="include" placeholder="mime.types" value="`[ "$include" != "null" ] && echo "$include" || echo "mime.types"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_include
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  default_type
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="default_type" placeholder="application/octet-stream" value="`[ "$default_type" != "null" ] && echo "$default_type" || echo "application/octet-stream"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_default_type
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  charset
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="charset" placeholder="utf-8" value="`[ "$charset" != "null" ] && echo "$charset" || echo "utf-8"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_charset
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  autoindex
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="autoindex">
				<option `[ "$autoindex" = "off" ] && echo "selected"`>off</option>
				<option `[ "$autoindex" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_autoindex
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  server_names_hash_bucket_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="server_names_hash_bucket_size" placeholder="128" value="`[ "$server_names_hash_bucket_size" != "null" ] && echo "$server_names_hash_bucket_size" || echo "128"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_server_names_hash_bucket_size
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  client_header_buffer_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="client_header_buffer_size" placeholder="32k" value="`[ "$client_header_buffer_size" != "null" ] && echo "$client_header_buffer_size" || echo "32k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_client_header_buffer_size
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  large_client_header_buffers
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="large_client_header_buffers" placeholder="4 32k" value="`[ "$large_client_header_buffers" != "null" ] && echo "$large_client_header_buffers" || echo "4 32k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_large_client_header_buffers
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  client_max_body_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="client_max_body_size" placeholder="8m" value="`[ "$client_max_body_size" != "null" ] && echo "$client_max_body_size" || echo "8m"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_client_max_body_size
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  sendfile
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="sendfile">
				<option `[ "$sendfile" = "off" ] && echo "selected"`>off</option>
				<option `[ "$sendfile" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_sendfile
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  tcp_nopush
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="tcp_nopush">
				<option `[ "$tcp_nopush" = "off" ] && echo "selected"`>off</option>
				<option `[ "$tcp_nopush" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_tcp_nopush
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  tcp_nodelay
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="tcp_nodelay">
				<option `[ "$tcp_nodelay" = "off" ] && echo "selected"`>off</option>
				<option `[ "$tcp_nodelay" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_tcp_nodelay
		  </div>
		</div>

		<div class="row">
		  <div class="col-md-4">
		  keepalive_timeout
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="keepalive_timeout" placeholder="60" value="`[ "$keepalive_timeout" != "null" ] && echo "$keepalive_timeout" || echo "60"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_keepalive_timeout
		  </div>
		</div>
		
	</div>
	
	<h4 class="bg-danger">$_LANG_FastCGI_Setting</h4>
	<div class="row alert alert-info">
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_connect_timeout
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_connect_timeout" placeholder="300" value="`[ "$fastcgi_connect_timeout" != "null" ] && echo "$fastcgi_connect_timeout" || echo "300"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_connect_timeout
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_send_timeout
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_send_timeout" placeholder="300" value="`[ "$fastcgi_send_timeout" != "null" ] && echo "$fastcgi_send_timeout" || echo "300"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_send_timeout
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_read_timeout
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_read_timeout" placeholder="300" value="`[ "$fastcgi_read_timeout" != "null" ] && echo "$fastcgi_read_timeout" || echo "300"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_read_timeout
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_buffer_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_buffer_size" placeholder="64k" value="`[ "$fastcgi_buffer_size" != "null" ] && echo "$fastcgi_buffer_size" || echo "64k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_buffer_size
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_buffers
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_buffers" placeholder="4 64k" value="`[ "$fastcgi_buffers" != "null" ] && echo "$fastcgi_buffers" || echo "4 64k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_buffers
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_busy_buffers_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_busy_buffers_size" placeholder="128k" value="`[ "$fastcgi_busy_buffers_size" != "null" ] && echo "$fastcgi_busy_buffers_size" || echo "128k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_busy_buffers_size
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  fastcgi_temp_file_write_size
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="fastcgi_temp_file_write_size" placeholder="128k" value="`[ "$fastcgi_temp_file_write_size" != "null" ] && echo "$fastcgi_temp_file_write_size" || echo "128k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_fastcgi_temp_file_write_size
		  </div>
		</div>
	</div>
	<h4 class="bg-danger">$_LANG_GZIP_Setting</h4>
	<div class="row alert alert-info">
		<div class="row">
		  <div class="col-md-4">
		  gzip
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="gzip">
				<option `[ "$gzip" = "off" ] && echo "selected"`>off</option>
				<option `[ "$gzip" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_min_length
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="gzip_min_length" placeholder="1k" value="`[ "$gzip_min_length" != "null" ] && echo "$gzip_min_length" || echo "1k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_min_length
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_buffers
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="gzip_buffers" placeholder="4 16k" value="`[ "$gzip_buffers" != "null" ] && echo "$gzip_buffers" || echo "4 16k"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_buffers
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_http_version
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="gzip_http_version" placeholder="1.0" value="`[ "$gzip_http_version" != "null" ] && echo "$gzip_http_version" || echo "1.0"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_http_version
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_comp_level
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="gzip_comp_level" placeholder="2" value="`[ "$gzip_comp_level" != "null" ] && echo "$gzip_comp_level" || echo "2"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_comp_level
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_types
		  </div>
		  <div class="col-md-4">
		  <input type="text" class="form-control" name="gzip_types" placeholder="text/plain application/x-javascript text/css application/xml" value="`[ "$gzip_types" != "null" ] && echo "$gzip_types" || echo "text/plain application/x-javascript text/css application/xml"`">
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_types
		  </div>
		</div>
		<div class="row">
		  <div class="col-md-4">
		  gzip_vary
		  </div>
		  <div class="col-md-4">
			<select class="form-control" name="gzip_vary">
				<option `[ "$gzip_vary" = "off" ] && echo "selected"`>off</option>
				<option `[ "$gzip_vary" = "on" ] && echo "selected"`>on</option>
			</select>
		  </div>
		  <div class="col-md-4">
		  $_LANG_Set_gzip_vary
		  </div>
		</div>
	</div>
	
	<div class="row">
	  <div class="col-md-4">
		$_LANG_extra_config
	  </div>
	  <div class="col-md-4">
	<textarea style="width:100%;height:160px" name="http_extra" placeholder="#$_LANG_extra_config" class="bg-warning">`cat $DOCUMENT_ROOT/apps/nginx/extra_config/http_extra.config`</textarea>
	  </div>
	  <div class="col-md-4">
		$_LANG_extra_config
	  </div>
	</div>
</div>

<div class="row">
	<div class="heading">
	<input type="hidden" name="action" value="do_base_setting">
	<button type="submit" class="btn btn-primary btn-lg">$_LANG_Save</button>
	</div>
</div>

</form>








</div>
EOF

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
do_base_setting()
{
# old
old_config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`

old_username=`echo "$old_config_str" | jq -r '.["system"]["user"]["username"]'`
old_groupname=`echo "$old_config_str" | jq -r '.["system"]["user"]["groupname"]'`
old_worker_processes=`echo "$old_config_str" | jq -r '.["system"]["worker_processes"]'`
old_error_log=`echo "$old_config_str" | jq -r '.["system"]["error_log"]'`
old_error_log_level=`echo "$old_config_str" | jq -r '.["system"]["error_log_level"]'`
old_worker_rlimit_nofile=`echo "$old_config_str" | jq -r '.["system"]["worker_rlimit_nofile"]'`

old_use=`echo "$old_config_str" | jq -r '.["events"]["use"]'`
old_worker_connections=`echo "$old_config_str" | jq -r '.["events"]["worker_connections"]'`

old_include=`echo "$old_config_str" | jq -r '.["http"]["include"]'`
old_default_type=`echo "$old_config_str" | jq -r '.["http"]["default_type"]'`
old_charset=`echo "$old_config_str" | jq -r '.["http"]["charset"]'`
old_autoindex=`echo "$old_config_str" | jq -r '.["http"]["autoindex"]'`
old_server_names_hash_bucket_size=`echo "$old_config_str" | jq -r '.["http"]["server_names_hash_bucket_size"]'`
old_client_header_buffer_size=`echo "$old_config_str" | jq -r '.["http"]["client_header_buffer_size"]'`
old_large_client_header_buffers=`echo "$old_config_str" | jq -r '.["http"]["large_client_header_buffers"]'`
old_client_max_body_size=`echo "$old_config_str" | jq -r '.["http"]["client_max_body_size"]'`
old_sendfile=`echo "$old_config_str" | jq -r '.["http"]["sendfile"]'`

old_tcp_nopush=`echo "$old_config_str" | jq -r '.["http"]["tcp_nopush"]'`
old_tcp_nodelay=`echo "$old_config_str" | jq -r '.["http"]["tcp_nodelay"]'`
old_keepalive_timeout=`echo "$old_config_str" | jq -r '.["http"]["keepalive_timeout"]'`
old_fastcgi_connect_timeout=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_connect_timeout"]'`
old_fastcgi_send_timeout=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_send_timeout"]'`
old_fastcgi_read_timeout=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_read_timeout"]'`
old_fastcgi_buffer_size=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_buffer_size"]'`
old_fastcgi_buffers=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_buffers"]'`
old_fastcgi_busy_buffers_size=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_busy_buffers_size"]'`
old_fastcgi_temp_file_write_size=`echo "$old_config_str" | jq -r '.["http"]["fastcgi_temp_file_write_size"]'`

old_gzip=`echo "$old_config_str" | jq -r '.["http"]["gzip"]'`
old_gzip_min_length=`echo "$old_config_str" | jq -r '.["http"]["gzip_min_length"]'`
old_gzip_buffers=`echo "$old_config_str" | jq -r '.["http"]["gzip_buffers"]'`
old_gzip_http_version=`echo "$old_config_str" | jq -r '.["http"]["gzip_http_version"]'`
old_gzip_comp_level=`echo "$old_config_str" | jq -r '.["http"]["gzip_comp_level"]'`
old_gzip_types=`echo "$old_config_str" | jq -r '.["http"]["gzip_types"]'`
old_gzip_vary=`echo "$old_config_str" | jq -r '.["http"]["gzip_vary"]'`
# old

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`

[ -n "$FORM_username" ] && config_str=`echo "$config_str" | jq '.["system"]["user"]["username"] = "'"$FORM_username"'"'`
[ -n "$FORM_groupname" ] && config_str=`echo "$config_str" | jq '.["system"]["user"]["groupname"] = "'"$FORM_groupname"'"'`

[ -n "$FORM_worker_processes" ] && config_str=`echo "$config_str" | jq '.["system"]["worker_processes"] = "'"$FORM_worker_processes"'"'`
[ -n "$FORM_error_log" ] && config_str=`echo "$config_str" | jq '.["system"]["error_log"] = "'"$FORM_error_log"'"'`
[ -n "$FORM_error_log_level" ] && config_str=`echo "$config_str" | jq '.["system"]["error_log_level"] = "'"$FORM_error_log_level"'"'`
[ -n "$FORM_worker_rlimit_nofile" ] && config_str=`echo "$config_str" | jq '.["system"]["worker_rlimit_nofile"] = "'"$FORM_worker_rlimit_nofile"'"'`

[ -n "$FORM_use" ] && config_str=`echo "$config_str" | jq '.["events"]["use"] = "'"$FORM_use"'"'`
[ -n "$FORM_worker_connections" ] && config_str=`echo "$config_str" | jq '.["events"]["worker_connections"] = "'"$FORM_worker_connections"'"'`

[ -n "$FORM_include" ] && config_str=`echo "$config_str" | jq '.["http"]["include"] = "'"$FORM_include"'"'`
[ -n "$FORM_default_type" ] && config_str=`echo "$config_str" | jq '.["http"]["default_type"] = "'"$FORM_default_type"'"'`
[ -n "$FORM_charset" ] && config_str=`echo "$config_str" | jq '.["http"]["charset"] = "'"$FORM_charset"'"'`
[ -n "$FORM_autoindex" ] && config_str=`echo "$config_str" | jq '.["http"]["autoindex"] = "'"$FORM_autoindex"'"'`
[ -n "$FORM_server_names_hash_bucket_size" ] && config_str=`echo "$config_str" | jq '.["http"]["server_names_hash_bucket_size"] = "'"$FORM_server_names_hash_bucket_size"'"'`
[ -n "$FORM_client_header_buffer_size" ] && config_str=`echo "$config_str" | jq '.["http"]["client_header_buffer_size"] = "'"$FORM_client_header_buffer_size"'"'`
[ -n "$FORM_large_client_header_buffers" ] && config_str=`echo "$config_str" | jq '.["http"]["large_client_header_buffers"] = "'"$FORM_large_client_header_buffers"'"'`
[ -n "$FORM_client_max_body_size" ] && config_str=`echo "$config_str" | jq '.["http"]["client_max_body_size"] = "'"$FORM_client_max_body_size"'"'`
[ -n "$FORM_sendfile" ] && config_str=`echo "$config_str" | jq '.["http"]["sendfile"] = "'"$FORM_sendfile"'"'`
[ -n "$FORM_tcp_nopush" ] && config_str=`echo "$config_str" | jq '.["http"]["tcp_nopush"] = "'"$FORM_tcp_nopush"'"'`
[ -n "$FORM_tcp_nodelay" ] && config_str=`echo "$config_str" | jq '.["http"]["tcp_nodelay"] = "'"$FORM_tcp_nodelay"'"'`
[ -n "$FORM_keepalive_timeout" ] && config_str=`echo "$config_str" | jq '.["http"]["keepalive_timeout"] = "'"$FORM_keepalive_timeout"'"'`
[ -n "$FORM_fastcgi_connect_timeout" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_connect_timeout"] = "'"$FORM_fastcgi_connect_timeout"'"'`
[ -n "$FORM_fastcgi_send_timeout" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_send_timeout"] = "'"$FORM_fastcgi_send_timeout"'"'`
[ -n "$FORM_fastcgi_read_timeout" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_read_timeout"] = "'"$FORM_fastcgi_read_timeout"'"'`
[ -n "$FORM_fastcgi_buffer_size" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_buffer_size"] = "'"$FORM_fastcgi_buffer_size"'"'`
[ -n "$FORM_fastcgi_buffers" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_buffers"] = "'"$FORM_fastcgi_buffers"'"'`
[ -n "$FORM_fastcgi_busy_buffers_size" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_busy_buffers_size"] = "'"$FORM_fastcgi_busy_buffers_size"'"'`
[ -n "$FORM_fastcgi_temp_file_write_size" ] && config_str=`echo "$config_str" | jq '.["http"]["fastcgi_temp_file_write_size"] = "'"$FORM_fastcgi_temp_file_write_size"'"'`

[ -n "$FORM_gzip" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip"] = "'"$FORM_gzip"'"'`
[ -n "$FORM_gzip_min_length" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_min_length"] = "'"$FORM_gzip_min_length"'"'`
[ -n "$FORM_gzip_buffers" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_buffers"] = "'"$FORM_gzip_buffers"'"'`
[ -n "$FORM_gzip_http_version" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_http_version"] = "'"$FORM_gzip_http_version"'"'`
[ -n "$FORM_gzip_comp_level" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_comp_level"] = "'"$FORM_gzip_comp_level"'"'`
[ -n "$FORM_gzip_types" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_types"] = "'"$FORM_gzip_types"'"'`
[ -n "$FORM_gzip_vary" ] && config_str=`echo "$config_str" | jq '.["http"]["gzip_vary"] = "'"$FORM_gzip_vary"'"'`

echo "$config_str" | jq '.' >/dev/null 2>&1 && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_config.json
[ -n "$FORM_sys_extra" ] && echo "$FORM_sys_extra" > $DOCUMENT_ROOT/apps/nginx/extra_config/sys_extra.config
[ -n "$FORM_http_extra" ] && echo "$FORM_http_extra" > $DOCUMENT_ROOT/apps/nginx/extra_config/http_extra.config
[ -n "$FORM_events_extra" ] && echo "$FORM_events_extra" > $DOCUMENT_ROOT/apps/nginx/extra_config/events_extra.config
generate_nginx_config

main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_base_setting_change" \
				detail="_NOTICE_nginx_base_setting_change_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"old_username\":\"$old_username\", \
						\"old_groupname\":\"$old_groupname\", \
						\"old_worker_processes\":\"$old_worker_processes\", \
						\"old_error_log\":\"$old_error_log\", \
						\"old_error_log_level\":\"$old_error_log_level\", \
						\"old_worker_rlimit_nofile\":\"$old_worker_rlimit_nofile\", \
						\"old_use\":\"$old_use\", \
						\"old_worker_connections\":\"$old_worker_connections\", \
						\"old_include\":\"$old_include\", \
						\"old_default_type\":\"$old_default_type\", \
						\"old_charset\":\"$old_charset\", \
						\"old_autoindex\":\"$old_autoindex\", \
						\"old_server_names_hash_bucket_size\":\"$old_server_names_hash_bucket_size\", \
						\"old_client_header_buffer_size\":\"$old_client_header_buffer_size\", \
						\"old_large_client_header_buffers\":\"$old_large_client_header_buffers\", \
						\"old_client_max_body_size\":\"$old_client_max_body_size\", \
						\"old_sendfile\":\"$old_sendfile\", \
						\"old_tcp_nopush\":\"$old_tcp_nopush\", \
						\"old_tcp_nodelay\":\"$old_tcp_nodelay\", \
						\"old_keepalive_timeout\":\"$old_keepalive_timeout\", \
						\"old_fastcgi_connect_timeout\":\"$old_fastcgi_connect_timeout\", \
						\"old_fastcgi_send_timeout\":\"$old_fastcgi_send_timeout\", \
						\"old_fastcgi_read_timeout\":\"$old_fastcgi_read_timeout\", \
						\"old_fastcgi_buffer_size\":\"$old_fastcgi_buffer_size\", \
						\"old_fastcgi_buffers\":\"$old_fastcgi_buffers\", \
						\"old_fastcgi_busy_buffers_size\":\"$old_fastcgi_busy_buffers_size\", \
						\"old_fastcgi_temp_file_write_size\":\"$old_fastcgi_temp_file_write_size\", \
						\"old_gzip\":\"$old_gzip\", \
						\"old_gzip_min_length\":\"$old_gzip_min_length\", \
						\"old_gzip_buffers\":\"$old_gzip_buffers\", \
						\"old_gzip_http_version\":\"$old_gzip_http_version\", \
						\"old_gzip_comp_level\":\"$old_gzip_comp_level\", \
						\"old_gzip_types\":\"$old_gzip_types\", \
						\"old_gzip_vary\":\"$old_gzip_vary\", \
						\"username\":\"$FORM_username\", \
						\"groupname\":\"$FORM_groupname\", \
						\"worker_processes\":\"$FORM_worker_processes\", \
						\"error_log\":\"$FORM_error_log\", \
						\"error_log_level\":\"$FORM_error_log_level\", \
						\"worker_rlimit_nofile\":\"$FORM_worker_rlimit_nofile\", \
						\"use\":\"$FORM_use\", \
						\"worker_connections\":\"$FORM_worker_connections\", \
						\"include\":\"$FORM_include\", \
						\"default_type\":\"$FORM_default_type\", \
						\"charset\":\"$FORM_charset\", \
						\"autoindex\":\"$FORM_autoindex\", \
						\"server_names_hash_bucket_size\":\"$FORM_server_names_hash_bucket_size\", \
						\"client_header_buffer_size\":\"$FORM_client_header_buffer_size\", \
						\"large_client_header_buffers\":\"$FORM_large_client_header_buffers\", \
						\"client_max_body_size\":\"$FORM_client_max_body_size\", \
						\"sendfile\":\"$FORM_sendfile\", \
						\"tcp_nopush\":\"$FORM_tcp_nopush\", \
						\"tcp_nodelay\":\"$FORM_tcp_nodelay\", \
						\"keepalive_timeout\":\"$FORM_keepalive_timeout\", \
						\"fastcgi_connect_timeout\":\"$FORM_fastcgi_connect_timeout\", \
						\"fastcgi_send_timeout\":\"$FORM_fastcgi_send_timeout\", \
						\"fastcgi_read_timeout\":\"$FORM_fastcgi_read_timeout\", \
						\"fastcgi_buffer_size\":\"$FORM_fastcgi_buffer_size\", \
						\"fastcgi_buffers\":\"$FORM_fastcgi_buffers\", \
						\"fastcgi_busy_buffers_size\":\"$FORM_fastcgi_busy_buffers_size\", \
						\"fastcgi_temp_file_write_size\":\"$FORM_fastcgi_temp_file_write_size\", \
						\"gzip\":\"$FORM_gzip\", \
						\"gzip_min_length\":\"$FORM_gzip_min_length\", \
						\"gzip_buffers\":\"$FORM_gzip_buffers\", \
						\"gzip_http_version\":\"$FORM_gzip_http_version\", \
						\"gzip_comp_level\":\"$FORM_gzip_comp_level\", \
						\"gzip_types\":\"$FORM_gzip_types\", \
						\"gzip_vary\":\"$FORM_gzip_vary\" \
					}" >/dev/null 2>&1

(echo "Success save" | main.sbin output_json 0) || exit 0
}