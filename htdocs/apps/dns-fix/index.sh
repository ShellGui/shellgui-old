#!/bin/sh

main()
{
eval `grep -E "^enable=|^update_cycle=|^update_url=" $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init`

cat <<EOF
<script>
\$(function(){
  \$('#base_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=dns-fix&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'base_setting');
	//	setTimeout("window.location.reload();", 3000);
  });
});
</script>
<div class="col-md-6">
<form id="base_setting">
	<legend>Base Setting<legend>
	<table class="table">
	<tr>
	<th>
	Enable
	</th>
	<td>
	<input type="checkbox" name="enable" value="1" `[ $enable -eq 1 ] && echo checked`>
	</td>
	</tr>
	<tr>
	<th>
	Update cycle
	</th>
	<td>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="update_cycle">Hidden label</label>
  <input type="text" class="form-control" id="update_cycle" name="update_cycle" value="$update_cycle">
  <span class="glyphicon form-control-feedback">Day</span>
</div>
	</td>
	</tr>
	<tr>
	<th>
	Update URL
	</th>
	<td>
	<input type="text" class="form-control" name="update_url" placeholder="URL input" value="$update_url">
	</td>
	</tr>
	<tr>
	<th>
	Option
	</th>
	<td>
	<input type="hidden" name="action" value="base_setting">
	<button class="btn btn-primary" id="_submit" type="submit">保存</button>
	</td>
	</tr>
	</table>
</form>
</div>
<div class="col-md-6">
Update domain list.
</div>
EOF
}
base_setting()
{
sed -i "s/^enable=.*/enable=\"$FORM_enable\"/g" $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init
sed -i "s/^update_cycle=.*/update_cycle=\"$FORM_update_cycle\"/g" $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init
sed -i "s#^update_url=.*#update_url=\"$FORM_update_url\"#g" $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init

cat <<EOF > $DOCUMENT_ROOT/apps/dns-fix/root.cron
0 0 $FORM_update_cycle * * eval \`$DOCUMENT_ROOT/../bin/main.sbin shellgui_env\` && $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init update && $DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init analyse && $DOCUMENT_ROOT/apps/dnsmasq/S390dnsmasq.init
EOF
$DOCUMENT_ROOT/apps/scheduled/S300scheduled.init >/dev/null 2>&1
$DOCUMENT_ROOT/apps/dns-fix/S501dns-fix.init >/dev/null 2>&1
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

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi