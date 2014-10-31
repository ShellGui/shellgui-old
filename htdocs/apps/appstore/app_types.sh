#!/bin/sh

app_types()
{
if
[ -z "$FORM_app_type" ]
then
main.sbin header_jump "index.cgi?app=appstore"
exit 1
fi

_LANG_App_name="$_LANG_App_name"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

#----------------------------

if
[ ! -f $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs ]
then
warning
else
file_date=`ls -l --time-style="+%s" $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs | awk {'print $(NF - 1)'}`
[ `expr $(date +%s) - $file_date` -gt 86400 ] && warning
fi

cat <<EOF
<div class="controls">
<label class="control-label">$_LANG_Operating_System:</label>
$OS
<label class="control-label">$_LANG_Hardware_platform:</label>
`echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]'`
</div>


	<div class="row" id="applist">
		<ul class="nav nav-tabs">
		  <li><a href="index.cgi?app=appstore">$_LANG_All</a></li>
EOF

pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
downloads_rank_str=`cat $DOCUMENT_ROOT/../tmp/downloads_rank.json`

for i in `echo "$pkgs_str" | jq '.["apps"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<li `[ "$FORM_app_type" = "${i}" ] && echo "class=\"active\""`><a href="index.cgi?app=appstore&action=app_types&app_type=${i}">`echo "$pkgs_str" | jq -r '.["apps"]["'"${i}"'"][]["i18n"]["'"$lang"'"]["type"]' | sed '/^null$/d' | sed -n 1p`</a></li>
EOF
done

cat <<EOF
			<li class="pull-right">
				<a onclick="show_appstore_action('all','clean')" class="bg-danger">$_LANG_Clean_update_cache</a>
			</li>
		</ul>
	
<div class="col-md-12">
EOF

for store_app in `echo "$pkgs_str" | jq '.["apps"]["'"$FORM_app_type"'"] | keys' | grep -Po '[\w].*[\w]'`
do
new_version=`echo "$pkgs_str" | jq -r '.["apps"]["'"$FORM_app_type"'"]["'"${store_app}"'"]["version"]' | sed '/^null$/d'`
cat <<EOF
		<div class="col-md-4" title="${store_app}">
			<div class="media">
				<a onclick="show_appstore_action_silent('${store_app}','info')" class="pull-left datainfo" dataid="${store_app}">
	                <img class="media-object img-rounded" src="`echo "$pkgs_str" | jq -r '.["info"]["url_prefix"]'`/apps/${store_app}/icon.png" width="75" height="75">
	            </a>
				<div class="media-body">
				<h4 class="media-heading"><a onclick="show_appstore_action_silent('${store_app}','info')" class="name datainfo" dataid="${store_app}">`echo "$pkgs_str" | jq -r '.["apps"]["'"$FORM_app_type"'"]["'"${store_app}"'"]["i18n"]["'"$lang"'"]["name"]' | sed '/^null$/d'`</a>v$new_version</h4>
				<span class="install-count">`echo "$downloads_rank_str" | jq -r '.["downloads_rank"]["'"${store_app}"'"]'` installs</span>
                <span>·</span>
                <span title="size">`echo "$pkgs_str" | jq -r '.["apps"]["'"$FORM_app_type"'"]["'"${store_app}"'"]["size"]' | sed '/^null$/d'`</span>
EOF
now_version=""
now_uninstall=""
eval `head $DOCUMENT_ROOT/apps/${store_app}/config.conf | grep -E "^version=|^uninstall=" | sed 's/^/now_/g'`

if
[ -d $DOCUMENT_ROOT/apps/${store_app} ] && [ `echo "$now_version < $new_version" | bc` -eq 1 ]
then
cat <<EOF
	<a onclick="show_appstore_action('${store_app}','update')" class="btn btn-info install-btn">$_LANG_Update</a>
EOF

if
[ "$now_uninstall" = "ban" ]
then
cat <<EOF
	<a class="btn btn-danger install-btn disabled">$_LANG_Uninstall</a>
EOF
else
cat <<EOF
	<a onclick="show_appstore_action('${store_app}','uninstall')" class="btn btn-danger install-btn">$_LANG_Uninstall</a>
EOF
fi

elif
[ ! -d $DOCUMENT_ROOT/apps/${store_app} ] 
then
cat <<EOF
				<a onclick="show_appstore_action('${store_app}','install')" class="btn btn-success install-btn">$_LANG_Install</a>
EOF
else
	if
	[ "$now_uninstall" = "ban" ]
	then
cat <<EOF
	<a class="btn btn-danger install-btn disabled">$_LANG_Uninstall</a>
EOF
else
cat <<EOF
	<a onclick="show_appstore_action('${store_app}','uninstall')" class="btn btn-danger install-btn">$_LANG_Uninstall</a>
EOF
	fi
fi
desc=`echo "$pkgs_str" | jq -r '.["apps"]["'"$FORM_app_type"'"]["'"${store_app}"'"]["i18n"]["'"$lang"'"]["desc"]' | sed '/^null$/d'`
[ `expr length "$desc"` -gt 34 ] && desc="`echo "$desc" | cut -c 1-34`..."
cat <<EOF
				
				</div>
			</div>
			<p class="brief"><a onclick="show_appstore_action_silent('${store_app}','info')" class="datainfo" dataid="${store_app}">$desc</a></p>
		</div>
EOF
done

cat <<'EOF'
<script type="text/javascript">
function show_appstore_action(appname, appaction)
{

EOF
cat <<EOF
if (confirm("$_LANG_do_you_want_to " + appaction + " " + appname)) {
EOF
cat <<'EOF'
	var url = 'index.cgi?app=appstore&action=do_' + appaction + '&dealapp=' + appname;
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
	$('#tittle').html(appaction);
	$('#app_content').html(data);
	$('#app_Modal').modal('show');
	}, 1);
  }
}
function show_appstore_action_silent(appname, appaction)
{
	var url = 'index.cgi?app=appstore&action=do_' + appaction + '&dealapp=' + appname;
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
	$('#tittle').html(appaction);
	$('#app_content').html(data);
	$('#app_Modal').modal('show');
	}, 1);
}
</script>
EOF
cat <<EOF
</div>

<div class="container">
<div class="modal fade" id="app_Modal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="tittle">$_LANG_App_management</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<pre id="app_content"></pre>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
</div>


	</div>

	<br>
	<br>

EOF

#----------------------------

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"
}