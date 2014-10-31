#!/bin/sh

main()
{
if
[ ! -f $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs ]
then
warning
elif
[ ! -f $DOCUMENT_ROOT/../tmp/downloads_rank.json ]
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
		  <li class="active"><a href="index.cgi?app=appstore">$_LANG_All</a></li>
EOF

pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
downloads_rank_str=`cat $DOCUMENT_ROOT/../tmp/downloads_rank.json`

for i in `echo "$pkgs_str" | jq '.["apps"] | keys' | grep -Po '[\w].*[\w]'`
do
cat <<EOF
<li ><a href="index.cgi?app=appstore&action=app_types&app_type=${i}">`echo "$pkgs_str" | jq -r '.["apps"]["'"${i}"'"][]["i18n"]["'"$lang"'"]["type"]' | sed '/^null$/d' | sed -n 1p`</a></li>
EOF
done

cat <<EOF
			<li class="pull-right">
				<a onclick="show_appstore_action('all','update')" class="bg-success">$_LANG_Update_all</a>
			</li>
EOF

cat <<EOF
			<li class="pull-right">
				<a onclick="show_appstore_action('all','clean')" class="bg-danger">$_LANG_Clean_update_cache</a>
			</li>
		</ul>
	

EOF

for store_app in `echo "$pkgs_str" | jq '.["apps"][] | keys' | grep -Po '[\w].*[\w]'`
do
new_version=`echo "$pkgs_str" | jq -r '.["apps"][]["'"${store_app}"'"]["version"]' | sed '/^null$/d'`
cat <<EOF
		<div class="col-md-4" title="${store_app}">
			<div class="media">
				<a onclick="show_appstore_action_silent('${store_app}','info')" class="pull-left datainfo" dataid="${store_app}">
	                <img class="media-object img-rounded" src="`echo "$pkgs_str" | jq -r '.["info"]["url_prefix"]'`/apps/${store_app}/icon.png" width="75" height="75">
	            </a>
				<div class="media-body">
				<h4 class="media-heading"><a onclick="show_appstore_action_silent('${store_app}','info')" class="name datainfo" dataid="${store_app}">`echo "$pkgs_str" | jq -r '.["apps"][]["'"${store_app}"'"]["i18n"]["'"$lang"'"]["name"]' | sed '/^null$/d'`</a>v$new_version</h4>
				<span class="install-count">`echo "$downloads_rank_str" | jq -r '.["downloads_rank"]["'"${store_app}"'"]'` $_LANG_installs</span>
                <span>·</span>
                <span title="size">`echo "$pkgs_str" | jq -r '.["apps"][]["'"${store_app}"'"]["size"]' | sed '/^null$/d'`</span>
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
desc=`echo "$pkgs_str" | jq -r '.["apps"][]["'"${store_app}"'"]["i18n"]["'"$lang"'"]["desc"]' | sed '/^null$/d'`
[ `expr length "$desc"` -gt 34 ] && desc="`echo "$desc" | cut -c 1-34`..."
cat <<EOF
				
				</div>
			</div>
			<p class="brief"><a onclick="show_appstore_action_silent('${store_app}','info')" class="datainfo" dataid="${store_app}">$desc</a></p>
		</div>
EOF
done

cat <<'EOF'
	</div> <!--applist-->
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

	<br>
	<br>

EOF
}
pre_update_dstfile()
{
echo "$_LANG_Click_and_update_cache"
}
do_update_dstfile()
{
echo "<pre>"
rm -f $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs 2>&1
. $DOCUMENT_ROOT/apps/curl/curl_lib.sh
curl_load
curl $curl_args -L "https://github.com/ShellGui/shellgui-appstore/raw/master/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs" -o $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs 2>&1 || wget --no-check-certificate "https://github.com/ShellGui/shellgui-appstore/raw/master/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs" -O $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs 2>&1
curl $curl_args -L "https://data-turbopi.rhcloud.com/test.php?action=downloads_rank" -o $DOCUMENT_ROOT/../tmp/downloads_rank.json 2>&1 || wget --no-check-certificate "https://data-turbopi.rhcloud.com/test.php?action=downloads_rank" -O $DOCUMENT_ROOT/../tmp/downloads_rank.json 2>&1
echo "</pre>"
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
        <h4 class="modal-title">$_LANG_Update_cache</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="do_update_dstfile" data-loading-text="Loading...">$_LANG_Update</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_Update_cache<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Update</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
function downloadpkgsfile(){
	var url = 'index.cgi?app=appstore&action=do_update_dstfile';
		Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
			$('#fix_content').html(data);
			$('#fix_Modal').modal('show');
		}, 1);
};

$('#fixer').on('click', function(){
	var url = 'index.cgi?app=appstore&action=pre_update_dstfile';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

$('#do_update_dstfile').on('click', function(){
var $btn = $(this);
    $btn.button('loading');
	downloadpkgsfile();
	//setInterval("downloadpkg()", 10000);
    // setTimeout(function () {
        // $btn.button('reset');
    // }, 60000);
});
</script>
EOF
}
do_download_app()
{
pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
url_prefix=`echo "$pkgs_str" | jq -r '.["info"]["url_prefix"]'`
rm -rf $DOCUMENT_ROOT/../tmp/app_install_tmp
mkdir -p $DOCUMENT_ROOT/../tmp/app_install_tmp
for file in `echo "$pkgs_str" | jq -r '.["apps"][]["'"$FORM_dealapp"'"]["files"] | keys' | grep -Po '[\w].*[\w]'`
do
[ -d $(dirname $DOCUMENT_ROOT/../tmp/app_install_tmp/${file}) ] || mkdir -p $(dirname $DOCUMENT_ROOT/../tmp/app_install_tmp/${file})
. $DOCUMENT_ROOT/apps/curl/curl_lib.sh
curl_load
echo "Downloading $FORM_dealapp/${file}"
curl $curl_args -L $url_prefix/apps/$FORM_dealapp/${file} -o $DOCUMENT_ROOT/../tmp/app_install_tmp/${file} 2>&1 || (wget --no-check-certificate "$url_prefix/apps/$FORM_dealapp/${file}" -O $DOCUMENT_ROOT/../tmp/app_install_tmp/${file} 2>&1)
old_md5=`echo "$pkgs_str" | jq -r '.["apps"][]["'"$FORM_dealapp"'"]["files"]["'"${file}"'"]' | grep -Po '[\w].*[\w]' | sed '/^null$/d'`
new_md5=`md5sum $DOCUMENT_ROOT/../tmp/app_install_tmp/${file} | awk {'print $1'}`
echo "Compare $old_md5 $new_md5"
[ "$old_md5" = "$new_md5" ]
[ $? -ne 0 ] && echo "md5 wrong" && exit 1
done
find $DOCUMENT_ROOT/../tmp/app_install_tmp/ -type f | grep "\.sh$" | xargs chmod +x
find $DOCUMENT_ROOT/../tmp/app_install_tmp/ -type f | grep "\.fw$" | xargs chmod +x
find $DOCUMENT_ROOT/../tmp/app_install_tmp/ -type f | grep "\.init$" | xargs chmod +x
return 0
}
do_install()
{
do_download_app || (echo "Download fail" && exit 1) || exit 1
mv $DOCUMENT_ROOT/../tmp/app_install_tmp/ $DOCUMENT_ROOT/apps/$FORM_dealapp
curl $curl_args -L "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1 || wget -qO- --no-check-certificate "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1
echo "install $FORM_dealapp success"
}
do_uninstall()
{
# pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
# echo "$pkgs_str" | jq -r '.["apps"][]["'"$FORM_dealapp"'"]["files"] | keys' | grep -Po '[\w].*[\w]'
rm -rf $DOCUMENT_ROOT/apps/$FORM_dealapp
rm -f $DOCUMENT_ROOT/../tmp/home.json
main.sbin home_index
main.sbin home_index
echo "del $FORM_dealapp success"
}
do_update()
{
if
[ "$FORM_dealapp" = "all" ]
then
pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
for app in `echo "$pkgs_str" | jq '.["apps"][] | keys' | grep -Po '[\w].*[\w]'`
do
old_version=""
new_version=""
old_version=`grep "version" $DOCUMENT_ROOT/apps/${app}/config.conf | grep -Po '[0-9][0-9|\.]*'`
new_version=`echo "$pkgs_str" | jq -r '.["apps"][]["'"${app}"'"]["version"]' | sed '/^null$/d'`
	if
	[ `echo "$old_version < $new_version" | bc` -eq 1 ]
	then
	FORM_dealapp="${app}"
	echo "${app}"
	do_download_app || (echo "Download fail" && exit 1) || return 1

	for file in `find $DOCUMENT_ROOT/../tmp/app_install_tmp/ -type f`
	do
	echo ${file} | grep "\.conf$" | grep -v "^config.conf$" && mv ${file} ${file}.origin
	echo ${file} | grep "\.json$" && rm -f ${file}
	cp -R $DOCUMENT_ROOT/../tmp/app_install_tmp/* $DOCUMENT_ROOT/apps/$FORM_dealapp
	rm -rf $DOCUMENT_ROOT/../tmp/app_install_tmp/
	curl $curl_args -L "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1 || wget -qO- --no-check-certificate "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1
	done
	echo "update $FORM_dealapp success"

	fi
done
echo "update $FORM_dealapp success" && exit
fi

do_download_app || (echo "Download fail" && exit 1) || exit 1
for file in `find $DOCUMENT_ROOT/../tmp/app_install_tmp/ -type f`
do
echo ${file} | grep "\.conf$" | [ "${file}" != "config.conf" ] && mv ${file} ${file}.origin
echo ${file} | grep "\.json$" && rm -f ${file}
done
cp -R $DOCUMENT_ROOT/../tmp/app_install_tmp/* $DOCUMENT_ROOT/apps/$FORM_dealapp
rm -rf $DOCUMENT_ROOT/../tmp/app_install_tmp/
curl $curl_args -L "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1 || wget -qO- --no-check-certificate "https://data-turbopi.rhcloud.com/test.php?action=installapp&app=$FORM_dealapp" >/dev/null 2>&1
echo "update $FORM_dealapp success"
}
do_info()
{
pkgs_str=`cat $DOCUMENT_ROOT/../tmp/$distribution-$(echo "$sysinfo_data" | jq -r '.["sysinfo"]["hw_model"]').pkgs`
echo "$pkgs_str" | jq -r '.["apps"][]["'"$FORM_dealapp"'"]["i18n"]["'"$lang"'"]["desc"]' | sed '/^null$/d'

}
do_clean()
{
if
[ "$FORM_dealapp" = "all" ]
then
rm -f $DOCUMENT_ROOT/../tmp/*.pkgs
echo "$_LANG_Already_update_cache"
fi
}

. $DOCUMENT_ROOT/apps/home/distributions_lib.sh
sysinfo_data=`cat $DOCUMENT_ROOT/../tmp/sysinfo.json`
if
[ -z "$sysinfo_data" ]
then
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh
sysinfo_gen
sysinfo_data=`cat $DOCUMENT_ROOT/../tmp/sysinfo.json`
fi

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/appstore/app_types.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi