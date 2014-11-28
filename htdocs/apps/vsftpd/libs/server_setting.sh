#!/bin/sh

cat <<EOF
	<form id="server_setting">
		<div class="row">
			<div class="col-md-4">
			xferlog_enable
			</div>
			<div class="col-md-4">
				<select name="xferlog_enable" class="form-control">
				  <option value="NO" `[ "$xferlog_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$xferlog_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#开启日记功能
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-4">
			xferlog_std_format
			</div>
			<div class="col-md-4">
				<select name="xferlog_std_format" class="form-control">
				  <option value="NO" `[ "$xferlog_std_format" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$xferlog_std_format" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#使用标准格式 
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			log_ftp_protocol
			</div>
			<div class="col-md-4">
				<select name="log_ftp_protocol" class="form-control">
				  <option value="NO" `[ "$log_ftp_protocol" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$log_ftp_protocol" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#当xferlog_std_format关闭且本选项开启时,记录所有ftp请求和回复,当调试比较有用
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pasv_enable
			</div>
			<div class="col-md-4">
				<select name="pasv_enable" class="form-control">
				  <option value="YES" `[ "$pasv_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$pasv_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#允许使用pasv模式
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pasv_promiscuous
			</div>
			<div class="col-md-4">
				<select name="pasv_promiscuous" class="form-control">
				  <option value="NO" `[ "$pasv_promiscuous" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$pasv_promiscuous" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#关闭安全检查,小心呀
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			port_enable
			</div>
			<div class="col-md-4">
				<select name="port_enable" class="form-control">
				  <option value="YES" `[ "$port_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$port_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#允许使用port模式
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			nopriv_user
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Username" name="nopriv_user" value="`[ -n "$nopriv_user" ] && echo "$nopriv_user" || echo "nobody"`"> 
			</div>
			<div class="col-md-4">
			#当服务器运行于最底层时使用的用户名
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pasv_address
			</div>
			<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter address" name="pasv_address" value="$pasv_address"> 
			</div>
			<div class="col-md-4">
			#使vsftpd在pasv命令回复时跳转到指定的IP地址.(服务器联接跳转?)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="server_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF