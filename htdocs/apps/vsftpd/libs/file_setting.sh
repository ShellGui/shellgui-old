#!/bin/sh

cat <<EOF
<form id="file_setting">
	<div class="row">
		<div class="col-md-4">
		chroot_list_file
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Path to File" name="chroot_list_file" value="`[ -n "$chroot_list_file" ] && echo "$chroot_list_file" || echo "$vsftpd_config_dir/vsftpd.chroot_list"`">
		</div>
		<div class="col-md-4">
		#定义不能更改用户主目录的文件 
		</div>
	</div>

	<div class="row">
		<div class="col-md-4">
		userlist_file
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Path to File" name="userlist_file" value="`[ -n "$userlist_file" ] && echo "$userlist_file" || echo "$vsftpd_config_dir/ftpusers"`">
		</div>
		<div class="col-md-4">
		#定义限制/允许用户登录的文件
		</div>
	</div>

	<div class="row">
		<div class="col-md-4">
		banned_email_file
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Path to File" name="banned_email_file" value="`[ -n "$banned_email_file" ] && echo "$banned_email_file" || echo "$vsftpd_config_dir/vsftpd.banned_emails"`">
		</div>
		<div class="col-md-4">
		#禁止使用的匿名用户登陆时作为密码的电子邮件地址
		</div>
	</div>

	<div class="row">
		<div class="col-md-4">
		xferlog_file
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Path to File" name="xferlog_file" value="`[ -n "$xferlog_file" ] && echo "$xferlog_file" || echo "/var/log/xferlog"`">
		</div>
		<div class="col-md-4">
		#日志文件位置
		</div>
	</div>

	<div class="row">
		<div class="col-md-4">
		message_file
		</div>
		<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Path to File" name="message_file" value="`[ -n "$message_file" ] && echo "$message_file" || echo ".message"`">
		</div>
		<div class="col-md-4">
		#目录信息文件
		</div>
	</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="file_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
</form>  

EOF
