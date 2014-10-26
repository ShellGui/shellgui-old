#!/bin/sh

edituser()
{

cat /etc/passwd | awk -F ":" {'print $1'} | grep -q "^$FORM_username$" || main.sbin header_jump "index.cgi?app=sysusers"
_LANG_App_name="$_LANG_App_name -> $_LANG_Edit $_LANG_Username: $FORM_username"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<'EOF'
<script>
$(function(){
  $('#do_useredit').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#deluserpasswd').on('click', function(e){
    e.preventDefault();
EOF
cat <<EOF
    if (confirm('$_LANG_Do_you_confirm_to_del_user_password')) {
      var data = "app=sysusers&action=do_deluserpass&username=$FORM_username";
EOF
cat <<'EOF'
      var url = 'index.cgi';
      Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
    }
  });
});
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

user_passwd_str=`cat /etc/passwd | grep "^$FORM_username:"`
user_shadow_str=`cat /etc/shadow | grep "^$FORM_username:"`
cat <<EOF
<legend>$_LANG_Edit $_LANG_Username: $FORM_username</legend>
<form id="do_useredit">
<div class="row">
  <div class="col-xs-2">
  uid
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="uid" placeholder="uid" value="`echo "$user_passwd_str" | awk -F ":" {'print $3'}`">
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
  <input class="form-control" type="text" name="username" placeholder="username" value="$FORM_username">
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
  <input class="form-control" type="text" name="password" placeholder="password"><p>
  <input class="form-control" type="text" name="password_cf" placeholder="password confirm">
  </div>
  <div class="col-xs-6">
  <p class="bg-warning">$_LANG_If_empty_no_change_password<button id="deluserpasswd" type="button" class="btn btn-danger">$_LANG_Del_User_Password</button></p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Lock_password
  </div>
  <div class="col-xs-4">
  <select name="passwd_lock" class="form-control">
EOF
if
echo "$user_shadow_str" | awk -F ":" {'print $2'} | grep -q "^!"
then
locked=selected
else
unlocked=selected
fi
cat <<EOF
	<option value="unlock" $unlocked>$_LANG_Unlocked</option>
	<option value="lock" $locked>$_LANG_Locked</option>
  </select>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Lock_and_does_not_allow_users_to_change_passwords</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Group
  </div>
  <div class="col-xs-4">
		<select name="group" class="form-control">
EOF
group_str=`cat /etc/group`
user_gid=`echo "$user_passwd_str" | awk -F ":" {'print $4'}`
usergroup=`echo "$group_str" | grep "^.*:.:$user_gid:" | awk -F ":" {'print $1'}`
for group_u in `echo "$group_str" | awk -F ":" {'print $1'}`
do
selected=""
[ "$usergroup" = "$group_u" ] && selected="selected"
echo "<option value=\"${group_u}\" $selected>${group_u}</option>"
done
cat <<EOF
		</select>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Group</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Supplementary_group
  </div>
  <div class="col-xs-4">
<div class="row" id="sgroups">
EOF
groups=`echo "$group_str" | awk -F ":" {'print $1'}`
sgroup_inused=`id -Gn $FORM_username | sed "s/^$usergroup //g"`
for sgroup in `echo "$groups" | sed "/$usergroup/d"`
do
if
echo "$sgroup_inused" | grep -q ${sgroup}
then
cat <<EOF
<div class="col-xs-4">
<INPUT TYPE="checkbox" SELECTED NAME="sgroup_$sgroup" VALUE="$sgroup" checked>$sgroup
</div>
EOF
else
cat <<EOF
<div class="col-xs-4">
<INPUT TYPE="checkbox" SELECTED NAME="sgroup_$sgroup" VALUE="$sgroup">$sgroup
</div>
EOF
fi
done

cat <<EOF
</div>

  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Modifies_user_to_several_supplementary_group</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Desc
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="GECOS" placeholder="desc" value="`echo "$user_passwd_str" | awk -F ":" {'print $5'}`">
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
  <input class="form-control" type="text" name="home" placeholder="home" value="`echo "$user_passwd_str" | awk -F ":" {'print $6'}`">
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
<input class="form-control" list="shell_adduser" name="shell" value="`echo "$user_passwd_str" | awk -F ":" {'print $7'}`">
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
  $_LANG_Users_expiration_date
  </div>
EOF
expr_days=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $8'}`
expiration_date=`date -d @$(expr $expr_days \* 3600 \* 24) +%Y-%m-%d`
cat <<EOF
  <div class="col-xs-4">
  <input class="form-control" name="expiration_date" value="$expiration_date">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_On_this_date_the_user_expires__emptying_the_account_does_not_expire</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_How_many_days_after_the_validity_period_expires_disable_the_user
  </div>
EOF
inactive_days_after_expir=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $7'}`

cat <<EOF
  <div class="col-xs-4">
  <input class="form-control" name="inactive_days_after_expir" value="$inactive_days_after_expir">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Throw_can_be_used_within_a_few_days_after_the_expiration</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Date_of_last_change_password
  </div>
EOF
passwd_lastchange_days=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $3'}`
passwd_lastchange_date=`date -d @$(expr $passwd_lastchange_days \* 3600 \* 24) +%Y-%m-%d`
cat <<EOF
  <div class="col-xs-4">
  <p>$passwd_lastchange_date</p>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Date_of_last_change_password</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_How_many_days_the_user_can_change_password
  </div>
EOF
passwd_min=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $4'}`
cat <<EOF
  <div class="col-xs-4">
  <input class="form-control" name="passwd_min" value="$passwd_min">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Days_after_last_change_date_0_for_always_can_change</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Password_expiration_days
  </div>
EOF
passwd_max=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $5'}`
cat <<EOF
  <div class="col-xs-4">
  <input class="form-control" name="passwd_max" value="$passwd_max">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Days_after_last_change_date_99999_for_never_expires</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_How_many_days_notice_before_the_expiration_of_the_user
  </div>
EOF
passwd_notice_days=`cat /etc/shadow | grep "$FORM_username:" | awk -F ":" {'print $6'}`
cat <<EOF
  <div class="col-xs-4">
  <input class="form-control" name="passwd_notice_days" value="$passwd_notice_days">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_before_expiration</p>
  </div>
</div>

<div class="row">
  <div class="col-xs-2">
  $_LANG_Option
  </div>
  <div class="col-xs-4">
  <input type="hidden" name="action" value="do_useredit">
  <input type="hidden" name="oldusername" value="$FORM_username">
  <button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Do_save</p>
  </div>
</div>
</form>
EOF

#id xx | tr ' ' '\n' 
# 查看组信息sed -n 2p           sed -n 3p
#http://urchin.blog.51cto.com/4356076/987186
#/etc/passwd
#user_name:x:uid:gid:commnet:home:shell
#/etc/shadow
#username:passwd:lastchg:min:max:warn:inactive:expire:flag
#--用户名
#--密码
#--从1970年1月1日起到上次修改密码所经过的天数
#--密码再过几天可以被变更(0表示随时可以改变)
#--密码再过几天必须被变更(99999表示永不过期)
#--密码过期前几天提醒用户(默认为一周)
#--密码过期几天后帐号被禁用  ##用户密码过期多少天后采用就禁用该帐号，0表示密码已过期就禁用帐号，-1表示禁用此功能，默认值是-1 
#--从1970年1月1日算起，多少天后账号失效

#usermod不允许你改变正在线上的使用者帐号名称 ！！！！！！！！！当usermod用来改变userID,必须确认这名user没在电脑上执行任何程序

#usermod -e 2012-09-11 urchin			#从1970年1月1日起到上次修改密码所经过的天数
#过期时间HV5vux/:15594:0:99999:7::15594: 
# usermod -f 0 urchin 
#过期后，禁用该帐号V5vux/:15594:0:99999:7:0:15594: 
#usermod -u 578 urchin
#修改uid，uid必须唯一
#usermod -s /bin/sh urchin
#修改shell
#usermod -md /home/usertest 
#修改家目录
#usermod -l urchin(新用户名称)  test(原来用户名称) 
#改变用户名
#usermod -L newuser1
#锁定账号锁定urchin的密码 urchin:$6$1PwPVBn5$o !$6$1PwPVBn5$o感叹号开头即为锁定
#usermod -U newuser1
#解除对 newuser1 的锁定
#usermod -G groupA 
#改变组
#usermod -a -G  testGroup1,testGroup2  testUser1
#追加组
#usermod -G "" testUser1
#这是清空用户testUser1所有的追加组，只属于testUser1这个默认组，不管testUser1以前有多少个附加组。
#gpasswd -d  testUser1 testGroup2 
#删除用户testUser1的testGroup2所属组,即把用户testUser1从testGroup2 组中剔除,，执行以后用户testUser1属于testUser1,testGroup1,testGroup3,testGroup4组，注意，gpasswd -d只能一个组一个组操作，如果要删除多个组则只能操作多次

#usermod -G  testGroup2,testGroup3 testUser1
#让用户testUser1的附加组变成testUser1,testGroup1,testGroup4，这个命令有点类似usermod -G "" testUser1，只不过usermod -G "" testUser1是清空，而usermod -G  testGroup2,testGroup3 testUser1 则是把 testGroup2,testGroup3以外的组清空，而保留testGroup2,testGroup3。因为gpasswd -d  一次只能删除一个，所以用这种方法可以一步直达。

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"
}
do_deluserpass()
{
[ "$FORM_username" != "root" ] || echo "$_LANG_Can_not_del_root_password" | main.sbin output_json 1 || exit 1
passwd -d $FORM_username >/dev/null 2>&1
if
[ $? -eq 0 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_deluserpass" \
				detail="_NOTICE_do_deluserpass" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="sysusers" \
				dest_type="app" \
				variable="{\"username\":\"$FORM_username\"}" >/dev/null 2>&1

echo "$_LANG_Successfully_remove_the_password" | main.sbin output_json 0 || exit 0
else
echo "$_LANG_Fails_remove_the_password" | main.sbin output_json 1 || exit 1
fi
}
do_useredit()
{
# FORM_expiration_date=2014-09-12
# FORM_GECOS=
# FORM_group=test
# FORM_home=/
# FORM_inactive_days_after_expir=2
# FORM_passwd_lock=unlock
# FORM_passwd_max=99999
# FORM_passwd_min=0
# FORM_passwd_notice_days=7
# FORM_password=
# FORM_sgroup_disk=disk
# FORM_sgroup_root=root
# FORM_sgroup_sys=sys
# FORM_shell=/bin/nologin
# FORM_uid=10001
# FORM_username=test
# FORM_oldusername=test
old_user_passwd_str=`cat /etc/passwd | grep "^$FORM_oldusername"`
old_user_shadow_str=`cat /etc/shadow | grep "^$FORM_oldusername"`
old_group_str=`cat /etc/group`
old_user_uid=`echo "$old_user_passwd_str" | awk -F ":" {'print $3'}`
old_user_gid=`echo "$old_user_passwd_str" | awk -F ":" {'print $4'}`
old_user_home=`echo "$old_user_passwd_str" | awk -F ":" {'print $6'}`
old_user_shell=`echo "$old_user_passwd_str" | awk -F ":" {'print $7'}`
old_user_group=`echo "$old_group_str" | grep ".*:.:$old_user_gid:" | awk -F ":" {'print $1'}`
old_user_sgroups=`id -Gn $FORM_oldusername | sed "s/^$old_user_group //g"`
old_user_passwd_encypt=`echo "$old_user_shadow_str" | awk -F ":" {'print $2'}`
old_user_passwd_min=`echo "$old_user_shadow_str" | awk -F ":" {'print $4'}`
old_user_passwd_max=`echo "$old_user_shadow_str" | awk -F ":" {'print $5'}`
old_passwd_notice_days=`echo "$old_user_shadow_str" | awk -F ":" {'print $6'}`
old_inactive_days_after_expir=`echo "$old_user_shadow_str" | awk -F ":" {'print $7'}`

[ -n "$FORM_username" ] || echo "用户名不能为空" | main.sbin output_json 1 || exit 1

if
cat /etc/passwd | awk -F ":" {'print $1'} | grep -v "^$FORM_oldusername$" | grep -q "^$FORM_username$"
then
echo "$_LANG_User_name_already_exists" | main.sbin output_json 1 || exit 1
fi

if
[ "$FORM_username" != "$FORM_oldusername" ]
then
(echo "$FORM_username" | main.sbin regx_str islang_enalb || echo "$_LANG_Username_must_be_in_Eng_or_Eng_with_number" | main.sbin output_json 1) || exit 1
[ $(expr length $(echo "$FORM_username")) -le 8 ] || echo "$_LANG_Length_of_Username_must_be_shorter_than_8_characters" | main.sbin output_json 1 || exit 1
usermod -l $FORM_username $FORM_oldusername >/dev/null 2>&1
[ $? -eq 0 ] || echo "$_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_uid" ]
then
(echo "$FORM_uid" | main.sbin regx_str islang_alb || echo "$_LANG_uid_must_be_number" | main.sbin output_json 1) || exit 1
([ $FORM_uid -le 60000 ] || echo "$_LANG_uid_Can_not_be_more_then_60000" | main.sbin output_json 1) || exit 1
usermod -u $FORM_uid $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "uid $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

[ "$FORM_password" = "$FORM_password_cf" ] || echo "$_LANG_Enter_the_password_confirm_inconsistent" | main.sbin output_json 1 || exit 1
if
[ -n "$FORM_password" ]
then
[ $(expr length $(echo "$FORM_password")) -ge 6 ] || echo "$_LANG_Password_length_must_be_greater_than_6_characters" | main.sbin output_json 1 || exit 1
passwd $FORM_username <<EOF >/dev/null 2>&1
$FORM_password
$FORM_password_cf
EOF
[ $? -eq 0 ] || echo "password $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_GECOS" ]
then
	if
	echo "$FORM_GECOS" | grep -q ":"
	then
	echo "GECOS不能包含:" | main.sbin output_json 1 || exit 1
	fi
usermod -c $FORM_GECOS $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "GECOS $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_home" ]
then
echo "$FORM_home" | grep -q "^/" || echo "$_LANG_home_must_use_root_for_the_beginning" | main.sbin output_json 1 || exit 1
	if
	echo "$FORM_home" | grep -q " "
	then
	echo "路径不能带空格" | main.sbin output_json 1 || exit 1
	fi
echo "$FORM_home" | main.sbin regx_str ispath || echo "$_LANG_home_must_be_a_path" | main.sbin output_json 1 || exit 1
usermod -d $FORM_home $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "home $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
else
usermod -d / -M $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "home $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_shell" ]
then
	if
	[ "$FORM_shell" != "/bin/nologin" ] && [ "$FORM_shell" != "/bin/false" ]
	then
	[ -x "$FORM_shell" ] || echo "shell $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
	usermod -s $FORM_shell $FORM_username >/dev/null 2>&1
	[ $? -eq 0 ] || echo "shell $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
	fi
else
usermod -s /bin/nologin $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "shell $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_expiration_date" ]
then
echo "$FORM_expiration_date" | grep -qE "^[2-3][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]$" || echo "$_LANG_Inconsistent_time_format" | main.sbin output_json 1 || exit 1
usermod -e $FORM_expiration_date $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "expiration_date $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_inactive_days_after_expir" ]
then
(echo "$FORM_inactive_days_after_expir" | main.sbin regx_str islang_alb || echo "$_LANG_How_many_days_after_the_validity_period_expires_disable_the_user" | main.sbin output_json 1) || exit 1
usermod -f $FORM_inactive_days_after_expir $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "inactive_days_after_expir $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_group" ]
then
usermod -g $FORM_group $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "group $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

sgroups=`env | grep "^FORM_sgroup_" | awk -F "=" {'print $2'} | grep -v "^$"`
usermod -G "" $FORM_username >/dev/null 2>&1
usermod -a -G  "$(echo "$sgroups" | tr '\n' ',' | sed 's/,$//g')" $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "sgroup $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1


if
[ -n "$FORM_passwd_min" ]
then
(echo "$FORM_passwd_min" | main.sbin regx_str islang_alb || echo "$_LANG_How_many_days_the_user_can_change_password $_LANG_must_in_number" | main.sbin output_json 1) || exit 1
chage -m $FORM_passwd_min $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "passwd_min $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_passwd_max" ]
then
(echo "$FORM_passwd_max" | main.sbin regx_str islang_alb || echo "$_LANG_Password_expiration_days_must_in_number" | main.sbin output_json 1) || exit 1
chage -M $FORM_passwd_max $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "passwd_max $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ -n "$FORM_passwd_notice_days" ]
then
(echo "$FORM_passwd_notice_days" | main.sbin regx_str islang_alb || echo "$_LANG_Notice_before_password_expiration_days_must_in_number" | main.sbin output_json 1) || exit 1
chage -W $FORM_passwd_notice_days $FORM_username >/dev/null 2>&1
[ $? -eq 0 ] || echo "passwd_notice_days $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi

if
[ "$FORM_passwd_lock" = "lock" ]
then
usermod -L $FORM_username
else
usermod -U $FORM_username
fi

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
				desc="_NOTICE_do_useredit" \
				detail="_NOTICE_do_useredit_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"oldusername\":\"$FORM_oldusername\", \
						\"old_user_uid\":\"$old_user_uid\", \
						\"old_user_gid\":\"$old_user_gid\", \
						\"old_user_home\":\"$old_user_home\", \
						\"old_user_shell\":\"$old_user_shell\", \
						\"old_user_group\":\"$old_user_group\", \
						\"old_user_sgroups\":\"$old_user_sgroups\", \
						\"old_user_passwd_encypt\":\"`echo $old_user_passwd_encypt | tr '$' '_' | sed 's/_/\[S\]/g'`\", \
						\"old_user_passwd_min\":\"$old_user_passwd_min\", \
						\"old_user_passwd_max\":\"$old_user_passwd_max\", \
						\"old_passwd_notice_days\":\"$old_passwd_notice_days\", \
						\"old_inactive_days_after_expir\":\"$old_inactive_days_after_expir\", \
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
					}" >/tmp/1 2>&1

echo "$_LANG_Successful" | main.sbin output_json 0 || exit 0
}

deluser()
{
_LANG_App_name="$_LANG_App_name -> $_LANG_Del $_LANG_Username: $FORM_username"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<'EOF'
<script>
$(function(){
  $('#do_deluser').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF

cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF


cat <<EOF
<legend>$_LANG_Confirm_to_del $_LANG_Username $FORM_username ?</legend>
<div class="row">
<div class="col-md-6">
<form id="do_deluser" class="form-inline">
<input type="checkbox" selected="" name="home_n_files" value="1">$_LANG_Delete_all_the_files_in_the_home_directory_and_below
<input type="hidden" name="action" value="do_deluser">
<input type="hidden" name="username" value="$FORM_username">
<button class="btn btn-danger" id="_submit" type="submit">$_LANG_Del</button>
</form>
</div>
<div class="col-md-6">
<a class="btn btn-info" href="index.cgi?app=sysusers">$_LANG_Back</a>
</div>
</div>
EOF
cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"
}
do_deluser()
{
grep -q "^$FORM_username:" /etc/passwd || echo "用户不存在" | main.sbin output_json 1 || exit 1
if
[ "$FORM_home_n_files" = "1" ]
then
result=`userdel -rf $FORM_username | tr '\n' '.' 2>&1`
else
result=`userdel $FORM_username | tr '\n' '.' 2>&1`
fi
if
[ $? -eq 0 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_deluser" \
				detail="_NOTICE_do_deluser" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"username\":\"$FORM_username\" \
					}" >/tmp/1 2>&1

echo "$_LANG_Del $_LANG_Successful" | main.sbin output_json 0 || exit 0
else
echo "$result" | main.sbin output_json 1 || exit 1
fi
}
