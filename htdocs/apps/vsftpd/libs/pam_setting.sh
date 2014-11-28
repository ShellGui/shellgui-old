#!/bin/sh

cat <<EOF
	<form id="pam_auth_setting">
		<div class="row">
			<div class="col-md-4">
			guest_enable
			</div>
			<div class="col-md-4">
				<select name="guest_enable" class="form-control">
				  <option value="NO" `[ "$guest_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$guest_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#启用虚拟用户。默认值为NO
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pam_service_name
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path to File" name="pam_service_name" value="`[ -n "$pam_service_name" ] && echo "$pam_service_name" || echo "$vsftpd_config_dir/pam.d/vsftpd"`">
			</div>
			<div class="col-md-4">
			#设置PAM使用的名称，默认值为$vsftpd_config_dir/pam.d/vsftpd。
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			guest_username
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Username" name="guest_username" value="`[ -n "$guest_username" ] && echo "$guest_username" || echo "ftp"`">
			</div>
			<div class="col-md-4">
			#这里用来映射虚拟用户。默认值为ftp
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			virtual_use_local_privs
			</div>
			<div class="col-md-4">
				<select name="virtual_use_local_privs" class="form-control">
				  <option value="NO" `[ "$virtual_use_local_privs" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$virtual_use_local_privs" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#当此参数关闭（NO）时，虚拟用户使用与匿名用户相同的权限。默认情况下此参数是关闭的（NO）。
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="pam_auth_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF