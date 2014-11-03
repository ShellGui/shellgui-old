#!/bin/sh
main()
{
dnscrypt_proxy_pid=`ps aux | grep -v grep | grep "dnscrypt-proxy" | grep "local-address" | sed -n 1p | awk {'print $2'}`
if
echo $dnscrypt_proxy_pid | grep -qE '[0-9]'
then
status_icon="<span class=\"glyphicon glyphicon-play alert-success\"></span>"
else
status_icon="<span class=\"glyphicon glyphicon-pause\"></span>"
fi
eval `main.sbin pid_uptime $dnscrypt_proxy_pid`
if
grep -q "enable=1" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init
then
on_selected="selected=\"selected\""
else
off_selected="selected=\"selected\""
fi

cat <<'EOF'
<script>
$(function(){
  $('#dnscrypt_proxy_service').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnscrypt-proxy&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#bind_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnscrypt-proxy&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
//	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#dnscrypt_proxy_server').on('submit', function(e){
    e.preventDefault();
    var data = "app=dnscrypt-proxy&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
//	setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF

check_dnscrypt_proxy_installed || warning

cat <<EOF
<div class="col-md-6">
	<div class="controls">
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">$_LANG_Service_Status</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="dnscrypt_proxy_service">
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
					$_LANG_DNScrypt_proxy_service
						<select name="dnscrypt_proxy_enable">
						  <option value="1" $on_selected>$_LANG_On</option>
						  <option value="0" $off_selected>$_LANG_Off</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="dnscrypt_proxy_service">
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
eval `grep -E "^bind_ip=|^bind_port=|^resolv_name=" $DOCUMENT_ROOT/apps/dnscrypt-proxy/S400dnscryptc.init`
cat <<EOF
<div class="col-md-6">
<form id="bind_setting">
<table class="table">
<tr>
<th>Bind IP</th>
<td><input class="form-control" type="text" placeholder="0.0.0.0" name="bind_ip" value="$bind_ip"></td>
</tr>
<tr>
<th>Bind Port</th>
<td><input class="form-control" type="text" placeholder="53" name="bind_port" value="$bind_port"></td>
</tr>
<tr>
<th>Option</th>
<td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button></td>
</tr>
</table>
<input type="hidden" name="action" value="bind_setting">
</form>
</div>

<div class="col-md-12">
<legend>DNScrypt-proxy server</legend>
<form id="dnscrypt_proxy_server">
	<div class="radio">
EOF
AWK='
function Fix( t, Local, f, k, V) {
    while (match (t, /"[^"]*"/)) {
        k = sprintf ("\034%.2d", ++f);
        V [k] = substr (t, RSTART, RLENGTH);
        t = substr (t, 1, RSTART - 1) k substr (t, RSTART + RLENGTH);
    }
    for (k in V) gsub (/,/, "\_", V [k]);
    for (k in V) sub (k, V [k], t);
    return (t);
}
{ print Fix( $0); }
'
dns_resolvers_str=`awk "${AWK}" /usr/local/dnscrypt-proxy/share/dnscrypt-proxy/dnscrypt-resolvers.csv`
IFS_bak=$IFS
IFS=','
echo "$dns_resolvers_str" | grep -v "^Name" | while read Name Full_name Description Location Coordinates URL Version DNSSEC_validation No_logs Namecoin Resolver_address Provider_name Provider_public_key Provider_public_key_TXT_record
do
cat <<EOF
		<div class="row">
			<div class="col-md-3">
			<label>
			<input type="radio" id="$Name" name="server" value="$Name" `[ "$resolv_name" = "$Name" ] && echo "checked"`>
			Name:<font color="#4335DA">$Name</font><p>
			Location:<font color="#AA8119">`echo $Location | sed 's/_/,/g'`</font>
			</label>
			</div>
			<div class="col-md-3">
			Full name:$Full_name<p>
			Description:$Description<p>
			</div>
			<div class="col-md-3">
			URL:$URL<p>
			Version:<font color="red">$Version</font><p>
			DNSSEC validation:$DNSSEC_validation<p>
			No logs:$No_logs<p>
			Namecoin:$Namecoin<p>		
			</div>
			<div class="col-md-3">
			Resolver address:<font color="#C1128C">$Resolver_address</font><p>
			Provider name:$Provider_name<p>
			Provider public key:$Provider_public_key<p>
			</div>
		</div>
EOF
done
IFS="$IFS_bak"
cat <<EOF
	</div>
<input type="hidden" name="action" value="dnscrypt_proxy_server">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
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
        <h4 class="modal-title">$_PS_Install_DNScrypt_proxy</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_dnscrypt_proxy" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_DNScrypt_proxy_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=dnscrypt-proxy&action=pre_install_dnscrypt_proxy';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_dnscrypt_proxy()
{
var url = 'index.cgi?app=dnscrypt-proxy&action=install_dnscrypt_proxy';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_dnscrypt_proxy').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_dnscrypt_proxy()", 5000);

});
</script>
EOF
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf` >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh >/dev/null 2>&1
. $DOCUMENT_ROOT/apps/dnscrypt-proxy/dnscrypt_proxy_lib.sh >/dev/null 2>&1
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi