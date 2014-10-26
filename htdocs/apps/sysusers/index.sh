#!/bin/sh

main()
{
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF
cat <<'EOF'  #js
<script type="text/javascript">
$(function(){
  $('#sysuser').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    save(data, 'sysuser');
  });
  $('#user_list').on('click', 'button.delete', function(e){
    e.preventDefault();
    var data = {app: 'sysusers', action: 'delete', username: $(this).val()};
    save(data, 'delete');
  });
  $('#changepwd').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    save(data, 'edit');
  });
});
function save(data, type)
{
  var url = 'index.php';
  if (type == 'delete' || type == 'edit') {
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid', function(data){ 
      if (type == 'edit') {
        if (data.status == 0) {
          location.href = 'index.php?app=sysusers';
        }else {
          Ha.notify.show(data.msg);
        }
      }else {
        $('#user-'+data.username).remove();
      }
    }, 1);
  }else {
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  }
}
</script>
EOF
cat <<EOF
<style>
 table { table-layout: fixed; }
 table th, table td { overflow: hidden; }
</style>
EOF
echo "<legend>$_LANG_User_Index</legend>"
echo "<table class=\"table\">"
# eval `cat /etc/group | awk -F ":" {'print "export groupid_"$3"="$1'}`
echo "<tr><th>uid</th><th>$_LANG_Username</th><th>$_LANG_Password</th><th>$_LANG_Group</th><th>$_LANG_Desc</th><th>$_LANG_Home</th><th>shell</th><th>$_LANG_Option</th></tr>"
table_str=`awk 'NR==FNR{a[FNR]=$0;next}{print a[FNR] ":" $0}' /etc/passwd /etc/shadow | awk -F ":" '{if ($1 == "root") print "<tr><td>"$3"</td><td>"$1"</td><td style=\"width: 20%\">"$9"</td><td>:"$4":</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td><a class=\"btn btn-primary\" href=\"index.cgi?app=sysusers&action=edituser&username="$1"\">'$_LANG_Edit'</a></td></tr>";else print "<tr><td>"$3"</td><td>"$1"</td><td style=\"width: 20%\">"$9"</td><td>:"$4":</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td><a class=\"btn btn-primary\" href=\"index.cgi?app=sysusers&action=edituser&username="$1"\">'$_LANG_Edit'</a><a class=\"btn btn-danger\" href=\"index.cgi?app=sysusers&action=deluser&username="$1"\">'$_LANG_Del'</a></td></tr>"}'`
group_str=`cat /etc/group`
for i in `echo "$group_str" | awk -F ":" {'print $3'}`
do
group=`echo "$group_str" | grep ":${i}:" | awk -F ":" {'print $1'}`
table_str=`echo "$table_str" | sed "s/:${i}:/$group/g"`
done
echo "$table_str"
echo "</table>"

cat <<EOF
</div> <!--container-->
EOF

cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#adduser').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF # html添加用户
<form id="adduser">
<legend>$_LANG_Add_User</legend>
<div class="row">
  <div class="col-xs-2">
  uid
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="uid" placeholder="uid">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_System_will_automatically_assign_uid_when_it_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Username
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="username" placeholder="username">
  </div>
  <div class="col-xs-6">
  <p class="bg-danger">$_LANG_Can_not_be_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Password
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="password" placeholder="password">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_When_you_use_a_empty_password__and_it_can_not_log_in</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Group
  </div>
  <div class="col-xs-4">
		<select name="group" class="form-control">
			<option value="">$_LANG_Use_it_owns_name_for_groupname</option>
EOF
for group_u in `cat /etc/group | awk -F ":" {'print $1'}`
do
echo "<option value=\"${group_u}\">${group_u}</option>"
done
cat <<EOF
		</select>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_System_will_automatically_assign_gid_when_it_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Desc
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="GECOS" placeholder="GECOS">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Will_not_use_GECOS_when_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Home
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="home" placeholder="home">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Will_not_use_home_dictionary_when_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  shell
  </div>
  <div class="col-xs-4">
<input class="form-control" list="shell_adduser" name="shell" value="/bin/nologin">
<datalist id="shell_adduser">
EOF
for shell in sh ash clish bash dash klish mksh tcsh slsh
do
path_output=""
path_output=`which ${shell}`
[ -n "$path_output" ]&& echo "<option value=\"$path_output\">$path_output</option>"
done

cat <<EOF
</datalist>
	  
	  
  </div>
  <div class="col-xs-6">
  <p class="bg-warning">$_LANG_Will_use_bin_nologin_when_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Option
  </div>
  <div class="col-xs-4">
  <input type="hidden" name="action" value="adduser">
  <button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Do_add</p>
  </div>
</div>
</form>


<legend>Group Manage</legend>
<div>
<form id="delgroup">
	<table class="table">
	<tr>
	<th>$_LANG_Group_name</th>
	<th>gid</th>
	<th>$_LANG_Password</th>
	<th>$_LANG_User_In_MainGroup</th>
	<th>$_LANG_User_In_SGroup</th>
	<th>$_LANG_Option</th>
	</tr>
EOF
# awk 'NR==FNR{a[FNR]=$0;next}{print a[FNR] ":" $0}' /etc/group /etc/gshadow
passwd_str=`cat /etc/passwd`
group_pre=`awk 'NR==FNR{a[FNR]=$0;next}{print a[FNR] ":" $0}' /etc/group /etc/gshadow`
group_pre_supplemental="$group_pre"
group_pre_main=""
for groupid_used in `echo "$passwd_str" | awk -F ":" {'print $4'} | sort -n | uniq`
do
group_pre_supplemental=`echo "$group_pre_supplemental" | sed "/\:${groupid_used}\:/d"`
group_pre_main=`echo -e "$group_pre_main\n"$(echo "$group_pre" | grep ":${groupid_used}:")`
done
group_pre_main=`echo "$group_pre_main" | sed '/^$/d'`
group_pre_main=`echo "$group_pre_main" | sed -e 's/$/:/g' -e '/-e/d'`
IFS_bak=$IFS
IFS='
'
for line in $passwd_str
do
user_group_str=""
gid=`echo ${line} | awk -F ":" {'print $4'}`
user_name=`echo ${line} | awk -F ":" {'print $1'}`
user_group_str=`echo "$group_pre_main" | grep "^.*:.:${gid}:"`
[ -n "$user_group_str" ] && echo "$group_main" | grep -q "^.*:.:$gid:"
if
[ $? -ne 0 ]
then
group_main=`echo -e "$group_main\n""${user_group_str}$user_name,"`
fi
done
IFS=$IFS_bak
group_main=`echo "$group_main" | sed -e '/^$/d' -e '/-e/d'`
echo "$group_main" | awk -F ":" {'print "<tr><td>"$1"</td><td>"$3"</td><td>"$6"</td><td>"$5"</td><td>"$4"</td><td><a class=\"btn btn-primary\" href=\"index.cgi?app=sysusers&action=editgroup&groupname="$1"\">'$_LANG_Edit'</a></td></tr>"'}
echo "$group_pre_supplemental" | awk -F ":" {'print "<tr><td>"$1"</td><td>"$3"</td><td>"$6"</td><td></td><td>"$4"</td><td><a class=\"btn btn-primary\" href=\"index.cgi?app=sysusers&action=editgroup&groupname="$1"\">'$_LANG_Edit'</a><a class=\"btn btn-danger\" href=\"index.cgi?app=sysusers&action=delgroup&groupname="$1"\">'$_LANG_Del'</a></td></tr>"'}

cat <<EOF
	</table>
</form>
</div>
EOF
cat <<'EOF'
<script type="text/javascript">
$(function(){
  $('#addgroup').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF

cat <<EOF
<form id="addgroup">
<legend>$_LANG_Add_group</legend>
<div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Group_name
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="groupname" placeholder="groupname">
  </div>
  <div class="col-xs-6">
  <p class="bg-danger">$_LANG_Can_not_be_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  gid
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="gid" placeholder="gid">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_System_will_automatically_assign_uid_when_it_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Option
  </div>
  <div class="col-xs-4">
  <input type="hidden" name="action" value="addgroup">
  <button class="btn btn-primary" id="_submit" type="submit">$_LANG_Add</button>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Do_add</p>
  </div>
</div>
</div>
</form>

EOF

}
addgroup()
{
args=""
([ -n "$FORM_groupname" ] || echo "$_LANG_Groupname_Can_not_be_empty" | main.sbin output_json 1) || exit 1
if
[ -n "$FORM_gid" ]
then
(echo "$FORM_gid" | main.sbin regx_str islang_alb || echo "$_LANG_gid_must_be_number" | main.sbin output_json 1) || exit 1
([ $FORM_gid -le 60000 ] || echo "$_LANG_uid_Can_not_be_more_then_60000" | main.sbin output_json 1) || exit 1
args="$args -g $FORM_gid"
fi
groupadd $FORM_groupname $args >/dev/null 2>&1
if
[ $? -eq 0 ]
then

new_group_str=`cat /etc/group | grep "^$FORM_groupname:"`
new_group_shadow=`cat /etc/gshadow | grep "^$FORM_groupname:"`
new_group_gid=`echo "$new_group_str" | awk -F ":" {'print $3'}`
new_group_passwd_encypt=`echo "$new_group_shadow" | awk -F ":" {'print $2'}`

main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_addgroup" \
				detail="_NOTICE_do_addgroup_detail" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"newgroupname\":\"$FORM_groupname\", \
						\"new_group_gid\":\"$new_group_gid\", \
						\"new_group_passwd_encypt\":\"`echo $new_group_passwd_encypt | tr '$' '_' | sed 's/_/[S\]/g'`\" \
					}" >/dev/null 2>&1

echo "$_LANG_Group_add_success" | main.sbin output_json 0 || exit 0
else
echo "$_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi
}
adduser()
{

args=""
if
[ -n "$FORM_uid" ]
then
(echo "$FORM_uid" | main.sbin regx_str islang_alb || echo "$_LANG_uid_must_be_number" | main.sbin output_json 1) || exit 1
([ $FORM_uid -le 60000 ] || echo "$_LANG_uid_Can_not_be_more_then_60000" | main.sbin output_json 1) || exit 1
args="$args -u $FORM_uid"
fi

if
[ -n "$FORM_username" ]
then
(echo "$FORM_username" | main.sbin regx_str islang_enalb || echo "$_LANG_Username_must_be_in_Eng_or_Eng_with_number" | main.sbin output_json 1) || exit 1
[ $(expr length $(echo "$FORM_username")) -le 8 ] || echo "$_LANG_Length_of_Username_must_be_shorter_than_8_characters" | main.sbin output_json 1 || exit 1
args="$args $FORM_username"
else
echo "$_LANG_Username $_LANG_Can_not_be_empty" | main.sbin output_json 1 || exit 1
fi
if
cat /etc/passwd | awk -F ":" {'print $1'} | grep -q "^$FORM_username$"
then
echo "$_LANG_User_name_already_exists" | main.sbin output_json 1 || exit 1
fi
if
[ -n "$FORM_password" ]
then
[ $(expr length $(echo "$FORM_password")) -ge 6 ] || echo "$_LANG_Password_length_must_be_greater_than_6_characters" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_group" ]
then
args="$args -g $FORM_group"
fi

if
[ -n "$FORM_GECOS" ]
then
	if
	echo "$FORM_GECOS" | grep -q ":"
	then
	echo "$_LANG_GECOS_field_can_not_contain" | main.sbin output_json 1 || exit 1
	fi
args="$args -c $FORM_GECOS"
fi

if
[ -n "$FORM_home" ]
then
echo "$FORM_home" | grep -q "^/" || echo "$_LANG_home_must_use_root_for_the_beginning" | main.sbin output_json 1 || exit 1
	if
	echo "$FORM_home" | grep -q " "
	then
	echo "$_LANG_Path_can_not_with_spaces" | main.sbin output_json 1 || exit 1
	fi
echo "$FORM_home" | main.sbin regx_str ispath || echo "$_LANG_home_must_be_a_path" | main.sbin output_json 1 || exit 1
args="$args -d $FORM_home"
else
args="$args -d / -M"
fi
if
[ -n "$FORM_shell" ]
then
	if
	[ "$FORM_shell" != "/bin/nologin" ] && [ "$FORM_shell" != "/bin/false" ]
	then
	[ -x "$FORM_shell" ] || echo "$_LANG_Wrong_shell_submit" | main.sbin output_json 1 || exit 1
	args="$args -s $FORM_shell"
	fi
else
args="$args -s /bin/nologin"
fi
SUCCESS_add=0
resule=`useradd $args 2>&1 | tr '\n' '.'`
[ $? -eq 0 ] && SUCCESS_add=`expr $SUCCESS_add + 1`
if
[ -n "$FORM_password" ]
then
passwd $FORM_username <<EOF >/dev/null 2>&1
$FORM_password
$FORM_password
EOF
fi
[ $? -eq 0 ] && SUCCESS_add=`expr $SUCCESS_add + 1`
if
[ $SUCCESS_add -eq 2 ]
then
new_user_passwd_str=`cat /etc/passwd | grep "^$FORM_username"`
new_user_shadow_str=`cat /etc/shadow | grep "^$FORM_username"`
new_group_str=`cat /etc/group`
new_user_uid=`echo "$new_user_passwd_str" | awk -F ":" {'print $3'}`
new_user_gid=`echo "$new_user_passwd_str" | awk -F ":" {'print $4'}`
new_user_home=`echo "$new_user_passwd_str" | awk -F ":" {'print $6'}`
new_user_shell=`echo "$new_user_passwd_str" | awk -F ":" {'print $7'}`
new_user_group=`echo "$new_group_str" | grep ".*:.:$new_user_gid:" | awk -F ":" {'print $1'}`
new_user_sgroups=`id -Gn $FORM_username | sed "s/^$new_user_group //g"`
new_user_passwd_encypt=`echo "$new_user_shadow_str" | awk -F ":" {'print $2'}`
new_user_passwd_min=`echo "$new_user_shadow_str" | awk -F ":" {'print $4'}`
new_user_passwd_max=`echo "$new_user_shadow_str" | awk -F ":" {'print $5'}`
new_passwd_notice_days=`echo "$new_user_shadow_str" | awk -F ":" {'print $6'}`
new_inactive_days_after_expir=`echo "$new_user_shadow_str" | awk -F ":" {'print $7'}`

main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_useradd" \
				detail="_NOTICE_do_useradd_detail" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"newusername\":\"$FORM_username\", \
						\"new_user_uid\":\"$new_user_uid\", \
						\"new_user_gid\":\"$new_user_gid\", \
						\"new_user_home\":\"$new_user_home\", \
						\"new_user_shell\":\"$new_user_shell\", \
						\"new_user_group\":\"$new_user_group\", \
						\"new_user_sgroups\":\"$new_user_sgroups\", \
						\"new_user_passwd_encypt\":\"`echo $new_user_passwd_encypt | tr '$' '_' | sed 's/_/[S\]/g'`\", \
						\"new_user_passwd_min\":\"$new_user_passwd_min\", \
						\"new_user_passwd_max\":\"$new_user_passwd_max\", \
						\"new_passwd_notice_days\":\"$new_passwd_notice_days\", \
						\"new_inactive_days_after_expir\":\"$new_inactive_days_after_expir\" \
					}" >/dev/null 2>&1

echo "$_LANG_Success" | main.sbin output_json 0 || exit 0
else
echo "$resule" | main.sbin output_json 1 || exit 1
fi
# FORM_group=4
# FORM_app=sysusers
# FORM_shell=7
# FORM_password=3
# FORM_action=adduser
# FORM_home=6
# FORM_GECOS=5
# FORM_username=2
# FORM_uid=1
# -u 指定UID号
# useradd -g $group -M/-d $home -s /bin/false username
#-c, --comment COMMENT         新账户的 GECOS 字段


}





lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/sysusers/group.sh
. $DOCUMENT_ROOT/apps/sysusers/user.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi

