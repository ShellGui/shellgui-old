vhost()
{

if
[ -n "$FORM_vhost" ]
then
vhost_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json | jq '.["'$FORM_vhost'"]'`
listen_ip=`echo "$vhost_str" | jq -r '.["listen"]["ip"]'`
[ "$listen_ip" = "null" ] && listen_ip=""
listen_port=`echo "$vhost_str" | jq -r '.["listen"]["port"]'`
server_name=`echo "$vhost_str" | jq -r '.["server_name"]'`
index=`echo "$vhost_str" | jq -r '.["index"]'`
root=`echo "$vhost_str" | jq -r '.["root"]'`
[ "$root" = "null" ] && root=""
ssl=`echo "$vhost_str" | jq -r '.["ssl"]'`
ssl_certificate=`echo "$vhost_str" | jq -r '.["ssl_certificate"]'`
[ "$ssl_certificate" = "null" ] && ssl_certificate=""
ssl_certificate_key=`echo "$vhost_str" | jq -r '.["ssl_certificate_key"]'`
[ "$ssl_certificate_key" = "null" ] && ssl_certificate_key=""
fi
_LANG_App_name="$_LANG_App_name -> $_LANG_vhost"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<'EOF'
<script>
function insertAtCursor(myField, myValue) {
//IE support
if (document.selection) {
myField.focus();
sel = document.selection.createRange();
sel.text = myValue;
sel.select();
}
//MOZILLA/NETSCAPE support 
else if (myField.selectionStart || myField.selectionStart == '0') {
var startPos = myField.selectionStart;
var endPos = myField.selectionEnd;
// save scrollTop before insert
var restoreTop = myField.scrollTop;
myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
if (restoreTop > 0) {
myField.scrollTop = restoreTop;
}
myField.focus();
myField.selectionStart = startPos + myValue.length;
myField.selectionEnd = startPos + myValue.length;
} else {
myField.value += myValue;
myField.focus();
}
}

$(function(){
  $('#do_vhost').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.href='index.cgi?app=nginx';", 3000);
  });
});
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF



cat <<EOF
<div class="container">

<legend>server</legend>
<form id="do_vhost">
<div class="row alert alert-warning">
	<div class="row">
		<div class="col-md-4">
		listen
		</div>
		<div class="col-md-4">
			<div class="row">
				<div class="col-md-6">
<input class="form-control" list="ip" name="ip" value="`[ -n "$listen_ip" ] && echo "$listen_ip"`">
<datalist id="ip">
EOF
for ip in `ifconfig | grep -Po '(?<=[^0-9.]|^)[1-9][0-9]{0,2}(\.([0-9]{0,3})){3}(?=[^0-9.]|$)' | grep -vE "^255|255$"`
do
cat <<EOF
<option value="${ip}">${ip}</option>
EOF
done
cat <<EOF
<option value="*">*</option>
</datalist>


				</div>
				<div class="col-md-6">
					<input type="text" class="form-control" name="port" placeholder="80" value="`[ -n "$listen_port" ] && echo "$listen_port" || echo "80"`">
				</div>
			</div>
		</div>
		<div class="col-md-4">
		$_LANG_Set_listen
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		server_name
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" name="server_name" placeholder="example.com" value="`[ -n "$server_name" ] && echo "$server_name"`">
		</div>
		<div class="col-md-4">
		$_LANG_Set_server_name
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		index
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" name="index" placeholder="index.html index.htm" value="`[ -n "$index" ] && echo "$index" || echo "index.html index.htm"`">
		</div>
		<div class="col-md-4">
		$_LANG_Set_index
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		root
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" name="root" placeholder="/data/htdocs/www" value="`[ -n "$root" ] && echo "$root"`">
		</div>
		<div class="col-md-4">
		$_LANG_Set_root
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		ssl
		</div>
		<div class="col-md-4">
			<select class="form-control" name="ssl">
				<option `[ "$ssl" = "off" ] && echo "selected"`>off</option>
				<option `[ "$ssl" = "on" ] && echo "selected"`>on</option>
			</select>
		</div>
		<div class="col-md-4">
		$_LANG_Set_ssl
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		ssl_certificate
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" name="ssl_certificate" placeholder="/path/public.csr & public.crt" value="`[ -n "$ssl_certificate" ] && echo "$ssl_certificate"`">
		</div>
		<div class="col-md-4">
		$_LANG_Set_ssl_certificate
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
		ssl_certificate_key
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" name="ssl_certificate_key" placeholder="/path/xx.pem" value="`[ -n "$ssl_certificate_key" ] && echo "$ssl_certificate_key"`">
		</div>
		<div class="col-md-4">
		$_LANG_Set_ssl_certificate_key
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<label>$_LANG_extra_config<button type="button" onclick="\$('#host_extra_config').val('')" class="btn btn-danger">$_LANG_Clean</button></label>
			<textarea id="host_extra_config" style="width:100%;height:480px" name="vhost_extra" placeholder="$_LANG_extra_config">`cat $DOCUMENT_ROOT/apps/nginx/extra_config/$FORM_vhost.config`</textarea>
		</div>
		<div class="col-md-6">
			<label>cgi-fcgi模板</label>
			<div class="row">
EOF
cat $DOCUMENT_ROOT/apps/nginx/conf_tpl/host_cgi_fgi_tpl/*
cat <<EOF
			</div>
			<label>文件缓存类型模板</label>
			<div class="row">
EOF
cat $DOCUMENT_ROOT/apps/nginx/conf_tpl/host_file_cache_tpl/*
cat <<EOF
			</div>
			<label>日志</label>
			<div class="row">
			
EOF

for log_file in `find $DOCUMENT_ROOT/apps/nginx/log_tpl -maxdepth 1 -type f`
do
log_name=`basename ${log_file}`
cat <<EOF
<input type="button" class="btn btn-primary" onclick="insertAtCursor(document.getElementById('host_extra_config'),'\naccess_log  /data/logs/access_$FORM_vhost.log  ${log_name};\n\n')" value="${log_name}" />

EOF
done
cat <<EOF
			</div>
			<label>其他</label>
			<div class="row">
EOF
cat $DOCUMENT_ROOT/apps/nginx/conf_tpl/host_others_tpl/*
cat <<EOF
			</div>
			<label>rewrite模板</label>
			<div class="row">
EOF
for rewrite_rule_file in `find /usr/local/nginx/conf/rewrite -maxdepth 1 -type f | grep "\.conf$"`
do
rewrite_rule=`basename ${rewrite_rule_file}`
cat <<EOF
<input type="button" class="btn btn-info" onclick="insertAtCursor(document.getElementById('host_extra_config'),'\ninclude rewrite/${rewrite_rule};\n\n')" value="${rewrite_rule}" />

EOF
done
cat <<EOF
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="heading">
	<input type="hidden" name="action" value="do_vhost">
	<input type="hidden" name="oldvhost" value="$FORM_vhost">
	<button type="submit" class="btn btn-primary btn-lg">$_LANG_Save</button>
	</div>
</div>


</form>



EOF

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
do_vhost()
{
[ -n "$FORM_port" ] || (echo "vhost need port" | main.sbin output_json 1) || exit 1
if
[ "$FORM_oldvhost" != "default" ] && [ -z "$FORM_server_name" ]
then
(echo "vhost need server_name" | main.sbin output_json 1) || exit 1
fi

[ -n "$FORM_root" ] || (echo "vhost need root" | main.sbin output_json 1) || exit 1
echo "$FORM_root" | main.sbin regx_str ispath || (echo "vhost must be a path" | main.sbin output_json 1) || exit 1
[ -d $FORM_root ] || mkdir -p $FORM_root

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`

if
[ -z "$FORM_oldvhost" ]
then
FORM_oldvhost="vhost-$(date +%s)"
create_time=`date +%Y-%m-%d" "%H:%M:%S`
new_vhost=1
else
old_vhost_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
old_listen_ip=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["listen"]["ip"]'`
[ "$old_listen_ip" = "null" ] && old_listen_ip=""
old_listen_port=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["listen"]["port"]'`
old_server_name=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["server_name"]'`
old_index=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["index"]'`
old_root=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["root"]'`
old_ssl=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["ssl"]'`
old_ssl_certificate=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["ssl_certificate"]'`
[ "$old_ssl_certificate" = "null" ] && old_ssl_certificate=""
old_ssl_certificate_key=`echo "$old_vhost_str" | jq -r '.["'$FORM_oldvhost'"]["ssl_certificate_key"]'`
[ "$old_ssl_certificate_key" = "null" ] && old_ssl_certificate_key=""

fi
[ -n "$FORM_ip" ] && [ "$FORM_ip" != "null" ]  && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["listen"]["ip"] = "'"$FORM_ip"'"'`
[ -n "$FORM_port" ] && [ "$FORM_port" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["listen"]["port"] = "'"$FORM_port"'"'`

[ -n "$FORM_server_name" ] && [ "$FORM_server_name" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["server_name"] = "'"$FORM_server_name"'"'`
[ -n "$create_time" ] && [ "$create_time" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["create_time"] = "'"$create_time"'"'`
[ -n "$FORM_index" ] && [ "$FORM_index" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["index"] = "'"$FORM_index"'"'`
[ -n "$FORM_root" ] && [ "$FORM_root" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["root"] = "'"$FORM_root"'"'`
[ -n "$FORM_ssl" ] && [ "$FORM_ssl" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["ssl"] = "'"$FORM_ssl"'"'`
[ "$FORM_ssl_certificate" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["ssl_certificate"] = "'"$FORM_ssl_certificate"'"'`
[ "$FORM_ssl_certificate_key" != "null" ] && config_str=`echo "$config_str" | jq '.["'$FORM_oldvhost'"]["ssl_certificate_key"] = "'"$FORM_ssl_certificate_key"'"'`


echo "$config_str" | jq '.' >/dev/null 2>&1 && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json
[ -n "$FORM_vhost_extra" ] && echo "$FORM_vhost_extra" > $DOCUMENT_ROOT/apps/nginx/extra_config/$FORM_oldvhost.config

if
[ $new_vhost -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_added" \
				detail="_NOTICE_nginx_vhost_added_detail" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"vhost\":\"$FORM_oldvhost\", \
						\"listen_ip\":\"$FORM_ip\", \
						\"listen_port\":\"$FORM_port\", \
						\"server_name\":\"$FORM_server_name\", \
						\"index\":\"$FORM_index\", \
						\"root\":\"$FORM_root\", \
						\"ssl\":\"$FORM_ssl\", \
						\"ssl_certificate\":\"$FORM_ssl_certificate\", \
						\"ssl_certificate_key\":\"$FORM_ssl_certificate_key\" \
					}" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_modified" \
				detail="_NOTICE_nginx_vhost_modified_detail" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"vhost\":\"$FORM_oldvhost\", \
						\"old_listen_ip\":\"$old_listen_ip\", \
						\"old_listen_port\":\"$old_listen_port\", \
						\"old_server_name\":\"$old_server_name\", \
						\"old_index\":\"$old_index\", \
						\"old_root\":\"$old_root\", \
						\"old_ssl\":\"$old_ssl\", \
						\"old_ssl_certificate\":\"$old_ssl_certificate\", \
						\"old_ssl_certificate_key\":\"$old_ssl_certificate_key\", \
						\"listen_ip\":\"$FORM_ip\", \
						\"listen_port\":\"$FORM_port\", \
						\"server_name\":\"$FORM_server_name\", \
						\"index\":\"$FORM_index\", \
						\"root\":\"$FORM_root\", \
						\"ssl\":\"$FORM_ssl\", \
						\"ssl_certificate\":\"$FORM_ssl_certificate\", \
						\"ssl_certificate_key\":\"$FORM_ssl_certificate_key\" \
					}" >/dev/null 2>&1
fi
generate_nginx_config
(echo "vhost edit Success" | main.sbin output_json 0) || exit 0
}

del_vhost()
{

[ -n "$FORM_vhost" ] || exit 1
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
server_name=`echo "$config_str" | jq -r '.["'"$FORM_vhost"'"]["server_name"]'`
if
echo "$config_str" | jq '.["'"$FORM_vhost"'"]' >/dev/null 2>&1
then
config_str=`echo "$config_str" | jq 'del(.["'"$FORM_vhost"'"])'`
[ $? -eq 0 ] && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json
rm -f $DOCUMENT_ROOT/apps/nginx/extra_config/$FORM_vhost.config
fi
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_deled" \
				detail="_NOTICE_nginx_vhost_deled" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"vhost\":\"$FORM_vhost\", \
						\"server_name\":\"$server_name\" \
					}" >/dev/null 2>&1
generate_nginx_config

(echo "Del vhost Success" | main.sbin output_json 0) || exit 0
}

disabled_vhost()
{


_LANG_App_name="$_LANG_App_name -> $_LANG_Disabled $FORM_vhost"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<'EOF'
<script>
$(function(){
  $('#disabled_option').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>

EOF

cat <<EOF
<div class="container hwapper" id="ajax-fluid"> <!--container-->
EOF

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`

cat <<EOF
<form class="form-inline" role="form" id="disabled_option">
<label>$_LANG_Disabled_option</label>
<input type="text" class="form-control" name="disabled_option" placeholder="Number" value="`echo "$config_str" | jq -r '.["'$FORM_vhost'"]["disabled_option"]'`">
<input type="hidden" name="action" value="disabled_option">
<input type="hidden" name="vhost" value="$FORM_vhost">
<button type="submit" class="btn btn-primary">$_LANG_Save</button>
</form>

EOF

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
do_disabled_vhost()
{
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
echo "$config_str" | jq '.["'$FORM_vhost'"]' | grep -q "{" || (echo "vhost $_LANG_No_exist" | main.sbin output_json 1) || exit 1
server_name=`echo "$config_str" | jq -r '.["'$FORM_vhost'"]["server_name"]'`
config_str=`echo "$config_str" | jq '.["'$FORM_vhost'"]["disabled_option"] = "return 500"'`
echo "$config_str" | jq '.' >/dev/null 2>&1 && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json && generate_nginx_config
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_disabled" \
				detail="_NOTICE_nginx_vhost_disabled" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"vhost\":\"$FORM_vhost\", \
						\"server_name\":\"$server_name\" \
					}" >/dev/null 2>&1
(echo "vhost $_LANG_Already_stoped" | main.sbin output_json 0) || exit 0
}
do_enable_vhost()
{
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
echo "$config_str" | jq '.["'$FORM_vhost'"]' | grep -q "{" || (echo "vhost $_LANG_No_exist" | main.sbin output_json 1) || exit 1
server_name=`echo "$config_str" | jq -r '.["'$FORM_vhost'"]["server_name"]'`
config_str=`echo "$config_str" | jq 'del(.["'$FORM_vhost'"]["disabled_option"])'`
echo "$config_str" | jq '.' >/dev/null 2>&1 && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json && generate_nginx_config
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_enabled" \
				detail="_NOTICE_nginx_vhost_enabled" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"vhost\":\"$FORM_vhost\", \
						\"server_name\":\"$server_name\" \
					}" >/dev/null 2>&1
(echo "vhost $_LANG_Already_working" | main.sbin output_json 0) || exit 0
}
disabled_option()
{
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
echo "$config_str" | jq '.["'$FORM_vhost'"]' | grep -q "{" || (echo "vhost $_LANG_No_exist" | main.sbin output_json 1) || exit 1
server_name=`echo "$config_str" | jq -r '.["'$FORM_vhost'"]["server_name"]'`
config_str=`echo "$config_str" | jq '.["'$FORM_vhost'"]["disabled_option"] = "'"$FORM_disabled_option"'"'`
echo "$config_str" | jq '.' >/dev/null 2>&1 && echo "$config_str" > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json && generate_nginx_config
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_vhost_enable_option_change" \
				detail="_NOTICE_nginx_vhost_enable_option_change_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="nginx" \
				dest_type="app" \
					variable="{\
						\"disabled_option\":\"$FORM_disabled_option\", \
						\"vhost\":\"$FORM_vhost\", \
						\"server_name\":\"$server_name\" \
					}" >/dev/null 2>&1
(echo "vhost $_LANG_Already_stoped" | main.sbin output_json 0) || exit 0
}
. $DOCUMENT_ROOT/apps/nginx/nginx_lib.sh