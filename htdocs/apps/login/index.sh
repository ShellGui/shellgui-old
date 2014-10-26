#!/bin/sh

main()
{
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
cat <<EOF
<style type="text/css">
body {
	padding-top: 100px;
	background-color: #f5f5f5;
}

.form-signin {
	max-width: 390px;
	padding: 19px 29px 29px;
	margin: 0 auto 20px;

	background-color: #fff;
	border: 1px solid #e5e5e5;
	-webkit-border-radius: 5px;
	   -moz-border-radius: 5px;
	        border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
	   -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
	        box-shadow: 0 1px 2px rgba(0,0,0,.05);
}

</style>
<!--[if lte IE 6]>
<style type="text/css">
body {
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #333;
}
.form-signin {
	width: 390px;
	padding: 19px 29px 29px;
	margin: 0 auto 20px;
	background-color: #fff;
	border: 1px solid #e5e5e5;
}
.form-horizontal .controls {
	margin-left: 10px;
}
.form-horizontal .text-error {
	margin-left: 90px;
}
</style>
<![endif]-->

<!--[if lt IE 9]>
  <script src="/common/js/html5shiv.js"></script>
<![endif]-->
<div class="container hwapper">
	<form class="form-signin form-horizontal" id="post_login_submit" method="post" action="index.cgi">
	  <fieldset>
	  <legend>$_LANG_Please_login</legend>
	  <div class="form-group info">
	    <label for="username" class="col-sm-3 control-label">$_LANG_Username</label>
	    <div class="col-sm-9">
	      <input type="text" class="form-control" id="username" name="username" placeholder="$_LANG_Username">
	    </div>
	  </div>

	  <div class="form-group info">
	    <label for="password" class="col-sm-3 control-label">$_LANG_Password</label>
	    <div class="col-sm-9">
	      <input type="password" class="form-control" id="password" name="password" placeholder="$_LANG_Password">
	    </div>
	  </div>

	  <div class="form-group info">
	    <label for="btnsubmit" class="col-sm-3 control-label">&nbsp;</label>
	    <div class="col-sm-9">
	      <input type="hidden" name="doSubmit" value="login">
	      <input type="hidden" name="app" value="login">
	      <input type="hidden" name="action" value="login">
	      <button type="submit" class="btn btn-large btn-primary" id="btnsubmit">$_LANG_Login</button>
	    </div>
	  </div>
	  </fieldset>
	</form>
</div>

EOF
}

[ -n "$FORM_username" ] && [ -n "$FORM_password" ] && if
main.sbin check_root_password user="$FORM_username" pass="$FORM_password" >/dev/null 2>&1
then
main.sbin create_admin_session
main.sbin header_jump "index.cgi?app=home"
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_adminer_login" \
				detail="_NOTICE_adminer_login_detail" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="sysusers" \
				dest_type="app" \
				variable="{\"username\":\"$FORM_username\",\"ip\":\"$REMOTE_ADDR\",\"user_agent\":\"$HTTP_USER_AGENT\"}" >/dev/null 2>&1

exit 0
else
main.sbin header_jump "index.cgi?app=login"
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_adminer_login_fail" \
				detail="_NOTICE_adminer_login_fail_detail" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="sysusers" \
				dest_type="app" \
				variable="{\"username\":\"$FORM_username\",\"wrong_passwd\":\"$FORM_password\",\"ip\":\"$REMOTE_ADDR\",\"user_agent\":\"$HTTP_USER_AGENT\"}" >/dev/null 2>&1
exit 0
fi

if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi
