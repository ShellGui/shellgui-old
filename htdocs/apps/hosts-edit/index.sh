#!/bin/sh

main()
{
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#save').on('submit', function(e){
    e.preventDefault();
    var data = "app=hosts-edit&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF
<div class="col-md-6">
<legend>$_LANG_Current_hosts_file_contents</legend>
<form id="save">
<textarea style="width:100%;height:260px" name="hosts_str" class="bg-warning">
`cat /etc/hosts`
</textarea>
<input type="hidden" name="action" value="save">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
</div>
<div class="col-md-6">
<legend>$_LANG_Attention</legend>
<pre>
# Format:
# [ipaddress]	[hostname]
#
#########################
#	Hosts file example
#########################
127.0.0.1	localhost

192.168.1.2	home.example.com
</pre>
<p>$_LANG_Please_carefully_modified<p>
</div>
EOF
}
save()
{
# new_host=`echo "$FORM_hosts_str" | sed 's/\\015\\012/\n/g'`
if
echo "$FORM_hosts_str" | grep -q "127.0.0.1.*localhost"
then
echo "$FORM_hosts_str" > /etc/hosts

main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_hosts_file_edit" \
				detail="_NOTICE_do_hosts_file_edit" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="hosts-edit" \
				dest_type="app"  >/dev/null 2>&1


(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "$_LANG_Need 127.0.0.1 localhost" | main.sbin output_json 1) || exit 1
fi
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