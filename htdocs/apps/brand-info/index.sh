#!/bin/sh

brand_info_save()
{
# FORM_if_970c5_name=br-lan
# FORM_if_a6bbe_name=eth1
# FORM_if_c1e3d_value=1000
# FORM_app=brand-info
# FORM_if_3a953_value=6
# FORM_if_970c5_value=100
# FORM_if_c1e3d_name=lo
# FORM_action=brand_info_save
# FORM_if_3a953_name=eth0
# FORM_if_a6bbe_value=100
brandset_str=`cat $DOCUMENT_ROOT/apps/brand-info/brand-info.conf`
for radom_str in `env | grep "^FORM_if_.*_name=" | sed 's/_name.*//'`
do
value=$(eval echo '$'"${radom_str}"_value)
name=$(eval echo '$'"${radom_str}"_name)

echo "${value}" | main.sbin regx_str islang_alb || (echo "$_LANG_Save $_LANG_Fail" | main.sbin output_json 1) || exit 1
brandset_str=`echo "$brandset_str" | jq '.["'"$name"'"] = '"$value"''`
done
if
echo "$brandset_str" | jq '.' | grep -q "{"
then
echo "$brandset_str" > $DOCUMENT_ROOT/apps/brand-info/brand-info.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_brand_info_save" \
				detail="_NOTICE_brand_info_save" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="brand-info" \
				dest_type="app"  >/dev/null 2>&1
(echo "$_LANG_Save $_LANG_Success" | main.sbin output_json 0) || exit 0
else

(echo "$_LANG_Save $_LANG_Fail" | main.sbin output_json 1) || exit 1
fi
# Result_str=`env | grep "^FORM_if_.*=" | sed 's/^FORM_if_/brandset_/g'`
# for i in `echo "$Result_str" | awk -F "=" {'print $2'}`
# do
# echo "${i}" | main.sbin regx_str islang_alb
# if
# [ $? -ne 0 ]
# then
# (echo "$_LANG_Save $_LANG_Fail" | main.sbin output_json 1) || exit 1
# fi
# done
# if
# [ $? -eq 0 ]
# then
# main.sbin notice option="add" \
				# read="0" \
				# desc="_NOTICE_brand_info_save" \
				# detail="_NOTICE_brand_info_save" \
				# uniqid="" \
				# time="" \
				# ergen="yellow" \
				# dest="brand-info" \
				# dest_type="app"  >/dev/null 2>&1
# echo "$Result_str" > $DOCUMENT_ROOT/apps/brand-info/brand-info.conf
# (echo "$_LANG_Save $_LANG_Success" | main.sbin output_json 0) || exit 0
# fi
}
main()
{
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#brand_info_save').on('submit', function(e){
    e.preventDefault();
    var data = "app=brand-info&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF

devs=`grep -Po '[\w].*[:]' /proc/net/dev | tr -d ':'`
# eval `cat $DOCUMENT_ROOT/apps/brand-info/brand-info.conf`
brandset_str=`cat $DOCUMENT_ROOT/apps/brand-info/brand-info.conf`
cat <<EOF
<div class="col-md-6">
<form id="brand_info_save">
<table class="table">
<tr>
<th>
$_LANG_Device
</th>
<th>
$_LANG_Brandwidth
</th>
</tr>
EOF
for dev in $devs
do
# eval brandset='$'brandset_${dev}
brandset=`echo "$brandset_str" | jq -r '.["'"${dev}"'"]'`
# [ -z "${brandset}" ] && brandset=100
[ "$brandset" = "null" ] && brandset="100"
radom_str=$(echo ${dev} | md5sum | cut -c1-5)
cat <<EOF
<tr>
<td>
${dev}
</td>
<td>
<div class="form-group has-success has-feedback">
  <label class="control-label sr-only" for="${dev}">Hidden label</label>
  <input type="text" class="form-control" id="${dev}" name="if_${radom_str}_value" value="${brandset}">
  <input type="hidden" name="if_${radom_str}_name" value="${dev}">
  <span class="glyphicon form-control-feedback">M</span>
</div>
</td>
</tr>
EOF
done

cat <<EOF
<tr>
<th>
$_LANG_Option
</th>
<th>
<input type="hidden" name="action" value="brand_info_save">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</th>
</tr>
</table>
</form>
</div>
<div class="col-md-6">
$_LANG_Home_proportional_bandwidth_for_display
</div>
EOF
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
