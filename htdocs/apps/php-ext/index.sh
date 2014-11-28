#!/bin/sh

main()
{

check_php_ext_installed || warning
cat <<'EOF'
<script>
$(function(){
  $('#save_php_ext_setting').on('submit', function(e){
    e.preventDefault();
    var data = "app=php-ext&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout(function(){
	phpinfo.window.location.reload();
	},2000)
  });
});
$(function(){
  $('#save_php_opcache_conf').on('submit', function(e){
    e.preventDefault();
    var data = "app=php-ext&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#save_php_xcache_conf').on('submit', function(e){
    e.preventDefault();
    var data = "app=php-ext&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF

cat <<EOF
<div class="container">
	<div class="col-md-3">
	  <div class="row">
		<label>PHP extension</label>
		<form id="save_php_ext_setting">
		<table class="table">
		<tr><th>extension</th><th>enabled</th></tr>
		<tr><td>imagick</td><td><input type="checkbox" name="imagick" value="1" `grep -Eq "^extension[ ]*=[ ]*.*imagick.so" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>magickwand</td><td><input type="checkbox" name="magickwand" value="1" `grep -Eq "^extension[ ]*=[ ]*.*magickwand.so" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>memcache</td><td><input type="checkbox" name="memcache" value="1" `grep -Eq "^extension[ ]*=[ ]*.*memcache.so" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>igbinary</td><td><input type="checkbox" name="igbinary" value="1" `grep -Eq "^extension[ ]*=[ ]*.*igbinary.so" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>redis</td><td><input type="checkbox" name="redis" value="1" `grep -Eq "^extension[ ]*=[ ]*.*redis.so" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>opcache</td><td><input type="checkbox" name="opcache" value="1" `grep -Eq "^zend_extension[ ]*=.*opcache" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>xcache</td><td><input type="checkbox" name="xcache" value="1" `grep -Eq "^extension[ ]*=.*xcache" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr><td>ioncube</td><td><input type="checkbox" name="ioncube" value="1" `grep -Eq "^zend_extension[ ]*=.*ioncube" /usr/local/php/etc/php.ini && echo checked`></td></tr>
		<tr>
		<td>Option</td>
		<td>
		<input type="hidden" name="action" value="save_php_ext_setting">
		<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</tr>
		</table>
		</form>
	  </div>
	  <div class="row">
		<form id="save_php_opcache_conf">
		<label>OPcache TPL</label>
		<textarea style="width:100%;height:260px" name="php_opcache_conf" class="bg-warning">`cat $DOCUMENT_ROOT/apps/php-ext/opcache.conf`</textarea>
		<input type="hidden" name="action" value="save_php_opcache_conf">
		<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</form>
		<form id="save_php_xcache_conf">
		<label>xcache TPL</label>
		<textarea style="width:100%;height:260px" name="php_xcache_conf" class="bg-warning">`cat $DOCUMENT_ROOT/apps/php-ext/xcache.conf`</textarea>
		<input type="hidden" name="action" value="save_php_xcache_conf">
		<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
		</form>
	  </div>
	</div>
	<div class="col-md-9">
	<legend>php-cli info</legend>
	<iframe src="/index.cgi?app=php&action=php_info" id="phpinfo" frameborder="0" scrolling="yes" width="100%" style="min-height:800px"></iframe>
	</div>
</div>

EOF
}
warning()
{
cat <<EOF
<div class="container">
<div class="modal fade" id="fix_Modal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_PS_Install_PHP_ext</h4>
      </div>
      <div class="modal-body" style="overflow-y: auto;height: 480px;">
		<p id="fix_content"></p>
      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
		<input type="hidden" name="action">
        <button type="button" href="javascript:;" class="btn btn-info" id="install_php_ext" data-loading-text="Loading...">$_LANG_Install_or_View_Progress</button>
      </div>
    </div>
  </div>
</div>

	<div class="col-md-10">
	<p class="bg-danger">$_LANG_PHP_ext_binary_need_install<p>
	</div>
	<div class="col-md-2">
<a class="btn btn-info" href="javascript:;" id="fixer">$_LANG_Fixer</a>
	</div>
</div>
EOF
cat <<'EOF'
<script>
$('#fixer').on('click', function(){
	var url = 'index.cgi?app=php-ext&action=pre_install_php_ext';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
});

function do_install_php_ext()
{
var url = 'index.cgi?app=php-ext&action=install_php_ext';
	Ha.common.ajax(url, 'html', '', 'get', 'applist', function(data){
		$('#fix_content').html(data);
		$('#fix_Modal').modal('show');
	}, 1);
}
$('#install_php_ext').on('click', function(){
var $btn = $(this);
    $btn.button('loading');

	setInterval("do_install_php_ext()", 5000);

});
</script>
EOF
}
lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
. $DOCUMENT_ROOT/apps/php-ext/php_ext_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi