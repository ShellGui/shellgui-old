#!/bin/sh

main()
{

which nslookup > /dev/null 2>&1 || warning
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#ping').on('click', function(e){
	var $btn = $(this);
    $btn.button('loading');
  var host=document.getElementById("ping_host").value;
  var times=document.getElementById("ping_times").value;
  var url = 'index.cgi?app=net-diagnostics&action=ping&host='+host+'&times='+times;
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#ping_content').html(data);
	$btn.button('reset');
  }, 1);
  });
});
$(function(){
  $('#traceroute').on('click', function(e){
	var $btn = $(this);
    $btn.button('loading');
  var host=document.getElementById("traceroute_host").value;
  var url = 'index.cgi?app=net-diagnostics&action=traceroute&host='+host;
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#traceroute_content').html(data);
	$btn.button('reset');
  }, 1);
  });
});
$(function(){
  $('#nslookup').on('click', function(e){
	var $btn = $(this);
    $btn.button('loading');
  var host=document.getElementById("nslookup_host").value;
  var url = 'index.cgi?app=net-diagnostics&action=nslookup&host='+host;
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#nslookup_content').html(data);
	$btn.button('reset');
  }, 1);
  });
});
</script>
EOF

cat <<EOF
<div class="col-md-6">
<legend>ping test</legend>
<div class="col-md-6">
<input type="text" id="ping_host" class="form-control" name="ping_host" placeholder="IP/Domain" value="www.shellgui.com">
</div>
<div class="col-md-3">
<input type="text" id="ping_times" class="form-control" name="ping_times" placeholder="Times" value="1">
</div>
<div class="col-md-3">
<button id="ping" type="button" class="btn btn-primary">Go</button>
</div>
<div class="col-md-12">
<pre id="ping_content">
Result /* $_LANG_May_need_to_wait_a_very_long_time */
</pre>
</div>
</div>


<div class="col-md-6">
<legend>traceroute</legend>
<div class="col-md-6">
<input type="text" id="traceroute_host" class="form-control" name="traceroute_host" placeholder="IP/Domain" value="www.shellgui.com">
</div>
<div class="col-md-3">
<button id="traceroute" type="button" class="btn btn-primary">Go</button>
</div>
<div class="col-md-12">
<pre id="traceroute_content">
Result /* $_LANG_May_need_to_wait_a_very_long_time */
</pre>
</div>
</div>

<div class="col-md-6">
<legend>nslookup</legend>
<div class="col-md-6">
<input type="text" id="nslookup_host" class="form-control" name="nslookup_host" placeholder="Domain" value="www.shellgui.com">
</div>
<div class="col-md-3">
<button id="nslookup" type="button" class="btn btn-primary">Go</button>
</div>
<div class="col-md-12">
<pre id="nslookup_content">
Result /* $_LANG_May_need_to_wait_a_very_long_time */
</pre>
</div>
</div>

EOF

}
ping()
{
if
[ -z "$FORM_host" ]
then
echo "$_LANG_Domain_name_or_ip_can_not_be_empty"
exit 1
fi
if
echo "$FORM_host" | main.sbin regx_str isdomain || echo "$FORM_host" | main.sbin regx_str isip_ipv4
then
echo "$_LANG_Domain_name_or_ip_effective"
else
echo "$_LANG_Please_fill_in_the_correct_domain_name_or_ip"
exit 1
fi
if
echo "$FORM_times" | main.sbin regx_str islang_alb && [ $FORM_times -le 10 ]
then
echo "$_LANG_Counts_effective"
else
echo "$_LANG_Please_enter_the_number_is_less_than_or_equal_to_10"
exit 1
fi
echo "ping..."
# result=`$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh ping $FORM_times $FORM_host`
# echo "$result"
$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh ping $FORM_times $FORM_host
}
traceroute()
{
if
[ -z "$FORM_host" ]
then
echo "$_LANG_Domain_name_or_ip_can_not_be_empty"
exit 1
fi
if
echo "$FORM_host" | main.sbin regx_str isdomain || echo "$FORM_host" | main.sbin regx_str isip_ipv4
then
echo "$_LANG_Domain_name_or_ip_effective"
else
echo "$_LANG_Please_fill_in_the_correct_domain_name_or_ip"
exit 1
fi
# result=`$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh traceroute $FORM_host`
# echo "$result"
$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh nslookup $FORM_host
}
nslookup()
{
if
[ -z "$FORM_host" ]
then
echo "$_LANG_Domain_name_or_ip_can_not_be_empty"
exit 1
fi
if
echo "$FORM_host" | main.sbin regx_str isdomain
then
echo "$_LANG_Domain_name_effective"
else
echo "$_LANG_Please_fill_in_the_correct_domain_name"
exit 1
fi
# result=`$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh traceroute $FORM_host`
# echo "$result"
$DOCUMENT_ROOT/apps/$FORM_app/net_diag.sh nslookup $FORM_host
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
        <h4 class="modal-title">缺少依赖nslookup</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">关闭</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="do_install_nslookup" data-loading-text="Loading...">安装</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">同步时间需要安装nslookup<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=net-diagnostics&action=pre_install_nslookup';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});
$('#do_install_nslookup').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

var url = 'index.cgi?app=net-diagnostics&action=do_install_nslookup';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);

  //  setTimeout(function () {
   //     $btn.button('reset');
   // }, 5000);

});
</script>
EOF
}
pre_install_nslookup()
{
echo "如果安装失败，请手动安装"
}
do_install_nslookup()
{
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
echo "<pre>"
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y bind-utils 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y dnsutils 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y dnsutils 2>&1) || exit 1
fi
echo "</pre>"
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
