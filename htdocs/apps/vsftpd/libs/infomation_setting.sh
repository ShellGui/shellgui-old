#!/bin/sh

cat <<EOF
	<form id="infomation_setting">
		<div class="row">
			<div class="col-md-4">
			ftpd_banner
			</div>
			<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter String" name="ftpd_banner" value="$ftpd_banner">
			</div>
			<div class="col-md-4">
			#login时显示欢迎信息.如果设置了banner_file则此设置无效 
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			banner_file
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path to File" name="banner_file" value="$banner_file">
			</div>
			<div class="col-md-4">
			#login时显示欢迎信息.
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			dirmessage_enable
			</div>
			<div class="col-md-4">
				<select name="dirmessage_enable" class="form-control">
				  <option value="NO" `[ "$dirmessage_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$dirmessage_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#允许为目录配置显示信息,显示每个目录下面的message_file文件的内容 
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			setproctitle_enable
			</div>
			<div class="col-md-4">
				<select name="setproctitle_enable" class="form-control">
				  <option value="NO" `[ "$setproctitle_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$setproctitle_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			 #显示会话状态信息,关!
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="infomation_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>  

EOF
