#!/bin/sh

editgroup()
{

group_str=`cat /etc/group`
gid=`echo "$group_str" | grep "^$FORM_groupname:" | awk -F ":" {'print $3'}`

_LANG_App_name="$_LANG_App_name -> $_LANG_Edit Group: $FORM_groupname"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"
cat <<'EOF'
<script>
$(function(){
  $('#do_groupedit').on('submit', function(e){
    e.preventDefault();
    var data = "app=sysusers&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#delgrouppasswd').on('click', function(e){
    e.preventDefault();
EOF
cat <<EOF
    if (confirm('$_LANG_Do_you_confirm_to_del_user_password')) {
      var data = "app=sysusers&action=do_delgrouppass&groupname=$FORM_groupname";
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

cat <<EOF
<form id="do_groupedit">
<legend>$_LANG_Edit Group: $FORM_groupname</legend>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Group_name
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="groupname" placeholder="groupname" value="$FORM_groupname">
  </div>
  <div class="col-xs-6">
  <p class="bg-danger">$_LANG_Groupname_Can_not_be_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  gid
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="gid" placeholder="gid" value="$gid">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_System_will_automatically_assign_gid_when_it_empty</p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Password
  </div>
  <div class="col-xs-4">
  <input class="form-control" type="text" name="password" placeholder="password"><p>
  <input class="form-control" type="text" name="password_cf" placeholder="password">
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_If_empty_no_change_password<button id="delgrouppasswd" type="button" class="btn btn-danger">$_LANG_Del_Group_Password</button></p>
  </div>
</div>
<div class="row">
  <div class="col-xs-2">
  $_LANG_Option
  </div>
  <div class="col-xs-4">
  <input type="hidden" name="action" value="do_groupedit">
  <input type="hidden" name="oldgroup" value="$FORM_groupname">
  <button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
  </div>
  <div class="col-xs-6">
  <p class="bg-success">$_LANG_Do_save</p>
  </div>
</div>
</form>
EOF

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"
}
do_delgrouppass()
{
[ "$FORM_groupname" != "root" ] || echo "$_LANG_Can_not_del_root_password" | main.sbin output_json 1 || exit 1
gpasswd -r $FORM_groupname >/dev/null 2>&1
if
[ $? -eq 0 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_delgrouppass" \
				detail="_NOTICE_do_delgrouppass" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"groupname\":\"$FORM_groupname\" \
					}" >/dev/null 2>&1

echo "$_LANG_Successfully_remove_the_password" | main.sbin output_json 0 || exit 0
else
echo "$_LANG_Fails_remove_the_password" | main.sbin output_json 1 || exit 1
fi
}
do_groupedit()
{
# FORM_groupname=zxc
# FORM_app=sysusers
# FORM_oldgroup=zxc
# FORM_password=asd
# FORM_gid=10003
[ -n "$FORM_groupname" ] || echo "$_LANG_Groupname_Can_not_be_empty" | main.sbin output_json 1 || exit 1

old_group_str=`cat /etc/group | grep "^$FORM_oldgroup:"`
old_group_shadow=`cat /etc/gshadow | grep "^$FORM_oldgroup:"`
old_group_gid=`echo "$old_group_str" | awk -F ":" {'print $3'}`
old_group_passwd_encypt=`echo "$old_group_shadow" | awk -F ":" {'print $2'}`

if
cat /etc/passwd | awk -F ":" {'print $1'} | grep -v "^$FORM_oldgroup$" | grep -q "^$FORM_groupname$"
then
echo "$_LANG_Group_name_already_exists" | main.sbin output_json 1 || exit 1
fi
if
[ "$FORM_oldgroup" != "$FORM_groupname" ]
then
(echo "$FORM_groupname" | main.sbin regx_str islang_enalb || echo "$_LANG_Groupname_must_be_in_Eng_or_Eng_with_number" | main.sbin output_json 1) || exit 1
[ $(expr length $(echo "$FORM_groupname")) -le 8 ] || echo "$_LANG_Length_of_Groupname_must_be_shorter_than_8_characters" | main.sbin output_json 1 || exit 1
groupmod -n $FORM_groupname $FORM_oldgroup >/dev/null 2>&1
[ $? -eq 0 ] || echo "$_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi
if
[ -n "$FORM_gid" ]
then
(echo "$FORM_gid" | main.sbin regx_str islang_alb || echo "$_LANG_gid_must_be_number" | main.sbin output_json 1) || exit 1
([ $FORM_gid -le 60000 ] || echo "uid不能超过60000" | main.sbin output_json 1) || exit 1
groupmod -g $FORM_gid $FORM_groupname >/dev/null 2>&1
[ $? -eq 0 ] || echo "gid $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi
[ "$FORM_password" = "$FORM_password_cf" ] || echo "$_LANG_Enter_the_password_confirm_inconsistent" | main.sbin output_json 1 || exit 1
if
[ -n "$FORM_password" ]
then
[ $(expr length $(echo "$FORM_password")) -ge 6 ] || echo "$_LANG_Password_length_must_be_greater_than_6_characters" | main.sbin output_json 1 || exit 1
expect <<EOF >/dev/null 2>&1
  set timeout -1
  spawn gpasswd ${FORM_groupname}
  expect "New" {
    send "${FORM_password}\r" 
    expect "Re-enter " {
      send "${FORM_password}\r"
      expect "# " ;exit 0
    }
  } timeout {
    exit 1
  }
EOF
[ $? -eq 0 ] || echo "Password $_LANG_An_unknown_error_happens" | main.sbin output_json 1 || exit 1
fi
new_group_str=`cat /etc/group | grep "^$FORM_groupname:"`
new_group_shadow=`cat /etc/gshadow | grep "^$FORM_groupname:"`
new_group_gid=`echo "$new_group_str" | awk -F ":" {'print $3'}`
new_group_passwd_encypt=`echo "$new_group_shadow" | awk -F ":" {'print $2'}`

main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_groupedit" \
				detail="_NOTICE_do_groupedit_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"oldgroupname\":\"$FORM_oldgroup\", \
						\"old_group_gid\":\"$old_group_gid\", \
						\"old_group_passwd_encypt\":\"`echo $old_group_passwd_encypt | tr '$' '_' | sed 's/_/\[S\]/g'`\", \
						\"newgroupname\":\"$FORM_groupname\", \
						\"new_group_gid\":\"$new_group_gid\", \
						\"new_group_passwd_encypt\":\"`echo $new_group_passwd_encypt | tr '$' '_' | sed 's/_/[S\]/g'`\" \
					}" >/dev/null 2>&1

echo "$_LANG_Successful" | main.sbin output_json 0 || exit 0

}

delgroup()
{
_LANG_App_name="$_LANG_App_name -> $_LANG_Del Group: $FORM_groupname"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<'EOF'
<script>
$(function(){
  $('#do_delgroup').on('submit', function(e){
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
<legend>$_LANG_Confirm_to_del $_LANG_Group $FORM_groupname ?</legend>
<div class="row">
<div class="col-md-6">
<form id="do_delgroup" class="form-inline">
<input type="hidden" name="action" value="do_delgroup">
<input type="hidden" name="groupname" value="$FORM_groupname">
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
do_delgroup()
{
grep -q "^$FORM_groupname:" /etc/group || echo "$_LANG_Groupname_no_exist" | main.sbin output_json 1 || exit 1

result=`groupdel $FORM_groupname | tr '\n' '.' 2>&1`

if
[ $? -eq 0 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_do_delgroup" \
				detail="_NOTICE_do_delgroup" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="sysusers" \
				dest_type="app" \
					variable="{\
						\"groupname\":\"$FORM_groupname\" \
					}" >/dev/null 2>&1
echo "$_LANG_Del $_LANG_Successful" | main.sbin output_json 0 || exit 0
else
echo "$result" | main.sbin output_json 1 || exit 1
fi
}

