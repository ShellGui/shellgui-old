#!/bin/sh

main()
{
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
all_devs=`grep [0-9] /proc/net/dev | sed -e 's/:.*//' -e 's/[ ]*//'`
cat <<EOF
<script>
\$(function(){
  \$('#add_zone_wan_new').on('submit', function(e){
    e.preventDefault();
    var data = "app=netzone&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
\$(function(){
  \$('#add_zone_lan_new').on('submit', function(e){
    e.preventDefault();
    var data = "app=netzone&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
function del_netzone(zonename)
{
  if (confirm("$_LANG_Do_you_want_to_del " + zonename)) {
    var data = "app=netzone&action=del_netzone&zonename="+zonename;
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
</script>
EOF
cat <<EOF
<div class="raw">
<legend>$_LANG_nat_from</legend>
EOF
for lan_zone in `echo "$base_firewall_str" | jq '.["forwarding"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<script>
\$(function(){
  \$('#lan_2_wan_${lan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=netzone&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
	<form class="form-inline" role="form" id="lan_2_wan_${lan_zone}">
		<div class="form-group">
		<label class="col-sm-2 control-label">${lan_zone}</label>
		</div>
		<div class="form-group">
EOF
for dest in `echo "$netzone_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
wan_used=`echo "$base_firewall_str" | jq '.["forwarding"]["'${lan_zone}'"]["dest"]' | grep -Po '[\w].*[\w]'`
cat <<EOF
		<label class="checkbox-inline">
		<input type="checkbox" name="wan_zone_${dest}" value="${dest}" `echo "$wan_used" | grep -qE "[ ]*${dest}[ ]*" && echo checked`>${dest}</label>
EOF
done
cat <<EOF	
		</div>
		<input type="hidden" name="action" value="lan_2_wan_${lan_zone}">
		<input type="hidden" name="lan_zone" value="${lan_zone}">
		<button type="submit" class="btn btn-primary">$_LANG_Save</button>
	</form>
EOF
done
cat <<EOF


</div>
<div class="raw">
<div class="col-md-6">
	<legend>$_LANG_Wan_type_Zones</legend>
EOF
for wan_zone in `echo "$netzone_str" | jq -r '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<script>
\$(function(){
  \$('#do_save_zone_${wan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=netzone&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF
cat <<EOF
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">${wan_zone}</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="do_save_zone_${wan_zone}">
					<table class="table">
						<tr>
							<td>
								<label>dev</label>
								<input class="form-control" name="dev" placeholder="eth0" list="wans" value="`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`"/>
								<datalist id="wans">
EOF
for dev in $all_devs
do
cat <<EOF
								  <option value="${dev}">
EOF
done
cat <<EOF
								</datalist>
							</td>
							<td>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="forward" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" = "ACCEPT" ] && echo checked`>forward
											</label>
										</div>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="input" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] && echo checked`>input
											</label>
										</div>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="output" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["output"]')" = "ACCEPT" ] && echo checked`>output
											</label>
										</div>
							</td>
						</tr>
						<tr>
							<td>
									$_LANG_Status
										<select name="enable">
										  <option value="1" `[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ] && echo 'selected="selected"'`>$_LANG_Active</option>
										  <option value="0" `[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -ne 1 ] && echo 'selected="selected"'`>$_LANG_Inactive</option>
										</select>
							</td>
							<td>
										<input type="hidden" name="action" value="do_save_zone_${wan_zone}">
										<input type="hidden" name="zone" value="wan_zone">
										<input type="hidden" name="zonename" value="${wan_zone}">
										<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
EOF

[ "${wan_zone}" != "wan" ] && cat <<EOF
										<button class="btn btn-danger" type="button" onclick="del_netzone('${wan_zone}');">$_LANG_Del</button>
EOF
cat <<EOF
							</td>
						</tr>
					</table>
				</form>
			</div>
		  </div>
		</div>
EOF
done

cat <<EOF
	<form id="add_zone_wan_new">
		<div class="panel panel-success">
		  <div class="panel-heading">
			<div class="input-group">
			<div class="input-group-addon">wan_</div>
			<input type="text" name="zonename" class="form-control" placeholder="isp">
			</div>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
					<table class="table">
						<tr>
							<td>
								<label>dev</label>
								<input name="dev" class="form-control" placeholder="eth0" list="newwan" />
								<datalist id="newwan">
EOF
for dev in $all_devs
do
cat <<EOF
								  <option value="${dev}">
EOF
done
cat <<EOF
								</datalist>
							</td>
							<td>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="forward" value="ACCEPT" checked>forward
											</label>
										</div>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="input" value="ACCEPT" checked>input
											</label>
										</div>
										<div class="checkbox">
											<label class="checkbox-inline">
											<input type="checkbox" name="output" value="ACCEPT" checked>output
											</label>
										</div>
							</td>
						</tr>
						<tr>
							<td>
									$_LANG_Status
										<select name="enable">
										  <option value="0">$_LANG_Inactive</option>
										  <option value="1">$_LANG_Active</option>
										</select>
							</td>
							<td>
										<input type="hidden" name="action" value="add_zone_wan_new">
										<input type="hidden" name="zone" value="wan_zone">
										<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button>
							</td>
						</tr>
					</table>
			</div>
		  </div>
		</div>
	</form>
</div>
<div class="col-md-6">
	<legend>$_LANG_Lan_type_Zones</legend>
EOF


for lan_zone in `echo "$netzone_str" | jq -r '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<script>
\$(function(){
  \$('#do_save_zone_${lan_zone}').on('submit', function(e){
    e.preventDefault();
    var data = "app=netzone&"+\$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-service');
      //  setTimeout("window.location.reload();", 3000);
  });
});
</script>
EOF
cat <<EOF
		<div class="panel panel-primary">
		  <div class="panel-heading">
			<h3 class="panel-title">${lan_zone}</h3>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
				<form id="do_save_zone_${lan_zone}">
					<table class="table">
					<tbody><tr>
					<td>
						<label>IP</label>
						<input type="text" class="form-control" name="ip" placeholder="192.168.1.1" value="`echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["ip"]'`">
						<label>NetMask</label>
						<input type="text" class="form-control" name="netmask" placeholder="255.255.255.0" value="`echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["netmask"]'`">
						<label>dev</label>
						<input type="text" class="form-control" name="dev" placeholder="eth1 eth2" value="`echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["dev"]'`">
					</td>
					<td>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="forward" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["forward"]')" = "ACCEPT" ] && echo checked`>forward
							</label>
						</div>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="input" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] && echo checked`>input
							</label>
						</div>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="output" value="ACCEPT" `[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["output"]')" = "ACCEPT" ] && echo checked`>output
							</label>
						</div>
					</td>
					</tr>
					<tr>
					<td>
					$_LANG_Status
						<select name="enable">
						  <option value="1" `[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ] && echo 'selected="selected"'`>$_LANG_Active</option>
						  <option value="0" `[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -ne 1 ] && echo 'selected="selected"'`>$_LANG_Inactive</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="do_save_zone_${lan_zone}">
						<input type="hidden" name="zone" value="lan_zone">
						<input type="hidden" name="zonename" value="${lan_zone}">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
EOF
[ "${lan_zone}" != "lan" ] && cat <<EOF
						<button class="btn btn-danger" type="button" onclick="del_netzone('${lan_zone}');">$_LANG_Del</button>
EOF
cat <<EOF
					</td>
					</tr>
					</tbody></table>
				</form>
			</div>
		  </div>
		</div>
EOF
done

cat <<EOF
	<form id="add_zone_lan_new">
		<div class="panel panel-success">
		  <div class="panel-heading">
			<div class="input-group">
			<div class="input-group-addon">lan_</div>
			<input type="text" class="form-control" name="zonename" placeholder="home">
			</div>
		  </div>
		  <div class="panel-body">
			<div id="ajax-service">
					<table class="table">
					<tbody><tr>
					<td>
						<label>IP</label>
						<input type="text" class="form-control" name="ip" placeholder="192.168.1.1">
						<label>NetMask</label>
						<input type="text" class="form-control" name="netmask" placeholder="255.255.255.0">
						<label>dev</label>
						<input type="text" class="form-control" name="dev" placeholder="eth1 eth2">
					</td>
					<td>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="forward" value="ACCEPT" checked="">forward
							</label>
						</div>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="input" value="ACCEPT" checked="">input
							</label>
						</div>
						<div class="checkbox">
							<label class="checkbox-inline">
							<input type="checkbox" name="output" value="ACCEPT" checked="">output
							</label>
						</div>
					</td>
					</tr>
					<tr>
					<td>
					$_LANG_Status
						<select name="enable">
						  <option value="0">$_LANG_Inactive</option>
						  <option value="1">$_LANG_Active</option>
						</select>
					</td>
					<td>
						<input type="hidden" name="action" value="add_zone_lan_new">
						<input type="hidden" name="zone" value="lan_zone">
						<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button>
					</td>
					</tr>
					</tbody></table>
			</div>
		  </div>
		</div>
	</form>
</div>
</div>
EOF
}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/netzone/netzone_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ] && echo "$FORM_action" | grep -q "do_save_zone_"
then
do_save_zone
elif [ -n "$FORM_action" ] && echo "$FORM_action" | grep -q "lan_2_wan_"
then
lan_2_wan
else
$FORM_action
fi