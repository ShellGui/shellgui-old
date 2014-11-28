#!/bin/sh

cat <<EOF
	<form id="local_user_setting">
		<div class="row">
			<div class="col-md-4">
				local_umask
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Seceds" name="local_umask" value="`[ -n "$local_umask" ] && echo "$local_umask" || echo "077"`">  
			</div>
			<div class="col-md-4">		
			#本地用户上传文件的umask
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				local_root
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path" name="local_root" value="$local_root">
			</div>
			<div class="col-md-4">
			#设置一个本地用户登录后进入到的目录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				user_config_dir
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path" name="user_config_dir" value="$user_config_dir">
			</div>
			<div class="col-md-4">
			#设置用户的单独配置文件，用哪个帐户登陆就用哪个帐户命名
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			download_enable
			</div>
			<div class="col-md-4">
				<select name="download_enable" class="form-control">
				  <option value="YES" `[ "$download_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$download_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			限制用户的下载权限
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				chroot_list_file
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path to File" name="chroot_list_file" value="`[ -n "$chroot_list_file" ] && echo "$chroot_list_file" || echo "$vsftpd_config_dir/vsftpd.chroot_list"`">
			</div>
			<div class="col-md-4">
				#指定限制的用户文件,里面的用户将被chroot
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				chroot_list_enable
			</div>
			<div class="col-md-4">
				<select name="chroot_list_enable" class="form-control">
				  <option value="NO" `[ "$chroot_list_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$chroot_list_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#指定限制的用户文件,里面的用户将被chroot,如果启动这项功能，则所有列在 chroot_list_file 之中的使用者不能更改根目录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				check_shell
			</div>
			<div class="col-md-4">
				<select name="check_shell" class="form-control">
				  <option value="YES" `[ "$check_shell" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$check_shell" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#是否检查用户有一个有效的shell来登录		
			</div>
		</div>
		
		<div class="row">
		1、当chroot_list_enable=YES，chroot_local_user=YES时，在 $vsftpd_config_dir/vsftpd.chroot_list文件中列出的用户，可以切换到其他目录；未在文件中列出的用户，不能切换到其他目录。 2、当chroot_list_enable=YES，chroot_local_user=NO时，在$vsftpd_config_dir/vsftpd.chroot_list 文件中列出的用户，不能切换到其他目录；未在文件中列出的用户，可以切换到其他目录。 3、当chroot_list_enable=NO，chroot_local_user=YES时，所有的用户均不能切换到其他目录。 4、当chroot_list_enable=NO，chroot_local_user=NO时，所有的用户均可以切换到其他目录。
		</div>

		<div class="row">
			<div class="col-md-4">
				cmds_allowed
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Umask" name="cmds_allowed" value="$cmds_allowed">
			</div>
			<div class="col-md-4">
	如果启动这项功能，则所有列在chroot_list_file之中的使用者不能更改根目录
	1、只能上传。不能下载、删除、重命名
	FEAT,REST,CWD,LIST,MDTM,MKD,NLST,PASS,PASV,PORT,PWD,QUIT,RMD,SIZE,STOR,TYPE,USER,ACCT,APPE,CDUP,HELP,MODE,NOOP,REIN,STAT,STOU,STRU,SYST
	2.只能下载、删除、重命名。不能上传
	write_enable=NO
	3、只能上传、删除、重命名。不能下载。
	download_enable＝NO
	4、只能下载、删除、重命名。不能上传
	FEAT,REST,CWD,LIST,MDTM,MKD,NLST,PASS,PASV,PORT,PWD,QUIT,RMD,RNFR,RNTO,RETR,DELE,SIZE,TYPE,USER,ACCT,APPE,CDUP,HELP,MODE,NOOP,REIN,STAT,STOU,STRU,SYST
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="local_user_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>  

EOF