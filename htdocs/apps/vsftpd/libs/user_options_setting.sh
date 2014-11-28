#!/bin/sh

cat <<EOF
	<form id="user_options_setting">
		<div class="row">
			<div class="col-md-4">
			max_clients
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Umask" name="max_clients" value="`[ -n "$max_clients" ] && echo "$max_clients" || echo "0"`">
			</div>
			<div class="col-md-4">
			#可接受的最大client数目,0为不限
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			max_per_ip
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Number" name="max_per_ip" value="`[ -n "$max_per_ip" ] && echo "$max_per_ip" || echo "0"`">
			</div>
			<div class="col-md-4">
			#每个ip的最大client数目,0为不限
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			connect_from_port_20
			</div>
			<div class="col-md-4">
				<select name="connect_from_port_20" class="form-control">
				  <option value="NO" `[ "$connect_from_port_20" = "NO" ] && echo "selected=\"selected\""`>$_LANG_No</option>
				  <option value="YES" `[ "$connect_from_port_20" = "YES" ] && echo "selected=\"selected\""`>$_LANG_Yes</option>
				</select>
			</div>
			<div class="col-md-4">
			#使用标准的20端口来连接ftp
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			listen_address
			</div>
			<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter IP" name="listen_address" value="$listen_address">
			</div>
			<div class="col-md-4">
			#绑定到某个IP,其它IP不能访问
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			ftp_data_port
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Port Number" name="ftp_data_port" value="`[ -n "$ftp_data_port" ] && echo "$ftp_data_port" || echo "20"`">
			</div>
			<div class="col-md-4">
			#数据传输端口 
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pasv_max_port
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Port Number" name="pasv_max_port" value="`[ -n "$pasv_max_port" ] && echo "$pasv_max_port" || echo "0"`">
			</div>
			<div class="col-md-4">
			#pasv连接模式时可以使用port 范围的上界，0 表示任意。默认值为0
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			pasv_min_port
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Port Number" name="pasv_min_port" value="`[ -n "$pasv_min_port" ] && echo "$pasv_min_port" || echo "0"`">
			</div>
			<div class="col-md-4">
			#pasv连接模式时可以使用port 范围的下界，0 表示任意。默认值为0
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="user_options_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF
