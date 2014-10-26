#!/bin/sh

refresh_brand_info()
{

cat <<'EOF'
<script>
$(function(){
  $('.brand_connect').on('submit', function(e){
    e.preventDefault();
EOF
cat <<EOF
    if (confirm('$_LANG_Are_you_sure_do_this')) {
EOF
cat <<'EOF'
      var data = "app=home&"+$(this).serialize();
      var url = 'index.cgi';
      Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
    }
  });
});
</script>
EOF
old_brand_info_json=`cat $DOCUMENT_ROOT/../tmp/brand-info.json`
ifs_status=`ifconfig -s`
file_time=`ls -l --time-style="+%s" $DOCUMENT_ROOT/../tmp/brand-info.json | awk {'print $(NF-1)'}`
echo "{}" > $DOCUMENT_ROOT/../tmp/brand-info.json
# if
# [ -n "$file_time" ]
# then
now_time=`date +%s`
time_esc=`expr $now_time - $file_time`

# else

# fi
brandset_str=`cat $DOCUMENT_ROOT/apps/brand-info/brand-info.conf`
cat /proc/net/dev | sed -ne 's/ *\(.*\): *\([0-9]*\) *\([0-9]*\) *\([0-9]*\) *\([0-9]*\) *[0-9]* *[0-9]* *[0-9]* *[0-9]* *\([0-9]*\) *\([0-9]*\) *\([0-9]*\) *\([0-9]*\) *[0-9]* *[0-9]* *[0-9]* *[0-9]*/\1 \2 \6/p' | while read dev download upload
do
brand_info_json=`cat $DOCUMENT_ROOT/../tmp/brand-info.json`
str=`ifconfig ${dev}`
if
echo "$str" | grep -q "P-t-P:"
then
ip=$(echo "$str" | grep -Po '(?<=[^0-9.]|^)[1-9][0-9]{0,2}(\.([0-9]{0,3})){3}(?=[^0-9.]|$)' | sed -n 1p)"=>"$(echo "$str" | grep -Po '(?<=[^0-9.]|^)[1-9][0-9]{0,2}(\.([0-9]{0,3})){3}(?=[^0-9.]|$)' | sed -n 2p)
else
ip=`echo "$str" | grep -Po '(?<=[^0-9.]|^)[1-9][0-9]{0,2}(\.([0-9]{0,3})){3}(?=[^0-9.]|$)' | sed -n 1p`
fi
[ -n "${ip}" ] || ip="none"
if
echo "$ifs_status" | grep -q "^${dev} .*"
then
dev_status="up"
lang_dev_status="$_LANG_Dev_is_up"
color="73c075"
else
dev_status="down"
lang_dev_status="$_LANG_Dev_is_down"
color="999999"
fi
brandset=`echo "$brandset_str" | jq -r '.["'"${dev}"'"]'`
[ "$brandset" = "null" ] && brandset="100"
echo "$brand_info_json" | jq '.["ethers"]["'${dev}'"] = .["ethers"]["'${dev}'"] + {"upload":"'${upload}'","download":"'${download}'"}' > $DOCUMENT_ROOT/../tmp/brand-info.json
old_upload=`echo "$old_brand_info_json" | jq '.["ethers"]["'${dev}'"]["upload"]' | sed -e 's/^\"//g' -e 's/\"$//g'`
old_download=`echo "$old_brand_info_json" | jq '.["ethers"]["'${dev}'"]["download"]' | sed -e 's/^\"//g' -e 's/\"$//g'`
upload_speed=""
download_speed=""
upload_speed=`expr $(expr ${upload} - $old_upload) / $time_esc`
download_speed=`expr $(expr ${download} - $old_download) / $time_esc`
[ -z "$upload_speed" ] && upload_speed="0"
[ -z "$download_speed" ] && download_speed="0"
num1=$(expr $upload_speed + $download_speed)
num2=$(expr $brandset \* 131072)
brand_percent=`awk 'BEGIN{printf "%.2f\n",('$num1'/'$num2')*100}'`
# 1m=1048576 #131072
cat <<EOF

<br>
<div class="row entry projects link" style="margin:0 3px;">
  <a class="clearfix">
  <div class="col-sm-4 name">
    <div class="media-object pull-left avatar" style="background:#${color}">
      <span class="nav_icon icon-projects"></span>
    </div>

    <div class="project_title_wrapper">
      <span class="project_title">${dev}(${ip})<div class="pull-right">
EOF
if
[ "$dev_status" = "up" ]
then
cat <<EOF
	<form class="brand_connect" action="post">
		<input type="hidden" name="mkstatus" value="down">
        <input type="hidden" name="dev" value="${dev}">
        <input type="hidden" name="action" value="set_dev">
                            <button class="btn btn-danger" type="submit">if down</button>
	</form>
EOF
else
cat <<EOF
	<form class="brand_connect" action="post">
		<input type="hidden" name="mkstatus" value="up">
        <input type="hidden" name="dev" value="${dev}">
        <input type="hidden" name="action" value="set_dev">
                            <button class="btn btn-info" type="submit">if up</button>
	</form>
EOF
fi
cat <<EOF
    </div></span>
      <span class="meta">
EOF
echo $lang_dev_status
cat <<EOF
      </span>
    </div>
  </div><!--col-sm-->
  
  
    <div class="col-sm-3">
      <div class="budget budget_ok">
          <span class="bar_text">$brandset M $_LANG_Bandwidth_used: $brand_percent%</span>
          <span style="width: $brand_percent%;" class="bar"></span>
      </div>
  </div><!--col-sm-3-->
  <div class="col-sm-5">
    <div class="col-sm-6 logged">
      <span class="meta">$_LANG_Uploads</span>
    <strong>
      `main.sbin storage_size_conver ${upload_speed}`<small> /s</small>
    </strong>
    <span class="money">
        -  `main.sbin storage_size_conver ${upload}`</span>
    </div><!--col-sm-3-->
    
    
    <div class="col-sm-6 estimated">
      <span class="meta">$_LANG_Downloads</span>
    <strong>
      `main.sbin storage_size_conver ${download_speed}`<small> /s</small>
    </strong>
    <span class="money">
        -  `main.sbin storage_size_conver ${download}`</span>
    </div><!--col-sm-3-->
  </div>
</a>
</div>
EOF
done
}
set_dev()
{
ifconfig $FORM_dev $FORM_mkstatus  >/dev/null 2>&1
if
[ $? -ne 0 ]
then
(echo "ifconfig $FORM_dev $FORM_mkstatus ""$_LANG_Fail" | main.sbin output_json 1) || exit 1
else
(echo "ifconfig $FORM_dev $FORM_mkstatus ""$_LANG_Success" | main.sbin output_json 0) || exit 0
fi

}