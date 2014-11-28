#!/bin/sh

cat <<EOF
	<form id="access_control_setting">
		<div class="row">
			<div class="col-md-4">
			tcp_wrappers
			</div>
			<div class="col-md-4">
				<select name="tcp_wrappers" class="form-control">
				  <option value="NO" `[ "$tcp_wrappers" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$tcp_wrappers" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			控制主机访问：
			设置vsftpd是否与tcp wrapper相结合来进行主机的访问控制。默认值为YES。如果启用，则vsftpd服务器会检查/etc/hosts.allow 和/etc/hosts.deny 中的设置，来决定请求连接的主机，是否允许访问该FTP服务器。这两个文件可以起到简易的防火墙功能。
		比如：若要仅允许192.168.10.1—192.168.10.254的用户可以连接FTP服务器，
		则在 /etc/hosts.allow /etc/hosts.deny 文件中添加以下内容：
		其格式如下：
		限制的服务：ip(网段) vsftpd:192.168.1. vsftpd:192.168.1.12 vsftpd:192.168.1.0/255.255.255.0这里不能写成192.168.1.0/24
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			$vsftpd_config_dir/ftpusers
			</div>
			<div class="col-md-4">
				<textarea style="width:100%;height:140px" name="vsftpd_user_list" placeholder="root" class="bg-warning">`cat $vsftpd_config_dir/ftpusers`</textarea>
			</div>
			<div class="col-md-4">
			#用于保存不允许进行FTP登录的本地用户帐号。就是vsftp用户的黑名单
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			userlist_enable
			</div>
			<div class="col-md-4">
				<select name="userlist_enable" class="form-control">
				  <option value="NO" `[ "$userlist_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$userlist_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			1.userlist_enable=yes userlist_deny=yes 说明：配置完以后，除了vsftpd.ftpusers文件和vsftpd.user_list文件中记录的ftp用户不能登录vsftp服务以外，其他的ftp用户都可以登录
			2.userlist_enable=yes userlist_deny=no  说明：配置完以后，只允许vsftpd.user_list文件中记录的ftp用户能登录vsftp服务，其他的ftp用户都不可以登录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			userlist_deny
			</div>
			<div class="col-md-4">
				<select name="userlist_deny" class="form-control">
				  <option value="NO" `[ "$userlist_deny" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$userlist_deny" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			同上
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="access_control_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>  

EOF