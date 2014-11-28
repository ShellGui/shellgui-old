#!/bin/sh

cat <<EOF
	<form id="transfer_setting">
		<div class="row">
			<div class="col-md-4">
			anon_max_rate
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Rate" name="anon_max_rate" value="`[ -n "$anon_max_rate" ] && echo "$anon_max_rate" || echo "0"`">
			</div>
			<div class="col-md-4">
			#匿名用户的传输比率(b/s) Default: 0 (unlimited)
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
			#本地用户的传输比率(b/s) Default: 0 (unlimited)
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="transfer_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF