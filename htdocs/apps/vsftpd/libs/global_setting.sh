#!/bin/sh
cat <<EOF
	<form id="global_setting">
		<div class="row">
			<div class="col-md-4">
			listen_port
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Port" name="listen_port" value="`[ -n "$listen_port" ] && echo "$listen_port" || echo "21"`">
			</div>
			<div class="col-md-4">
			#从21端口进行数据连接
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anonymous_enable
			</div>
			<div class="col-md-4">
				<select name="anonymous_enable" class="form-control">
				  <option value="YES" `[ "$anonymous_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$anonymous_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#是否启用匿名用户
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				local_enable
			</div>
			<div class="col-md-4">
				<select name="local_enable" class="form-control">
				  <option value="NO" `[ "$local_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$local_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#启用Unix用户登录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				ssl_enable
			</div>
			<div class="col-md-4">
				<select name="ssl_enable" class="form-control">
				  <option value="NO" `[ "$ssl_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$ssl_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#是否启用ssl(sftp)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				write_enable
			</div>
			<div class="col-md-4">
				<select name="write_enable" class="form-control">
				  <option value="NO" `[ "$write_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$write_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#全局可写
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				chown_uploads
			</div>
			<div class="col-md-4">
				<select name="chown_uploads" class="form-control">
				  <option value="NO" `[ "$chown_uploads" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$chown_uploads" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#所有匿名上传的文件的所属用户将会被更改成chown_username
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				chown_username
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter username" name="chown_username" value="$chown_username">
			</div>
			<div class="col-md-4">
			#匿名上传文件所属用户名
			</div>
		</div>
		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="global_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>  
EOF