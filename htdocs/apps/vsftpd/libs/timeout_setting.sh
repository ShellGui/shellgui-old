#!/bin/sh

cat <<EOF
	<form id="timeout_setting">
		<div class="row">
			<div class="col-md-4">
			idle_session_timeout
			</div>
			<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Seceds" name="idle_session_timeout" value="`[ -n "$idle_session_timeout" ] && echo "$idle_session_timeout" || echo "300"`">
			</div>
			<div class="col-md-4">
			#空闲连接超时
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			data_connection_timeout
			</div>
			<div class="col-md-4">
			<input type="text" class="form-control" placeholder="Enter Seceds" name="data_connection_timeout" value="`[ -n "$data_connection_timeout" ] && echo "$data_connection_timeout" || echo "300"`"> 
			</div>
			<div class="col-md-4">
			#数据传输超时
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			accept_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Seceds" name="accept_timeout" value="`[ -n "$accept_timeout" ] && echo "$accept_timeout" || echo "60"`"> 
			</div>
			<div class="col-md-4">
			#PAVS请求超时
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			connect_timeout
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Seceds" name="connect_timeout" value="`[ -n "$connect_timeout" ] && echo "$connect_timeout" || echo "60"`">  
			</div>
			<div class="col-md-4">
			#PROT模式连接超时
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="timeout_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF