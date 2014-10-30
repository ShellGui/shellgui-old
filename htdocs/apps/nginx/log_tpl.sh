log_tpl()
{
_LANG_App_name="$_LANG_App_name -> $_LANG_Log_TPL"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<'EOF'
<script>
$(function(){
  $('#log_tpl_save').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
$(function(){
  $('#newtpl').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
function del_log_tpl(logtpl)
{
EOF
cat <<EOF
  if (confirm("$_LANG_Do_you_want_to_del " + logtpl)) {
EOF
cat <<'EOF'
    var data = "app=nginx&action=del_log_tpl&logtpl="+logtpl;
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 1000);
  }
}
</script>
EOF
cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

cat <<EOF
<div class="col-md-6">
<form id="log_tpl_save">
EOF
for tplname in `ls $DOCUMENT_ROOT/apps/nginx/log_tpl`
do
cat <<EOF
<label>${tplname}<button type="button" onclick="del_log_tpl('${tplname}');" class="btn btn-danger">$_LANG_Del</button></label>
<textarea style="width:100%;height:140px" name="log_${tplname}" class="bg-warning">`cat $DOCUMENT_ROOT/apps/nginx/log_tpl/${tplname}`</textarea>
EOF
done

cat <<EOF
<input type="hidden" name="action" value="log_tpl_save">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>

<label>$_LANG_New_TPL</label>
<form id="newtpl">
<input type="text" name="tpl_name" class="form-control" placeholder="Enter tpl name">
<textarea style="width:100%;height:140px" name="log_detail" placeholder="Enter tpl" class="bg-warning"></textarea>
<input type="hidden" name="action" value="newtpl">
<button class="btn btn-primary" id="_submit" type="submit">$_LANG_Save</button>
</form>
EOF
cat <<EOF

</div>
<div class="col-md-6">

EOF
echo "$_LANG_Variable_desc"
cat <<EOF

</div>
EOF

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
log_tpl_save()
{
for log in `env | grep -Po "^FORM_log_.*=" | sed -e 's/.*_//' -e 's/=//'`
do
eval echo \"'$'FORM_log_${log}\" > $DOCUMENT_ROOT/apps/nginx/log_tpl/${log}
done
(echo "$_LANG_TPL_Save_Success" | main.sbin output_json 0) || exit 0
}
newtpl()
{
echo "$FORM_log_detail" >> $DOCUMENT_ROOT/apps/nginx/log_tpl/$FORM_tpl_name
(echo "$_LANG_TPL_Add_Success" | main.sbin output_json 0) || exit 0
}
del_log_tpl()
{
[ -f $DOCUMENT_ROOT/apps/nginx/log_tpl/$FORM_logtpl ] && rm -f $DOCUMENT_ROOT/apps/nginx/log_tpl/$FORM_logtpl
(echo "$_LANG_TPL_Del_Success" | main.sbin output_json 0) || exit 0
}