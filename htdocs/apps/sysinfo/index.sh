#!/bin/sh
main()
{
# which ntpdate > /dev/null 2>&1 || warning
sysinfo_data=`cat $DOCUMENT_ROOT/../tmp/sysinfo.json`
if
[ -z "$sysinfo_data" ]
then
sysinfo_gen
sysinfo_data=`cat $DOCUMENT_ROOT/../tmp/sysinfo.json`
fi
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#hostsetting').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysinfo&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#timesetting').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysinfo&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF
<div class="col-md-6">
<legend>$_LANG_System_info</legend>
<table class="table">
<tr>
<td>
$_LANG_Host_name
</td>
<td>
<form id="hostsetting" class="form-inline mb0">
	<input type="text" class="form-control" placeholder="请输入主机名" value="`hostname`" name="hostname">
	<input type="hidden" name="action" value="hostsetting">
	<button class="btn btn-primary" type="submit">$_LANG_Save</button>
</form>
</td>
</tr>
<tr>
<td>
Time
</td>
<td>
<p class="bg-success">`date`</p>
</td>
</tr>

<tr>
<td>
$_LANG_Operating_System
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["OS"]'`
</td>
</tr>

<tr>
<td>
$_LANG_Kernel_version
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["kernel_ver"]'`
</td>
</tr>

<tr>
<td>
$_LANG_Hardware_architecture
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]'`
</td>
</tr>

</table>

<legend>$_LANG_Processor_Information</legend>
<table class="table">
<tr>
<td>
$_LANG_Processor_Model
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["cpu_model"]'`
</td>
</tr>
<tr>
<td>
$_LANG_CPUS
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["cores"]'`
</td>
</tr>
<tr>
<td>
$_LANG_Processor_clocked
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["cpu_Ghz"]'`
</td>
</tr>
<tr>
<td>
$_LANG_Processor_cache
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["cpu_cache"]'`
</td>
</tr>
<tr>
<td>
$_LANG_Support_64
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["is_64"]'`
</td>
</tr>
<tr>
<td>
$_LANG_Support_ht
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["cpu"]["is_ht"]'`
</td>
</tr>
</table>

</div>

<div class="col-md-6">

<legend>$_LANG_MEM_Info</legend>
<table class="table">
<tr>
<td>
$_LANG_Total_MEM
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["mem"]["total_mem"]'`
</td>
</tr>
<tr>
<td>
$_LANG_Total_Swap
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["mem"]["total_swap"]'`
</td>
</tr>
</table>

<legend>$_LANG_Disk_Device</legend>
<table class="table">
<tr>
<td>
$_LANG_Space
</td>
<td>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["disk_info"]'`
</td>
</tr>
</table>

<legend>$_LANG_Time_setting</legend>
<form id="timesetting">
<table class="table">
<tr>
<td>
$_LANG_Time_Zone
</td>
<td>
<select name="zonename" class="form-control">
EOF
tz_now=`echo "$sysinfo_data" | jq -r '.["sysinfo"]["tz_now"]'`
for tz in $(for i in `find /usr/share/zoneinfo/ -type d -maxdepth 1 | grep -v "/$"`; do find ${i} \( -type f -o -type l \); done | grep -vE "right|Etc|posix" | sed 's#/usr/share/zoneinfo/##g' | sort -n)
do
echo "<option value=\"${tz}\" "`[ "$tz_now" = "${tz}" ] && echo selected`">${tz}</option>"
done
cat <<EOF                                       
</select>
</td>
</tr>
<tr>
<td>
$_LANG_Time_Update_Server
</td>
<td>
EOF
timeserver_str=`cat $DOCUMENT_ROOT/apps/sysinfo/sysinfo.conf | grep "^server[0-9]*="`
for server in `echo "$timeserver_str" | sed 's/=.*//g'`
do
echo "<input type=\"text\" name=\"${server}\" placeholder=\"Enter NTP TimeServer\" value=\"`echo "$timeserver_str" | grep "${server}=" | awk -F "=" {'print $2'}`\" class=\"form-control\">"
done
cat <<EOF
</td>
</tr>
<tr>
<td>
$_LANG_Local_NTP_Server
</td>
<td>
<select name="enable_server" class="form-control">
	<option value="0" selected="">off</option>
	<option value="1">on</option>
</select>
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
	<input type="hidden" name="action" value="timesetting">
	<button class="btn btn-primary" type="submit">$_LANG_Save</button>
</td>
</tr>
</table>
</form>
</div>
EOF
}
hostsetting()
{
([ -n "$FORM_hostname" ] && echo "$FORM_hostname" | main.sbin regx_str islang_enalb || echo "$_LANG_Submit_error" | main.sbin output_json 1) || exit 1
old_hostname=`hostname`
hostname $FORM_hostname
[ -f /etc/sysconfig/network ] && sed -i "s/^HOSTNAME=.*/HOSTNAME=$FORM_hostname/g" /etc/sysconfig/network
host_str=`cat /etc/hosts | grep -v "127.0.0.1.*$old_hostname"`
echo "$host_str" > /etc/hosts
echo "127.0.0.1 $FORM_hostname" >> /etc/hosts
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_hostname_modified" \
				detail="_NOTICE_hostname_modified" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="ssl-gen" \
				dest_type="app" \
					variable="{\
						\"old_hostname\":\"$old_hostname\", \
						\"new_hostname\":\"$FORM_hostname\" \
					}" >/dev/null 2>&1
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 1
}
timesetting()
{
post_servers=`env | grep "FORM_server" | sed 's/FORM_//g'`
rm /etc/localtime
ln -s /usr/share/zoneinfo/$FORM_zonename /etc/localtime
# ntpdate 1.openwrt.pool.ntp.org >/dev/null 2>&1

(for server in `echo "$post_servers" | sed 's/^.*=//g'`
do
echo "${server}" | main.sbin regx_str isdomain || exit 1
done)
if
[ $? -ne 0 ]
then
(echo "$_LANG_Domain_format_error" | main.sbin output_json 1) || exit 1
fi
old_servers=`cat $DOCUMENT_ROOT/apps/sysinfo/sysinfo.conf  | grep "^server[0-9]*" | sed 's/.*=//g' | tr '\n' ';'`
sysinfo_data=`cat $DOCUMENT_ROOT/../tmp/sysinfo.json`
old_timezone=`echo "$sysinfo_data" | jq -r '.["sysinfo"]["tz_now"]'`
echo "$post_servers" > $DOCUMENT_ROOT/apps/sysinfo/sysinfo.conf
echo "$FORM_enable_server" >> $DOCUMENT_ROOT/apps/sysinfo/sysinfo.conf
new_servers=`cat $DOCUMENT_ROOT/apps/sysinfo/sysinfo.conf  | grep "^server[0-9]*" | sed 's/.*=//g' | tr '\n' ';'`
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_timesetting_modified" \
				detail="_NOTICE_timesetting_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="ssl-gen" \
				dest_type="app" \
					variable="{\
						\"old_timezone\":\"$old_timezone\", \
						\"new_timezone\":\"$FORM_zonename\", \
						\"old_servers\":\"$old_servers\", \
						\"new_servers\":\"$new_servers\" \
					}" >/dev/null 2>&1
sysinfo_gen >/dev/null 2>&1
main.sbin notice option="unmark_uniq" uniqid="timezone_not_seted" >/dev/null 2>&1
$DOCUMENT_ROOT/apps/sysinfo/S100sysinfo.init >/dev/null 2>&1
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
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
        <h4 class="modal-title">$_LANG_Missing_Dependency ntpdate</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="do_install_ntpdate" data-loading-text="Loading...">$_LANG_Install</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Time_synchronization_need_to_install_ntpdate<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=sysinfo&action=pre_install_ntpdate';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});
$('#do_install_ntpdate').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

var url = 'index.cgi?app=sysinfo&action=do_install_ntpdate';
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

pre_install_ntpdate()
{
echo "$_LANG_If_the_installation_fails__Please_do_manually_install"
}
do_install_ntpdate()
{
echo "<pre>"
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y ntpdate 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y ntpdate 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y ntpdate 2>&1) || exit 1
fi
echo "</pre>"
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