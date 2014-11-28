#!/bin/sh

cat <<EOF
	<form id="path_setting">
		<div class="row">
			<div class="col-md-4">
			user_config_dir
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path" name="user_config_dir" value="$user_config_dir">
			</div>
			<div class="col-md-4">
			#定义用户配置文件的目录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
			local_root
			</div>
			<div class="col-md-4">
				<input type="text" class="form-control" placeholder="Enter Path" name="local_root" value="$local_root">
			</div>
			<div class="col-md-4">
			#此项设置每个用户登陆后其根目录为/home/username/webdisk.#定义本地用户登陆的根目录,注意定义根目录可以是相对路径也可以是绝对路径.相对路径是针对用户家目录
			</div>
		</div>

		<div class="row">
			<div class="col-md-4">
				<input type="hidden" name="action" value="path_setting">
				<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
			</div>
		</div>
	</form>

EOF