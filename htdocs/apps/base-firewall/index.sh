#!/bin/sh

main()
{
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`

cat <<EOF
<div class="row">
EOF

for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<script>
\$(function(){
  \$('#zone_rule_${wan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=base-firewall&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
	<div class="col-md-6">
	<form id="zone_rule_${wan_zone}">
	<table class="table">
		<tr><th colspan="2" class="bg-primary"><span class="glyphicon glyphicon-globe"></span>${wan_zone}</th></tr>
		<tr><td>$_LANG_Enable_SYN_flood_defense</td><td><input type="checkbox" name="syn_flood" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["syn_flood"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Drop_Invalid_package</td><td><input type="checkbox" name="invalid_pkg" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["invalid_pkg"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_ping</td><td><input type="checkbox" name="allow_ping" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["allow_ping"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_DHCP_Port_68</td><td><input type="checkbox" name="accept_dhcp_68" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["accept_dhcp_68"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_Other_Port</td><td><textarea style="width:100%;height:140px" name="allow_ports" placeholder="80 22 8080 65530:65535" class="bg-warning">`allow_ports="$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["allow_ports"]')" ; [ -n "$allow_ports" ] && [ "$allow_ports" != "null" ] && echo "$allow_ports"`</textarea></td></tr>
		<tr><td>$_LANG_Option</td><td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button></td></tr>
	</table>
	<input type="hidden" name="action" value="zone_rule_${wan_zone}">
	<input type="hidden" name="zone_name" value="${wan_zone}">
	<input type="hidden" name="zone" value="wan_zone">
	</form>
	</div>
EOF
done
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<script>
\$(function(){
  \$('#zone_rule_${lan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=base-firewall&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
	<div class="col-md-6">
	<form id="zone_rule_${lan_zone}">
	<table class="table">
		<tr><th colspan="2" class="bg-success"><span class="glyphicon glyphicon-globe"></span>${lan_zone}</th></tr>
		<tr><td>$_LANG_Enable_SYN_flood_defense</td><td><input type="checkbox" name="syn_flood" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["syn_flood"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Drop_Invalid_package</td><td><input type="checkbox" name="invalid_pkg" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["invalid_pkg"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_ping</td><td><input type="checkbox" name="allow_ping" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["allow_ping"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_DHCP_Port_68</td><td><input type="checkbox" name="accept_dhcp_68" value="1" `[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["accept_dhcp_68"]') -eq 1 ] && echo checked`></td></tr>
		<tr><td>$_LANG_Allow_Other_Port</td><td><textarea style="width:100%;height:140px" name="allow_ports" placeholder="80 22 8080 65530:65535" class="bg-warning">`allow_ports="$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["allow_ports"]')" ; [ -n "$allow_ports" ] && [ "$allow_ports" != "null" ] && echo "$allow_ports"`</textarea></td></tr>
		<tr><td>$_LANG_Option</td><td><button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button></td></tr>
	</table>
	<input type="hidden" name="action" value="zone_rule_${lan_zone}">
	<input type="hidden" name="zone_name" value="${lan_zone}">
	<input type="hidden" name="zone" value="lan_zone">
	</form>
	</div>

EOF
done
cat <<EOF
</div>

EOF
}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ] && echo "$FORM_action" | grep -q "zone_rule_"
then
zone_rule
else
$FORM_action
fi