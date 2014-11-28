#!/bin/sh

cat <<EOF
	<form id="anonymous_setting">

		<div class="row">
			<div class="col-md-4">
				no_anon_password
			</div>
			<div class="col-md-4">
				<select name="no_anon_password" class="form-control">
				  <option value="NO" `[ "$no_anon_password" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$no_anon_password" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#匿名用户login时不询问口令
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anon_root
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path" name="anon_root" value="$anon_root">
			</div>
			<div class="col-md-4">
			#匿名用户主目录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anon_max_rate
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Rate" name="anon_max_rate" value="$anon_max_rate">
			</div>
			<div class="col-md-4">
			#匿名用户速度限制
			</div>
		</div>
			
		<div class="row">
			<div class="col-md-4">
				anon_umask
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Umask" name="anon_umask" value="`[ -n "$anon_umask" ] && echo "$anon_umask" || echo "077"`">
			</div>
			<div class="col-md-4">
			#匿名用户上传文件时有掩码(若想让匿名用户上传的文件能直接被匿名下载，就这设置这里为073)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anon_upload_enable
			</div>
			<div class="col-md-4">	
				<select name="anon_upload_enable" class="form-control">
				  <option value="NO" `[ "$anon_upload_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$anon_upload_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#控制匿名用户对文件（非目录）上传权限
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anon_world_readable_only
			</div>
			<div class="col-md-4">
				<select name="anon_world_readable_only" class="form-control">
				  <option value="YES" `[ "$anon_world_readable_only" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$anon_world_readable_only" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#控制匿名用户对文件的下载权限
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				anon_mkdir_write_enable
			</div>
			<div class="col-md-4">
				<select name="anon_mkdir_write_enable" class="form-control">
				  <option value="NO" `[ "$anon_mkdir_write_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$anon_mkdir_write_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#控制匿名用户对文件夹的创建权限
			</div>
		</div>
			
		<div class="row">
			<div class="col-md-4">
				anon_other_write_enable
			</div>
			<div class="col-md-4">
				<select name="anon_other_write_enable" class="form-control">
				  <option value="NO" `[ "$anon_other_write_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$anon_other_write_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#控制匿名用户对文件和文件夹的删除和重命名
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="anonymous_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>  


EOF