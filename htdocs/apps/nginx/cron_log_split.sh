#!/bin/sh


cron_log_split()
{
_LANG_App_name="$_LANG_App_name -> $_LANG_Cronjpb_log_split"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"


cat <<EOF
<div class="container hwapper" id="ajax-fluid"> <!--container-->
EOF


eval `cat $DOCUMENT_ROOT/apps/nginx/cron_log_split.conf`

cat <<'EOF'
<script>
$(function(){
  $('#do_cron_log_split').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
  });
});
</script>
EOF
cat <<EOF

<div class="col-md-6">

<form class="form-inline" role="form" id="do_cron_log_split">
<input type="text" class="form-control" name="count" placeholder="Number" value="$count">
<select class="form-control" name="cycle">
  <option value="" `[ -z "$cycle" ] && echo selected`>$_LANG_Close</option>
  <option value="minute" `[ "$cycle" = "minute" ] && echo selected`>$_LANG_minutes</option>
  <option value="hour" `[ "$cycle" = "hour" ] && echo selected`>$_LANG_hours</option>
  <option value="day" `[ "$cycle" = "day" ] && echo selected`>$_LANG_days</option>
  <option value="day_of_week" `[ "$cycle" = "day_of_week" ] && echo selected`>$_LANG_weeks</option>
  <option value="month" `[ "$cycle" = "month" ] && echo selected`>$_LANG_month</option>
</select>
<input type="hidden" name="action" value="do_cron_log_split">
<button type="submit" class="btn btn-primary">$_LANG_Save</button>
</form>

</div>


<div class="col-md-6">
$_LANG_Cronjpb_log_split_desc

</div>
EOF



cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"

}
do_cron_log_split()
{
echo $FORM_count | main.sbin regx_str islang_alb || (echo "Save Success" | main.sbin output_json 1) || exit 1
sed -i "s/^count=.*/count=$FORM_count/g" $DOCUMENT_ROOT/apps/nginx/cron_log_split.conf >/dev/null 2>&1
sed -i "s/^cycle=.*/cycle=$FORM_cycle/g" $DOCUMENT_ROOT/apps/nginx/cron_log_split.conf >/dev/null 2>&1

[ -n "$FORM_cycle" ] || (rm -f $DOCUMENT_ROOT/apps/nginx/root.cron && $DOCUMENT_ROOT/apps/scheduled/S300scheduled.init && echo "Close Success" | main.sbin output_json 0 ) || exit 0

case $FORM_cycle in
minute)
cat <<EOF > $DOCUMENT_ROOT/apps/nginx/root.cron
*/$FORM_count * * * * $DOCUMENT_ROOT/apps/nginx/nginx_log_split.sh
EOF
;;
hour)
cat <<EOF > $DOCUMENT_ROOT/apps/nginx/root.cron
0 */$FORM_count * * * $DOCUMENT_ROOT/apps/nginx/nginx_log_split.sh
EOF
;;
day)
cat <<EOF > $DOCUMENT_ROOT/apps/nginx/root.cron
0 0 */$FORM_count * * $DOCUMENT_ROOT/apps/nginx/nginx_log_split.sh
EOF
;;
month)
cat <<EOF > $DOCUMENT_ROOT/apps/nginx/root.cron
0 0 0 */$FORM_count * $DOCUMENT_ROOT/apps/nginx/nginx_log_split.sh
EOF
;;
day_of_week)
cat <<EOF > $DOCUMENT_ROOT/apps/nginx/root.cron
0 0 0 * */$FORM_count $DOCUMENT_ROOT/apps/nginx/nginx_log_split.sh
EOF
;;
esac
$DOCUMENT_ROOT/apps/scheduled/S300scheduled.init
(echo "Save Success" | main.sbin output_json 0) || exit 0
}