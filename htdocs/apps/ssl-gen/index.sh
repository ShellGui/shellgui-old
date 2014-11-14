#!/bin/sh

main()
{
[ -d /data/ssl ] || mkdir /data/ssl

[ -n "$FORM_server" ] || FORM_server="lighttpd"
[ "$FORM_server" = "lighttpd"  ] && ssl_base_dir="$DOCUMENT_ROOT/../ssl/" || ssl_base_dir="/data/ssl/$FORM_server"

decode_str=`openssl x509 -in $ssl_base_dir/"$FORM_server".pem -inform pem -noout -text -nameopt multiline,-esc_msb,utf8 | grep -E "countryName.*=|stateOrProvinceName.*=|localityName.*=|organizationName.*=|organizationalUnitName.*=|commonName.*=|Not After|Not Before" | sort -n | uniq`
SSL_SERVER_V_START=`echo "$decode_str" | grep "Not Before" | sed 's/Not Before[ ]*://'`
SSL_SERVER_V_END=`echo "$decode_str" | grep "Not After" | sed 's/Not After[ ]*://'`
SSL_SERVER_I_DN_C=`echo "$decode_str" | grep "countryName" | awk -F " = " {'print $2'}`
SSL_SERVER_S_DN_ST=`echo "$decode_str" | grep "stateOrProvinceName" | awk -F " = " {'print $2'}`
SSL_SERVER_S_DN_L=`echo "$decode_str" | grep "localityName" | awk -F " = " {'print $2'}`
SSL_SERVER_S_DN_O=`echo "$decode_str" | grep "organizationName" | awk -F " = " {'print $2'}`
SSL_SERVER_S_DN_OU=`echo "$decode_str" | grep "organizationalUnitName" | awk -F " = " {'print $2'}`
SSL_SERVER_S_DN_CN=`echo "$decode_str" | grep "commonName" | awk -F " = " {'print $2'}`

remaining_day=$(expr $(expr $(date -d "$SSL_SERVER_V_END" +%s) - $(date +%s)) / 86400)
if
[ $remaining_day -gt 90 ]
then
color="success"
Tip="$_LANG_Distance_expired $remaining_day $_LANG_Days_left"
elif
[ $remaining_day -lt 90 ] && [ $remaining_day -gt 10 ]
then
color="warning"
Tip="$_LANG_Distance_expired $remaining_day $_LANG_Days_left"
elif
color="danger"
[ $remaining_day -lt 10 ]
then
Tip="$remaining_day $_LANG_Days_out"
fi

cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#build').on('submit', function(e){
    e.preventDefault();
    var data = "app=ssl-gen&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#ssl_key_edit').on('submit', function(e){
    e.preventDefault();
    var data = "app=ssl-gen&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
function del_ssl(ssl_name)
{
if (confirm("Do you wan to del " + ssl_name)) {
    var data = 'app=ssl-gen&action=del_ssl&ssl_name=' + ssl_name;
    var url = 'index.cgi';
	Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
</script>
EOF

cat <<EOF
<div class="container" id="ajax-fluid">
	<div class="row">
		<div class="col-md-4">
<legend>$_LANG_Certificate_generation</legend>
<form id="build">
<table class="table">
<tr>
<th>
$_LANG_Save_as
</th>
<th>
<input class="form-control" placeholder="xx.com" name="server" value="`[ "$FORM_server" != "lighttpd" ] && echo $FORM_server`">
</th>
</tr>
<tr>
<td>
$_LANG_Country
</td>
<td>
<input class="form-control" placeholder="Country" name="SSL_C" value="$SSL_SERVER_I_DN_C">
</td>
</tr>
<tr>
<td>
$_LANG_Provinces
</td>
<td>
<input class="form-control" placeholder="State" name="SSL_ST" value="$SSL_SERVER_S_DN_ST">
</td>
</tr>
<tr>
<td>
$_LANG_City
</td>
<td>
<input class="form-control" placeholder="Location" name="SSL_L" value="$SSL_SERVER_S_DN_L">
</td>
</tr>
<tr>
<td>
$_LANG_Organization
</td>
<td>
<input class="form-control" placeholder="Organization" name="SSL_O" value="$SSL_SERVER_S_DN_O">
</td>
</tr>
<tr>
<td>
$_LANG_Organizational_unit
</td>
<td>
<input class="form-control" placeholder="Organizational Unit" name="SSL_OU" value="$SSL_SERVER_S_DN_OU">
</td>
</tr>
<tr>
<td>
$_LANG_Common_name
</td>
<td>
<input class="form-control" placeholder="Common Name" name="SSL_CN" value="$SSL_SERVER_S_DN_CN">
</td>
</tr>
<tr>
<td>
$_LANG_Guarantee
</td>
<td>
<select class="form-control" name="SSL_TIME">
	<option value="365">1 $_LANG_Year</option>
	<option value="730">2 $_LANG_Year</option>
	<option value="1095">3 $_LANG_Year</option>
	<option value="1825">5 $_LANG_Year</option>
	<option value="3650">10 $_LANG_Year</option>
</select>
</td>
</tr>
<tr>
<td>
$_LANG_Size
</td>
<td>
<select class="form-control" name="SSL_SIZE">
	<option value="2048">2048</option>
	<option value="1024">1024</option>
</select>
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="build">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Build</button>
</td>
</tr>
</table>
</form>

		</div>
		<div class="col-md-8">
<legend>$_LANG_Current_certificate_file</legend>
<p class="bg-$color">$_LANG_Build_on $SSL_SERVER_V_START
$_LANG_Overdue_on $SSL_SERVER_V_END
$Tip
</p>

<form id="ssl_key_edit">
<div class="panel-group" id="ssl_key_edit">
<div class="panel panel-warning">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#ssl_key_edit" href="#prv-key" class="collapsed">
          <span class="glyphicon glyphicon-comment"></span>$_LANG_Private_key</a>
      </h4>
    </div>
    <div id="prv-key" class="panel-collapse collapse">
      <div class="panel-body">
<textarea style="width:100%;height:260px" name="private_key" class="bg-warning">
`cat $ssl_base_dir/private.key`
</textarea>
	  </div>
    </div>
		  </div>
<div class="panel panel-success">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#ssl_key_edit" href="#pub-key">
          <span class="glyphicon glyphicon-comment"></span>$_LANG_Public_Key
		</a>
      </h4>
    </div>
	  <div id="pub-key" class="panel-collapse collapse in">
		  <div class="panel-body">
<textarea style="width:100%;height:260px" name="public_csr" class="bg-warning">
`cat $ssl_base_dir/public.csr`
</textarea>
		  </div>
	  </div>
</div>
</div> <!--ssl_key_edit-->
<div>
<input type="hidden" name="action" value="ssl_key_edit">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</div>
</form>
		</div>

<div class="col-md-12" id="ssl_manager">
<table class="table">
<legend>SSL Manager</legend>
<script>
\$(function () { 
    \$("[data-toggle='popover']").popover(); 
});
</script>
EOF
ssl_list=`ls -l /data/ssl/ | grep "^d" | awk {'print $NF'}`
if
[ -n "$ssl_list" ]
then

for ssl_name in $ssl_list
do
cat <<EOF
<tr><td><a data-toggle="popover" data-placement="focus" title="${ssl_name} SSL Detail" data-html="true" data-content="<pre>`find /data/ssl/${ssl_name}`</pre>" data-original-title="SSL Detail">/data/ssl/${ssl_name}</a></td><td>
<a class="btn btn-primary" href="/index.cgi?app=ssl-gen&action=download&ssl_name=${ssl_name}" type="button">$_LANG_Download</a>
<a class="btn btn-primary" href="/index.cgi?app=ssl-gen&server=${ssl_name}" type="button">$_LANG_Edit</a>
<a class="btn btn-danger" onclick="del_ssl('${ssl_name}');"  type="button">$_LANG_Del</a>
</td></tr>
EOF
done
else
echo "there has no ssl"
fi
cat <<EOF
</table>
</div>

	</div>
</div>


EOF
}
download()
{
tar czf /tmp/ssl_download.tar.gz /data/ssl/$FORM_ssl_name
main.sbin http_download /tmp/ssl_download.tar.gz $FORM_ssl_name.tar.gz
}
del_ssl()
{
if
[ -d /data/ssl/$FORM_server ]
then
rm -rf /data/ssl/$FORM_server
(echo "Del $FORM_server success" | main.sbin output_json 0) || exit 0
else
(echo "Del Fail" | main.sbin output_json 1) || exit 1
fi
}
build()
{
[ -n "$FORM_server" ] || FORM_server="lighttpd"
[ "$FORM_server" = "lighttpd"  ] && ssl_base_dir="$DOCUMENT_ROOT/../ssl/" || ssl_base_dir="/data/ssl/$FORM_server"
[ -d $ssl_base_dir ] || mkdir -p $ssl_base_dir
([ -n "$FORM_SSL_C" ] && [ $(expr length $(echo "$FORM_SSL_C")) -eq 2 ] || echo "$_LANG_Country""$_LANG_Need""2""$_LANG_Characters" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_C" ] && echo "$FORM_SSL_C" | main.sbin regx_str islang_en || echo "$_LANG_Country""$_LANG_Need""$_LANG_In_english" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_ST" ] || echo "$_LANG_Provinces""$_LANG_Cannt_empty" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_L" ] || echo "$_LANG_City""$_LANG_Cannt_empty" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_O" ] || echo "$_LANG_Organization""$_LANG_Cannt_empty" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_OU" ] || echo "$_LANG_Organizational_unit""$_LANG_Cannt_empty" | main.sbin output_json 1) || exit 1
([ -n "$FORM_SSL_CN" ] || echo "$_LANG_Common_name""$_LANG_Cannt_empty" | main.sbin output_json 1) || exit 1

old_decode_str=`openssl x509 -in $ssl_base_dir/"$FORM_server".pem -inform pem -noout -text -nameopt multiline,-esc_msb,utf8 | grep -E "countryName.*=|stateOrProvinceName.*=|localityName.*=|organizationName.*=|organizationalUnitName.*=|commonName.*=|Not After|Not Before" | sort -n | uniq`
old_SSL_SERVER_V_START=`echo "$old_decode_str" | grep "Not Before" | sed 's/Not Before[ ]*://g'`
old_SSL_SERVER_V_END=`echo "$old_decode_str" | grep "Not After" | sed 's/Not After[ ]*://'`
old_SSL_SERVER_I_DN_C=`echo "$old_decode_str" | grep "countryName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_ST=`echo "$old_decode_str" | grep "stateOrProvinceName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_L=`echo "$old_decode_str" | grep "localityName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_O=`echo "$old_decode_str" | grep "organizationName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_OU=`echo "$old_decode_str" | grep "organizationalUnitName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_CN=`echo "$old_decode_str" | grep "commonName" | awk -F " = " {'print $2'}`

openssl req -new -newkey rsa:$FORM_SSL_SIZE -x509 -days $FORM_SSL_TIME -nodes -out $ssl_base_dir/public.csr -keyout $ssl_base_dir/private.key -subj "/C=$FORM_SSL_C/ST=`echo "$FORM_SSL_ST"`/L=`echo "$FORM_SSL_L"`/O=`echo "$FORM_SSL_O"`/OU=`echo "$FORM_SSL_OU"`/CN=`echo "$FORM_SSL_CN"`" -utf8 >/dev/null 2>&1
cat $ssl_base_dir/private.key $ssl_base_dir/public.csr > $ssl_base_dir/"$FORM_server".pem
if
[ $? -eq 0 ]
then
new_decode_str=`openssl x509 -in $ssl_base_dir/"$FORM_server".pem -inform pem -noout -text -nameopt multiline,-esc_msb,utf8 | grep -E "countryName.*=|stateOrProvinceName.*=|localityName.*=|organizationName.*=|organizationalUnitName.*=|commonName.*=|Not After|Not Before" | sort -n | uniq`
new_SSL_SERVER_V_START=`echo "$new_decode_str" | grep "Not Before" | sed 's/Not Before[ ]*://'`
new_SSL_SERVER_V_END=`echo "$new_decode_str" | grep "Not After" | sed 's/Not After[ ]*://'`
new_SSL_SERVER_I_DN_C=`echo "$new_decode_str" | grep "countryName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_ST=`echo "$new_decode_str" | grep "stateOrProvinceName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_L=`echo "$new_decode_str" | grep "localityName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_O=`echo "$new_decode_str" | grep "organizationName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_OU=`echo "$new_decode_str" | grep "organizationalUnitName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_CN=`echo "$new_decode_str" | grep "commonName" | awk -F " = " {'print $2'}`
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_ssl_build" \
				detail="_NOTICE_do_ssl_build_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="ssl-gen" \
				dest_type="app" \
					variable="{\
						\"old_SSL_SERVER_V_START\":\"$old_SSL_SERVER_V_START\", \
						\"old_SSL_SERVER_V_END\":\"$old_SSL_SERVER_V_END\", \
						\"old_SSL_SERVER_I_DN_C\":\"$old_SSL_SERVER_I_DN_C\", \
						\"old_SSL_SERVER_S_DN_ST\":\"$old_SSL_SERVER_S_DN_ST\", \
						\"old_SSL_SERVER_S_DN_L\":\"$old_SSL_SERVER_S_DN_L\", \
						\"old_SSL_SERVER_S_DN_O\":\"$old_SSL_SERVER_S_DN_O\", \
						\"old_SSL_SERVER_S_DN_OU\":\"$old_SSL_SERVER_S_DN_OU\", \
						\"old_SSL_SERVER_S_DN_CN\":\"$old_SSL_SERVER_S_DN_CN\", \
						\"new_SSL_SERVER_V_START\":\"$new_SSL_SERVER_V_START\", \
						\"new_SSL_SERVER_V_END\":\"$new_SSL_SERVER_V_END\", \
						\"new_SSL_SERVER_I_DN_C\":\"$new_SSL_SERVER_I_DN_C\", \
						\"new_SSL_SERVER_S_DN_ST\":\"$new_SSL_SERVER_S_DN_ST\", \
						\"new_SSL_SERVER_S_DN_L\":\"$new_SSL_SERVER_S_DN_L\", \
						\"new_SSL_SERVER_S_DN_O\":\"$new_SSL_SERVER_S_DN_O\", \
						\"new_SSL_SERVER_S_DN_OU\":\"$new_SSL_SERVER_S_DN_OU\", \
						\"new_SSL_SERVER_S_DN_CN\":\"$new_SSL_SERVER_S_DN_CN\" \
					}" >/dev/null 2>&1

(echo "$_LANG_Certificate_generation""$_LANG_Success" | main.sbin output_json 0) || exit 1
else
(echo "$_LANG_Certificate_generation""$_LANG_Fail" | main.sbin output_json 1) || exit 1
fi
}
ssl_key_edit()
{
old_decode_str=`openssl x509 -in $ssl_base_dir/"$FORM_server".pem -inform pem -noout -text -nameopt multiline,-esc_msb,utf8 | grep -E "countryName.*=|stateOrProvinceName.*=|localityName.*=|organizationName.*=|organizationalUnitName.*=|commonName.*=|Not After|Not Before" | sort -n | uniq`
old_SSL_SERVER_V_START=`echo "$old_decode_str" | grep "Not Before" | sed 's/Not Before[ ]*://'`
old_SSL_SERVER_V_END=`echo "$old_decode_str" | grep "Not After" | sed 's/Not After[ ]*://'`
old_SSL_SERVER_I_DN_C=`echo "$old_decode_str" | grep "countryName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_ST=`echo "$old_decode_str" | grep "stateOrProvinceName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_L=`echo "$old_decode_str" | grep "localityName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_O=`echo "$old_decode_str" | grep "organizationName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_OU=`echo "$old_decode_str" | grep "organizationalUnitName" | awk -F " = " {'print $2'}`
old_SSL_SERVER_S_DN_CN=`echo "$old_decode_str" | grep "commonName" | awk -F " = " {'print $2'}`

echo "$FORM_private_key" > $ssl_base_dir/private.key && \
echo "$FORM_public_csr" > $ssl_base_dir/public.csr
cat $ssl_base_dir/private.key $ssl_base_dir/public.csr > $ssl_base_dir/"$FORM_server".pem.tmp

new_decode_str=`openssl x509 -in $ssl_base_dir/"$FORM_server".pem.tmp -inform pem -noout -text -nameopt multiline,-esc_msb,utf8 | grep -E "countryName.*=|stateOrProvinceName.*=|localityName.*=|organizationName.*=|organizationalUnitName.*=|commonName.*=|Not After|Not Before" | sort -n | uniq`
new_SSL_SERVER_V_START=`echo "$new_decode_str" | grep "Not Before" | sed 's/Not Before[ ]*://'`
new_SSL_SERVER_V_END=`echo "$new_decode_str" | grep "Not After" | sed 's/Not After[ ]*://'`
new_SSL_SERVER_I_DN_C=`echo "$new_decode_str" | grep "countryName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_ST=`echo "$new_decode_str" | grep "stateOrProvinceName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_L=`echo "$new_decode_str" | grep "localityName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_O=`echo "$new_decode_str" | grep "organizationName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_OU=`echo "$new_decode_str" | grep "organizationalUnitName" | awk -F " = " {'print $2'}`
new_SSL_SERVER_S_DN_CN=`echo "$new_decode_str" | grep "commonName" | awk -F " = " {'print $2'}`

if
[ -n "$new_SSL_SERVER_V_START" ]
then
rm $ssl_base_dir/"$FORM_server".pem
mv $ssl_base_dir/"$FORM_server".pem.tmp $ssl_base_dir/"$FORM_server".pem
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_ssl_reimport" \
				detail="_NOTICE_ssl_reimport_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="ssl-gen" \
				dest_type="app" \
					variable="{\
						\"old_SSL_SERVER_V_START\":\"$old_SSL_SERVER_V_START\", \
						\"old_SSL_SERVER_V_END\":\"$old_SSL_SERVER_V_END\", \
						\"old_SSL_SERVER_I_DN_C\":\"$old_SSL_SERVER_I_DN_C\", \
						\"old_SSL_SERVER_S_DN_ST\":\"$old_SSL_SERVER_S_DN_ST\", \
						\"old_SSL_SERVER_S_DN_L\":\"$old_SSL_SERVER_S_DN_L\", \
						\"old_SSL_SERVER_S_DN_O\":\"$old_SSL_SERVER_S_DN_O\", \
						\"old_SSL_SERVER_S_DN_OU\":\"$old_SSL_SERVER_S_DN_OU\", \
						\"old_SSL_SERVER_S_DN_CN\":\"$old_SSL_SERVER_S_DN_CN\", \
						\"new_SSL_SERVER_V_START\":\"$new_SSL_SERVER_V_START\", \
						\"new_SSL_SERVER_V_END\":\"$new_SSL_SERVER_V_END\", \
						\"new_SSL_SERVER_I_DN_C\":\"$new_SSL_SERVER_I_DN_C\", \
						\"new_SSL_SERVER_S_DN_ST\":\"$new_SSL_SERVER_S_DN_ST\", \
						\"new_SSL_SERVER_S_DN_L\":\"$new_SSL_SERVER_S_DN_L\", \
						\"new_SSL_SERVER_S_DN_O\":\"$new_SSL_SERVER_S_DN_O\", \
						\"new_SSL_SERVER_S_DN_OU\":\"$new_SSL_SERVER_S_DN_OU\", \
						\"new_SSL_SERVER_S_DN_CN\":\"$new_SSL_SERVER_S_DN_CN\" \
					}" >/dev/null 2>&1

(echo "$_LANG_Certificate_generation""$_LANG_Success" | main.sbin output_json 0) || exit 1
else
(echo "$_LANG_Certificate_generation""$_LANG_Fail" | main.sbin output_json 1) || exit 1
fi

}

lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`

# [ -n "$FORM_server" ] && export is_main_page=1
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi
