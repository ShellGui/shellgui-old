#!/bin/sh

cat <<EOF
	<form id="security_setting">
		<div class="row">
			<div class="col-md-4">
			idle_session_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Time" name="idle_session_timeout" value="`[ -n "$idle_session_timeout" ] && echo "$idle_session_timeout" || echo "300"`">
			</div>
			<div class="col-md-4">
			#用户会话空闲后x秒
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			data_connection_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Time" name="data_connection_timeout" value="`[ -n "$data_connection_timeout" ] && echo "$idle_session_timeout" || echo "300"`">
			</div>
			<div class="col-md-4">
			#将数据连接空闲x秒断
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			accept_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Time" name="accept_timeout" value="`[ -n "$accept_timeout" ] && echo "$accept_timeout" || echo "60"`">
			</div>
			<div class="col-md-4">
			#将客户端空闲x秒后断
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			connect_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Time" name="connect_timeout" value="`[ -n "$connect_timeout" ] && echo "$connect_timeout" || echo "60"`">
			</div>
			<div class="col-md-4">
			#中断x秒后又重新连接
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			local_max_rate
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Rate" name="local_max_rate" value="`[ -n "$local_max_rate" ] && echo "$local_max_rate" || echo "0"`">
			</div>
			<div class="col-md-4">
			#本地用户传输率50K Default: 0 (unlimited)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			anon_max_rate
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Rate" name="anon_max_rate" value="`[ -n "$anon_max_rate" ] && echo "$anon_max_rate" || echo "0"`">
			</div>
			<div class="col-md-4">
			#匿名用户传输率30K Default: 0 (unlimited)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			max_clients
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Count" name="max_clients" value="`[ -n "$max_clients" ] && echo "$max_clients" || echo "0"`">
			</div>
			<div class="col-md-4">
			#FTP的最大连接数 Default: 0 (unlimited)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			max_per_ip
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Count" name="max_per_ip" value="`[ -n "$max_per_ip" ] && echo "$max_per_ip" || echo "0"`">
			</div>
			<div class="col-md-4">
			#每IP的最大连接数
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			allow_anon_ssl
			</div>
			<div class="col-md-4">
				<select name="allow_anon_ssl" class="form-control">
				  <option value="NO" `[ "$allow_anon_ssl" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$allow_anon_ssl" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#允许匿名用户使用ssl安全连接
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			force_local_data_ssl
			</div>
			<div class="col-md-4">
				<select name="force_local_logins_ssl" class="form-control">
				  <option value="YES" `[ "$force_local_data_ssl" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$force_local_data_ssl" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#强制本地用户使用ssl传输数据
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			force_local_logins_ssl
			</div>
			<div class="col-md-4">
				<select name="force_local_logins_ssl" class="form-control">
				  <option value="YES" `[ "$force_local_logins_ssl" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$force_local_logins_ssl" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#强制本地用户使用ssl登录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			ssl_tlsv1
			</div>
			<div class="col-md-4">
				<select name="ssl_tlsv1" class="form-control">
				  <option value="YES" `[ "$ssl_tlsv1" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$ssl_tlsv1" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#使用TLS v1
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			ssl_sslv2
			</div>
			<div class="col-md-4">
				<select name="ssl_sslv2" class="form-control">
				  <option value="YES" `[ "$ssl_sslv2" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$ssl_sslv2" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#使用ssl v2
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			ssl_sslv3
			</div>
			<div class="col-md-4">
				<select name="ssl_sslv3" class="form-control">
				  <option value="YES" `[ "$ssl_sslv3" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				  <option value="NO" `[ "$ssl_sslv3" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				</select>
			</div>
			<div class="col-md-4">
			#使用ssl v3
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			rsa_cert_file
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path to File" name="rsa_cert_file" value="`[ -n "$rsa_cert_file" ] && echo "$rsa_cert_file" || echo "/usr/share/ssl/certs/vsftpd.pem"`">
			</div>
			<div class="col-md-4">
			#rsa 公钥文件位置
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			rsa_private_key_file
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Count" name="rsa_private_key_file" value="`[ -n "$rsa_private_key_file" ] && echo "$rsa_private_key_file" || echo "$vsftpd_config_dir/config/vsftpd_privkey.pem"`">
			</div>
			<div class="col-md-4">
			#rsa 私钥文件位置
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="security_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF
