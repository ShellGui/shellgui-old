#!/bin/sh

main()
{
eval `cat $DOCUMENT_ROOT/apps/curl/curl.conf`
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#do_proxy_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=curl&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
$(function(){
  $('#curl_test').on('click', function(e){
	var $btn = $(this);
    $btn.button('loading');
  var host=document.getElementById("curl_test_host").value;
  var url = 'index.cgi?app=curl&action=curl_test&host='+host;
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#curl_test_content').html(data);
	$btn.button('reset');
  }, 1);
  });
});
</script>
EOF

cat <<EOF
<div class="row"> <!--start-->
<div class="col-md-6" id="ajax-proxy">
<legend>$_LANG_Base_setting</legend>
<p class="bg-warning">$_LANG_Can_be_empty</p>
<form id="do_proxy_setting">
<table class="table">
<tr>
<td>
$_LANG_Timeout_in_seconds
</td>
<td>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="lo">Hidden label</label>
  <input type="text" class="form-control" placeholder="Username" name="connect_timeout" value="$connect_timeout">
  <span class="glyphicon form-control-feedback">s</span>
</div>
</td>
</tr>
<tr>
<td>
$_LANG_The_maximum_time_limit_task_execution
</td>
<td>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="lo">Hidden label</label>
  <input type="text" class="form-control" placeholder="Username" name="max_time" value="$max_time">
  <span class="glyphicon form-control-feedback">s</span>
</div>
</td>
</tr>
<tr>
<td>
$_LANG_Ignore_SSL_certificate
</td>
<td>
<input type="checkbox" name="insecure" value="1" `[ $insecure = 1 ] && echo checked`>
</td>
</tr>
<tr>
<td>
$_LANG_Task_force_quit_conditions
</td>
<td>
<label>$_LANG_Keep_this_speed_below</label>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="lo">Hidden label</label>
  <input type="text" class="form-control" placeholder="Username" name="speed_limit" value="$speed_limit">
  <span class="glyphicon form-control-feedback">k/s</span>
</div>

<label>$_LANG_Seconds_after_sustained</label>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="lo">Hidden label</label>
  <input type="text" class="form-control" placeholder="Username" name="speed_time" value="$speed_time">
  <span class="glyphicon form-control-feedback">s</span>
</div>
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="do_curl_setting">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>
</div>


<div class="col-md-6" id="ajax-proxy">
<legend>$_LANG_Proxy_Setting</legend>
<p class="bg-warning">$_LANG_Del_all_proxy_setting_will_turn_off_proxy_function</p>
<form id="do_proxy_setting">
<table class="table">
<tr>
<td>
$_LANG_Proxy_Proto
</td>
<td>
<select class="form-control" name="proxy_mod">
EOF
if
echo "$proxy_mod" | grep -q "http"
then
http_selected="selected"
else
socket5_selected="selected"
fi
cat <<EOF
	<option value="http" $http_selected>http</option>
	<option value="socks5" $socket5_selected>socket5</option>
</select>
</td>
</tr>
<tr>
<td>
$_LANG_Proxy_Server
</td>
<td>
<input type="text" class="form-control" placeholder="Proxy server" name="proxy_server" value="$proxy_server">
</td>
</tr>
<tr>
<td>
$_LANG_Port
</td>
<td>
<input type="text" class="form-control" placeholder="Proxy Port" name="proxy_port" value="$proxy_port">
</td>
</tr>
<tr>
<td>
$_LANG_Username&$_LANG_Password<p>$_LANG_if_need
</td>
<td>
<input type="text" class="form-control" placeholder="Username" name="proxy_username" value="$proxy_username"><p>
<input type="text" class="form-control" placeholder="Password" name="proxy_password" value="$proxy_password">
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="do_proxy_setting">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>
</div>
</div> <!--end-->

<div class="col-md-6">
<legend>$_LANG_Proxy_test</legend>
	<div class="col-md-8">
	<input type="text" id="curl_test_host" class="form-control" name="curl_test_host" placeholder="IP/Domain" value="http://checkip.dyndns.com/">
	</div>
	<div class="col-md-4">
	<button id="curl_test" type="button" class="btn btn-primary">$_LANG_Go</button>
	</div>
	<div class="col-md-12">
<div class="panel-collapse collapse in">
		  <div class="panel-body">
<textarea id="curl_test_content" style="width:100%;height:260px" name="curl_test_content" class="bg-warning">$_LANG_test_Result
</textarea>
		  </div>
	  </div>
	</div>
</div>
EOF
}

curl_test()
{
curl_load
curl $curl_args -L "$FORM_host" 2>&1
}
do_proxy_setting()
{
if
[ -n "$FORM_proxy_port" ]
then
echo "$FORM_proxy_port" | main.sbin regx_str islang_alb || echo "$_LANG_Port_must_use_number" | main.sbin output_json 1 || exit 1
([ "$FORM_proxy_port" -lt 65535 ] || echo "$_LANG_Port_must_litter_then_65535" | main.sbin output_json 1) || exit 1
fi

if
[ -n "$FORM_proxy_server" ]
then
echo "$FORM_proxy_server" | main.sbin regx_str isdomain || echo "$FORM_proxy_server" | main.sbin regx_str isip_ipv4 || echo "$_LANG_Server_must_be_Domain_or_ip" | main.sbin output_json 1 || exit 1
fi

sed -i '/^proxy_server=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "proxy_server=$FORM_proxy_server" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^proxy_port=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "proxy_port=$FORM_proxy_port" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^proxy_mod=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "proxy_mod=$FORM_proxy_mod" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^proxy_username=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "proxy_username=$FORM_proxy_username" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^proxy_password=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "proxy_password=$FORM_proxy_password" >>$DOCUMENT_ROOT/apps/curl/curl.conf

echo "$_LANG_Save_successfull" | main.sbin output_json 0 || exit 0
}

do_curl_setting()
{
echo "$FORM_speed_time" | main.sbin regx_str islang_alb || echo "必须为数字" | main.sbin output_json 1 || exit 1
echo "$FORM_speed_limit" | main.sbin regx_str islang_alb || echo "必须为数字" | main.sbin output_json 1 || exit 1
echo "$FORM_connect_timeout" | main.sbin regx_str islang_alb || echo "必须为数字" | main.sbin output_json 1 || exit 1
echo "$FORM_max_time" | main.sbin regx_str islang_alb || echo "必须为数字" | main.sbin output_json 1 || exit 1

sed -i '/^speed_time=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "speed_time=$FORM_speed_time" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^speed_limit=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "speed_limit=$FORM_speed_limit" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^connect_timeout=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "connect_timeout=$FORM_connect_timeout" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^max_time=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
echo "max_time=$FORM_max_time" >>$DOCUMENT_ROOT/apps/curl/curl.conf
sed -i '/^insecure=/d' $DOCUMENT_ROOT/apps/curl/curl.conf
[ -n "$FORM_insecure" ] && echo "insecure=1" >>$DOCUMENT_ROOT/apps/curl/curl.conf

echo "$_LANG_Save_successfull" | main.sbin output_json 0 || exit 0
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/curl/curl_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi