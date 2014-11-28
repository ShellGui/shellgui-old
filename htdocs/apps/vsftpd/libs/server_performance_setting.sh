#!/bin/sh

cat <<EOF
	<form id="server_performance_setting">
		<div class="row">
			<div class="col-md-4">
			ls_recurse_enable
			</div>
			<div class="col-md-4">
				<select name="ls_recurse_enable" class="form-control">
				  <option value="NO" `[ "$ls_recurse_enable" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$ls_recurse_enable" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#是否能使用ls -R命令以防止浪费大量的服务器资源
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			one_process_model
			</div>
			<div class="col-md-4">
				<select name="one_process_model" class="form-control">
				  <option value="NO" `[ "$one_process_model" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$one_process_model" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#是否使用单进程模式
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			listen
			</div>
			<div class="col-md-4">
				<select name="listen" class="form-control">
				  <option value="YES" `[ "$listen" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$listen" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#绑定到listen_port指定的端口,既然都绑定了也就是每时都开着的,就是那个什么standalone模式
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			text_userdb_names
			</div>
			<div class="col-md-4">
				<select name="text_userdb_names" class="form-control">
				  <option value="NO" `[ "$text_userdb_names" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$text_userdb_names" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#当使用者登入后使用ls -al 之类的指令查询该档案的管理权时，预设会出现拥有者的UID，而不是该档案拥有者的名.若是希望出现拥有者的名称，则将此功能开启。
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			use_localtime
			</div>
			<div class="col-md-4">
				<select name="use_localtime" class="form-control">
				  <option value="NO" `[ "$use_localtime" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$use_localtime" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#显示目录清单时是用本地时间还是GMT时间,可以通过mdtm命令来达到一样的效果
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			use_sendfile
			</div>
			<div class="col-md-4">
				<select name="use_sendfile" class="form-control">
				  <option value="YES" `[ "$use_sendfile" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$use_sendfile" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#测试平台优化
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="server_performance_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF