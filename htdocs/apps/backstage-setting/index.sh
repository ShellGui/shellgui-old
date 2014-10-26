#!/bin/sh

main()
{
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#do_save_username_passwd').on('submit', function(e){
    e.preventDefault();
    var data = "app=backstage-setting&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#do_save_server_port').on('submit', function(e){
    e.preventDefault();
    var data = "app=backstage-setting&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#do_save_session_time').on('submit', function(e){
    e.preventDefault();
    var data = "app=backstage-setting&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF
<div class="col-md-6">
<form id="do_save_username_passwd">
<legend>$_LANG_htpass_setting</legend>
	<div class="form-group">
	<label>$_LANG_Username</label>
	<input type="text" class="form-control" placeholder="$_LANG_Enter_Username" name="username" value="`cat $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.htpasswd | awk -F ":" {'print $1'} | sed -n 1p`">
	</div>
	<div class="form-group">
	<label>$_LANG_Password</label>
	<input type="password" class="form-control" placeholder="$_LANG_Enter_Password_to_change" name="passwd"><p>
	<input type="password" class="form-control" placeholder="$_LANG_Enter_Password_to_confirm" name="passwd_cf">
	</div>
	<input type="hidden" name="action" value="do_save_username_passwd">
	<button type="submit" class="btn btn-primary">$_LANG_Save</button>
</form>
</div>
<div class="col-md-6">
<form id="do_save_server_port">
<legend>$_LANG_http_server_setting</legend>
	<div class="form-group">
	<label>$_LANG_ServerPort</label>
	<input type="text" class="form-control" placeholder="$_LANG_Enter_Port" name="server_port" value="`cat $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.conf | grep "^server.port" | grep -Po "[0-9]*"`">
	</div>
	<input type="hidden" name="action" value="do_save_server_port">
	<button type="submit" class="btn btn-primary">$_LANG_Save</button>
</form>
</div>
<div class="col-md-6">
<form id="do_save_session_time">
<legend>$_LANG_Auth_session_time_setting</legend>
	<div class="form-group">
	<label>$_LANG_Session_time_limit</label>
	<input type="text" class="form-control" placeholder="$_LANG_Enter_Secends" name="session_time" value="`cat $DOCUMENT_ROOT/apps/home/home.conf | grep "^session_time=" | grep -Po "[0-9]*"`">
	</div>
	<input type="hidden" name="action" value="do_save_session_time">
	<button type="submit" class="btn btn-primary">$_LANG_Save</button>
</form>
</div>
EOF
}

do_save_username_passwd()
{
[ -n "$FORM_username" ] || (echo "$_LANG_Username $_LANG_Can_not_be_empty" | main.sbin output_json 1) || exit 1
[ -n "$FORM_passwd" ] || (echo "密码不能为空" | main.sbin output_json 1) || exit 1
[ `expr length "$FORM_passwd"` -ge 6 ] || (echo "$_LANG_Password_can_not_less_then_6" | main.sbin output_json 1) || exit 1
[ "$FORM_passwd" = "$FORM_passwd_cf" ] || (echo "$_LANG_Passwords_confirm_not_same" | main.sbin output_json 1) || exit 1
rm -f $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.htpasswd
$DOCUMENT_ROOT/../bin/htpasswd -c -b -d $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.htpasswd $FORM_username $FORM_passwd 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_save_username_passwd" \
				detail="_NOTICE_do_save_username_passwd" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="backstage-setting" \
				dest_type="app" \
					variable="{\
						\"username\":\"$FORM_username\" \
					}" >/dev/null 2>&1
(echo "$_LANG_Successful" | main.sbin output_json 0) || exit 0
}
do_save_server_port()
{
[ -n "$FORM_server_port" ] || (echo "$_LANG_ServerPort $_LANG_Can_not_be_empty" | main.sbin output_json 1) || exit 1
([ $FORM_server_port -gt 0 ] && [ $FORM_server_port -le 65535 ]) || (echo "$_LANG_Port_must_be_number_less_then_65535" | main.sbin output_json 1) || exit 1
old_server_port=`cat $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.conf | grep "^server.port" | grep -Po "[0-9]*"`
sed -i "s/^server.port.*=.*$/server.port = $FORM_server_port/g" $DOCUMENT_ROOT/../etc/lighttpd/lighttpd.conf
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
old_allow_ports=`echo "$base_firewall_str" | jq -r '.["wan_zone"]["wan"]["allow_ports"]'`
now_allow_ports=`echo "$old_allow_ports" | sed "s/[ ]*$old_server_port[ ]*/ $FORM_server_port /" | sed 's/[ ][ ]*/ /g'`
base_firewall_str=`echo "$base_firewall_str" | jq -r '.["wan_zone"]["wan"]["allow_ports"] = "'"$now_allow_ports"'"'`
echo "$base_firewall_str" | jq '.' | grep -q "{" && echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_save_server_port" \
				detail="_NOTICE_do_save_server_port_detail" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="backstage-setting" \
				dest_type="app" \
					variable="{\
						\"old_server_port\":\"$old_server_port\", \
						\"server_port\":\"$FORM_server_port\" \
					}" >/dev/null 2>&1
$DOCUMENT_ROOT/../bin/busybox start-stop-daemon -S -b -x main.sbin init
(echo "$_LANG_Save $FORM_server_port" | main.sbin output_json 0) || exit 0
}
do_save_session_time()
{
[ -n "$FORM_session_time" ] || (echo "Session $_LANG_Can_not_be_empty" | main.sbin output_json 1) || exit 1
[ $FORM_session_time -ge 60 ] || (echo "$_LANG_Session_time_must_more_then_60" | main.sbin output_json 1) || exit 1
old_session_time=`eval $(cat $DOCUMENT_ROOT/apps/home/home.conf) && echo $session_time`
sed -i "s/^session_time.*=.*$/session_time=$FORM_session_time/g" $DOCUMENT_ROOT/apps/home/home.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_save_session_time" \
				detail="_NOTICE_do_save_session_time" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="backstage-setting" \
				dest_type="app" \
					variable="{\
						\"old_session_time\":\"$old_session_time\", \
						\"session_time\":\"$FORM_session_time\" \
					}" >/dev/null 2>&1
(echo "$_LANG_Save $FORM_session_time" | main.sbin output_json 0) || exit 0
}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi
