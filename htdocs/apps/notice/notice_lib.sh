#!/bin/sh

get_pregress_schedule_notice_detail()
{
data_str=`cat $DOCUMENT_ROOT/../tmp/progress_schedule.json`
pregress=`echo "$data_str" | jq -r '.["'$FORM_ps'"]["pregress"]'`
tar_app=`echo "$data_str" | jq -r '.["'$FORM_ps'"]["app"]'`
for i18n_file in `ls $DOCUMENT_ROOT/apps/*/i18n/$lang/i18n.conf`
do
eval `cat ${i18n_file} | grep "^_PS_"`
done
status_tmp=`echo "$data_str" | jq -r '.["'$FORM_ps'"]["status"]'`
if
[ "$status_tmp" = "success" ]
then
progress_color="progress-bar progress-bar-success"
elif
[ "$status_tmp" = "fail" ]
then
progress_color="progress-bar progress-bar-danger"
else
progress_color="progress-bar progress-bar-striped active"
fi

[ -n "$FORM_ps" ] && cat <<EOF

<div class="col-xs-6">
	<div class="row">
		<div class="col-xs-4">
		</div>
		<div class="col-xs-4">
		<h1>$pregress%</h1>
		</div>
		<div class="col-xs-4">
		</div>
	</div>
	<div class="row">
	<li class="list-group-item list-group-item-success">
		<div class="progress">
		  <div class="$progress_color"  role="progressbar" aria-valuenow="$pregress" aria-valuemin="0" aria-valuemax="100" style="width: $pregress%">
			<span class="sr-only">$pregress% Complete</span>
		  </div>
		</div>
	<div class="row">
		<div class="col-xs-1">
		</div>
		<div class="col-xs-10">
		$tar_app : `eval echo '$'$FORM_ps`
		</div>
		<div class="col-xs-1">
		</div>
	</div>
	</li>
	</div>
</div>

	<div class="col-xs-6">
	<ul class="list-group">
EOF

for schedule in `echo "$data_str" | jq '.["'$FORM_ps'"]["schedule"] | keys' | grep -Po '[\w]*'`
do
if
[ `echo "$data_str" | jq '.["'$FORM_ps'"]["schedule"]["'${schedule}'"]' | grep -Po '[\w]*'` = 0 ]
then
cat <<EOF
<li class="list-group-item list-group-item-warning"><span class="glyphicon glyphicon-time alert-warning"></span>    `eval echo '$'${schedule}`</li>
EOF
elif
[ `echo "$data_str" | jq '.["'$FORM_ps'"]["schedule"]["'${schedule}'"]' | grep -Po '[\w]*'` = 1 ]
then
cat <<EOF
<li class="list-group-item list-group-item-info"><span class="glyphicon glyphicon-refresh alert-info"></span>    `eval echo '$'${schedule}`</li>
EOF
else
cat <<EOF
	  <li class="list-group-item list-group-item-success"><span class="glyphicon glyphicon-ok-sign alert-success"></span>    `eval echo '$'${schedule}`</li>
EOF
fi
done

cat <<EOF
	</ul>
	</div>

<label>Detail</label>
<pre>
`tail $(echo "$data_str" | jq -r '.["'$FORM_ps'"]["detail_file"]')`
</pre>
EOF
}
get_pregress_schedule_notice()
{
data_str=`cat $DOCUMENT_ROOT/../tmp/progress_schedule.json`
for i18n_file in `ls $DOCUMENT_ROOT/apps/*/i18n/$lang/i18n.conf`
do
eval `cat ${i18n_file} | grep -E "^_PS_|^_NOTICE_"`
done
cat <<'EOF'
<script>
function del_ps(ps)
{
  var url = 'index.cgi?app=notice&action=del_ps&ps=' + ps;
  Ha.common.ajax(url, 'html', '', 'get', '', function(data){
    $('#notice_nav_list').html(data);
  }, 1);
}
</script>
EOF

for ps in `echo "$data_str" | jq '. | keys' | grep -Po '[\w]*[\w]'`
do
pregress=`echo "$data_str" | jq -r '.["'$ps'"]["pregress"]'`
tar_app=`echo "$data_str" | jq -r '.["'$ps'"]["app"]'`
status=`echo "$data_str" | jq -r '.["'$ps'"]["status"]'`
if
[ "$status" = "working" ]
then
cat <<EOF
	<li class="list-group-item list-group-item-warning"><br/>
	  <div class="row">
		  <div class="col-md-10">
			<div class="progress">
			  <div class="progress-bar progress-bar-striped active"  role="progressbar" aria-valuenow="$pregress" aria-valuemin="0" aria-valuemax="100" style="width: $pregress%">
				<span class="sr-only">$pregress% Complete</span>$pregress%
			  </div>
			</div>
				<a href="/index.cgi?app=$tar_app">$tar_app : `eval echo '$'$ps`</a>
		  </div>
		  <div class="col-md-2">
			<a href="/index.cgi?app=$tar_app"><span class="glyphicon glyphicon-chevron-right alert-primary"></span></a>
EOF
elif
[ "$status" = "success" ]
then
cat <<EOF
	<li class="list-group-item list-group-item-success"><br/>
	  <div class="row">
		  <div class="col-md-10">
			<div class="progress">
			  <div class="progress-bar progress-bar-success"  role="progressbar" aria-valuenow="$pregress" aria-valuemin="0" aria-valuemax="100" style="width: $pregress%">
				<span class="sr-only">$pregress% Complete</span>$pregress%
			  </div>
			</div>
			<a href="/index.cgi?app=$tar_app">$tar_app : `eval echo '$'$ps`</a>
		  </div>
		  <div class="col-md-2">
			<a onclick="del_ps('$ps')"><span class="glyphicon glyphicon-remove alert-primary"></span></a>
EOF
elif
[ "$status" = "fail" ]
then
cat <<EOF
	<li class="list-group-item list-group-item-danger"><br/>
	  <div class="row">
		  <div class="col-md-10">
			<div class="progress">
			  <div class="progress-bar progress-bar-danger"  role="progressbar" aria-valuenow="$pregress" aria-valuemin="0" aria-valuemax="100" style="width: $pregress%">
				<span class="sr-only">$pregress% Complete</span>$pregress%
			  </div>
			</div>
			<a href="/index.cgi?app=$tar_app">$tar_app : `eval echo '$'$ps`</a>
		  </div>
		  <div class="col-md-2">
			<a href="/index.cgi?app=$tar_app"><span class="glyphicon glyphicon-remove alert-danger"></span></a>
EOF
fi
cat <<EOF
			</div>
	  </div>
	</li>
EOF
done
notice_index_str=`cat $DOCUMENT_ROOT/apps/notice/notice_index.json`
notice_data_str=`cat $DOCUMENT_ROOT/apps/notice/notice_data.json`
for id in `list_all_notice_page | sed -n '1,6p'`
do
desc=$(echo "$notice_index_str" | jq -r '.["'${id}'"]["desc"]')
desc_i18n=""
eval desc_i18n='$'$desc
if
[ -n "$desc_i18n" ]
then
for var in `echo "$desc_i18n" | grep -Po '{.*}' | sed -e 's/}.*{/\n/g' -e 's/[{|}]//g'`
do
eval `cat <<EOF
${var}="$(echo "$notice_data_str" | jq -r '.["'$id'"]["variable"]["'"${var}"'"]')"
EOF`
done
fi

cat <<EOF
<li class="list-group-item list-group-item-`[ "$(echo "$notice_index_str" | jq -r '.["'${id}'"]["uniqid"]')" != "null" ] && echo danger || ([ $(echo "$notice_index_str" | jq -r '.["'${id}'"]["read"]') -eq 0 ] && echo warning || echo default)`"><br/>
<a href="/index.cgi?app=notice">
EOF
eval echo "$(echo "$desc_i18n" | sed 's/{/${/g')"
cat <<EOF
</a>
</li>
EOF
done
}
get_notice_unread()
{
[ -f $DOCUMENT_ROOT/apps/notice/notice_index.json ] || exit 1
cat $DOCUMENT_ROOT/apps/notice/notice_index.json | jq -r '.[]["read"]' | grep "^0$" | wc -l
}

get_notice_unread_json()
{
ps_count=`cat $DOCUMENT_ROOT/../tmp/progress_schedule.json | jq '. | keys' | grep -Po '[\w]*' | wc -l`
count=`get_notice_unread`
[ -n "$ps_count" ] && count=`expr $count + $ps_count`
cat <<EOF
{"count":"$count","status":0,"msg":""}
EOF
}

do_show_message()
{
notice_index_str=`cat $DOCUMENT_ROOT/apps/notice/notice_index.json`
[ "$(echo "$notice_index_str" | jq -r '.["'${FORM_id}'"]["uniqid"]')" = "null" ] && [ $(echo "$notice_index_str" | jq -r '.["'$FORM_id'"]["read"]') -eq 0 ] && echo "$notice_index_str" | jq -r '.["'$FORM_id'"]["read"] = "1"' > $DOCUMENT_ROOT/apps/notice/notice_index.json
notice_data_str=`cat $DOCUMENT_ROOT/apps/notice/notice_data.json`

detail=$(echo "$notice_data_str" | jq -r '.["'$FORM_id'"]["detail"]')
detail_i18n=""
eval detail_i18n=\$$detail
if
[ -n "$detail_i18n" ]
then
for var in `echo "$detail_i18n" | grep -Po '\{[\w]*\}' | sed 's/[{|}]//g'`
do
eval `cat <<EOF
${var}="$(echo "$notice_data_str" | jq -r '.["'$FORM_id'"]["variable"]["'"${var}"'"]')"
EOF`
done
eval echo $(echo "$detail_i18n" | sed 's/{/${/g')
# <>特殊符号需要转义
else
echo "$detail"
fi
}

list_all_notice_page()
{
notice_index_str=`cat $DOCUMENT_ROOT/apps/notice/notice_index.json`
# '.[]["read"] == "0"'
# echo "$notice_index_str" | jq '. | keys' | grep -Po '[0-9]*' | sort -nr
uniqid_c=`echo "$notice_index_str" | jq '. as $in | keys[] | select($in[.]|type=="object") | select($in[.].uniqid)' | grep -Po '[0-9]*' |sort -nr`
for i in $uniqid_c
do
notice_index_str=`echo "$notice_index_str" | jq 'del(.["'${i}'"])'`
done
readed_c=`echo "$notice_index_str" | jq '. as $in | keys[] | select($in[.]|type=="object") | select($in[.].read == "0")' | grep -Po '[0-9]*' |sort -nr`
for i in $readed_c
do
notice_index_str=`echo "$notice_index_str" | jq 'del(.["'${i}'"])'`
done
unread_c=`echo "$notice_index_str" | jq '. as $in | keys[] | select($in[.]|type=="object") | select($in[.].read == "1")' | grep -Po '[0-9]*' |sort -nr`
echo "$uniqid_c"
echo "$readed_c"
echo "$unread_c"
}

notice_vars()
{
[ -n "$per_page_count" ] || return 1
[ -n "$select_cont" ] || return 1
[ -n "$p" ] || p=1

notice_list=`list_all_notice_page`
total_count=`echo "$notice_list" | grep "." | wc -l`
total_pages=`awk 'BEGIN{print '$total_count'/'$per_page_count'}'`
echo "$total_pages" | grep -q "\." && total_pages=`expr $(echo "$total_pages" | sed 's/\..*//g') + 1`
[ $p -gt $total_pages ] && exit 1

start_num=`expr $(expr $(expr $p - 1) \* $per_page_count) + 1`
stop_num=`expr $p \* $per_page_count`
page_list=`echo "$notice_list" | awk "NR>=${start_num}&&NR<=${stop_num}"`
}

notice_pages()
{

_LANG_App_name="$_LANG_App_name"
main.sbin html_head
echo "</head>"
echo '<body>'
echo '<div class="notification-bar ajax-notification-bar"><a href="javascript:;" class="close">&times;</a></div>'
main.sbin html_nav
echo "<br/><br/>"

cat <<EOF
<div class="container" id="ajax-fluid"> <!--container-->
EOF

#--------------------------
cat <<'EOF'
<script type="text/javascript">
function do_show_message(id)
{
	var url = 'index.cgi?app=notice&action=do_show_message&id=' + id;
	Ha.common.ajax(url, 'html', '', 'get', 'ajax-fluid', function(data){
	$('#noticecontent').html(data);
	$('#noticeModal').modal('show');
	}, 1);
}
function selectAll(checkbox) {
	$('input[type=checkbox]').prop('checked', $(checkbox).prop('checked'));
}

$(function(){
  $('#notice_read').on('click', function(e){
    e.preventDefault();
    var data = "app=notice&action=notice_read&" + $("#ids").serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 3000);
  });
});
$(function(){
  $('#notice_del').on('click', function(e){
    e.preventDefault();
    var data = "app=notice&action=notice_del&" + $("#ids").serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-fluid');
	setTimeout("window.location.reload();", 3000);
  });
});
</script>

EOF
notice_index_str=`cat $DOCUMENT_ROOT/apps/notice/notice_index.json`
notice_data_str=`cat $DOCUMENT_ROOT/apps/notice/notice_data.json`
cat <<EOF
<div class="container" id="ajax-fluid">
	<div class="row" id="noticelist">
	<legend>$_LANG_Messages(<span id="noticecount">`get_notice_unread`</span>)</legend>
	<form name="noticeform" id="ids" action="">
	<table class="table table-hover table-condensed">
		<tbody>
EOF
per_page_count=15
select_cont=10
p=$FORM_p
notice_vars
for id in $page_list
do

echo "<tr"
if
[ "$(echo "$notice_index_str" | jq -r '.["'${id}'"]["uniqid"]')" != "null" ]
then
echo "class=\"danger\""
else
[ $(echo "$notice_index_str" | jq -r '.["'${id}'"]["read"]') -eq 0 ] && echo "class=\"warning\""
fi
cat <<EOF
>
			<td>
			<input type="checkbox" name="noticeid_${id}" value="${id}">
			<span class="glyphicon glyphicon-certificate `case $(echo "$notice_data_str" | jq -r '.["'${id}'"]["ergen"]') in green) echo "alert-success"; ;;yellow) echo "alert-warning"; ;;red) echo "alert-danger"; ;; esac`">
			</td>
			<td>`date -d @$(echo "$notice_data_str" | jq -r '.["'${id}'"]["time"]') +%Y-%m-%d" "%H:%M:%S`</td>
			<td>
EOF
cat <<EOF
				<a onclick="do_show_message('${id}')">
EOF
desc=$(echo "$notice_index_str" | jq -r '.["'${id}'"]["desc"]')
desc_i18n=""
eval desc_i18n='$'$desc
if
[ -n "$desc_i18n" ]
then
for var in `echo "$desc_i18n" | grep -Po '{.*}' | sed -e 's/}.*{/\n/g' -e 's/[{|}]//g'`
do
eval `cat <<EOF
${var}="$(echo "$notice_data_str" | jq -r '.["'$id'"]["variable"]["'"${var}"'"]')"
EOF`
done
eval echo "$(echo "$desc_i18n" | sed 's/{/${/g')"
else
echo "$desc"
fi
cat <<EOF
				</a>
			</td>
			<td>
EOF
case $(echo "$notice_data_str" | jq -r '.["'${id}'"]["dest_type"]') in
app)
cat <<EOF
<a href="index.cgi?app=$(echo "$notice_data_str" | jq -r '.["'${id}'"]["dest"]')"><button type="button" class="btn btn-primary btn-xs">$_LANG_To_deal</button>
EOF
;;
url)
cat <<EOF
<a href="$(echo "$notice_data_str" | jq -r '.["'${id}'"]["dest"]')" target="_blank"><button type="button" class="btn btn-primary btn-xs">$_LANG_To_view</button>
EOF
;;
esac
cat <<EOF
			</tr>
EOF
done
cat <<EOF
		</tbody>
		
		
<tfoot>
        <tr>
          <td colspan="5">
            <label><input type="checkbox" onclick="selectAll(this);" value="1">$_LANG_SelectAll</label>   
            <button type="button" id="notice_del" class="btn btn-danger btn-sm">$_LANG_Del</button>  
            <button type="button" id="notice_read" class="btn btn-primary btn-sm" id="readed">$_LANG_Mark_Read</button>
          </td>
        </tr>
      <tr>
	<td colspan="5"><ul class="pagination pull-right">
EOF
if
[ $p -lt $select_cont ]
then
	[ $select_cont -lt $total_pages ] && last=$select_cont ||  last=$total_pages
	[ $p -gt 1 ] && echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr ${page} - 1)\">$_LANG_Back</a></li>"
	for page in `seq 1 $last`
	do
	echo "<li"
	if
	[ $p -ne ${page} ]
	then
	cat <<EOF
	><a href="?app=notice&action=notice_pages&p=${page}">
EOF
	else
	cat <<EOF
	class="active"><a>
EOF
	fi
	echo "${page}</a></li>"
	done
	echo "<li><a>..</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$total_pages\">$total_pages</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr $p + 1)\">$_LANG_Next</a></li>"
elif
[ $p -gt `expr $total_pages - $select_cont` ]
then
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr ${page} - 1)\">$_LANG_Back</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=1\">1</a></li>"
	echo "<li><a>..</a></li>"
	for page in `seq $(expr $(expr $total_pages - $select_cont) + 1) $total_pages`
	do
	echo "<li"
	if
	[ $p -ne ${page} ]
	then
	cat <<EOF
	><a href="?app=notice&action=notice_pages&p=${page}">
EOF
	else
	cat <<EOF
	class="active"><a>
EOF
	fi
	echo "${page}</a></li>"
	done
	[ $p -lt $total_pages ] && echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr $p + 1)\">$_LANG_Next</a></li>"
else
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr ${page} - 1)\">$_LANG_Next</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=1\">1</a></li>"
	echo "<li><a>..</a></li>"
	for page in `seq $(expr $p - $(expr $select_cont / 2)) $(expr $p + $(expr $select_cont / 2))`
	do
	echo "<li"
	if
	[ $p -ne ${page} ]
	then
	cat <<EOF
	><a href="?app=notice&action=notice_pages&p=${page}">
EOF
	else
	cat <<EOF
	class="active"><a>
EOF
	fi
	echo "${page}</a></li>"
	done
	echo "<li><a>..</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$total_pages\">$total_pages</a></li>"
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr $p + 1)\">$_LANG_Next</a></li>"
fi
cat <<EOF
	  
	  </td>
  </tr>
</tfoot>
		
		
	</table>
	</form>
	</div>
</div>

<div class="modal fade" id="noticeModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">$_LANG_Messages_detail</h4>
      </div>
      <div class="modal-body" id="noticecontent">

      </div>
      <div class="modal-footer">
        <button type="button" onclick="javascript:history.go(0)" class="btn btn-default" data-dismiss="modal">$_LANG_Close</button>
      </div>
    </div>
  </div>
</div>
EOF

#--------------------------

cat <<EOF
</div> <!--container-->
EOF
[ -z "$FOOT_POST" ] && main.sbin html_foot && export FOOT_POST=1
echo "</body>"
echo "</html>"
}

notice_del()
{
main.sbin notice option="del" id=`env | grep "FORM_noticeid_" | awk -F "=" {'print $2'} | tr "\n" ","`
if
[ $? -eq 0 ]
then
(echo "del success" | main.sbin output_json 0) || exit 0
else
(echo "del fail" | main.sbin output_json 1) || exit 1
fi
}

notice_read()
{
main.sbin notice option="mark_read" id=`env | grep "FORM_noticeid_" | awk -F "=" {'print $2'} | tr "\n" ","`
if
[ $? -eq 0 ]
then
(echo "mark read success" | main.sbin output_json 0) || exit 0
else
(echo "mark read fail" | main.sbin output_json 1) || exit 1
fi
}

del_ps()
{
main.sbin pregress_schedule option="del" task="$FORM_ps"
if
[ $? -eq 0 ]
then
(echo "del success" | main.sbin output_json 0) || exit 0
else
(echo "del fail" | main.sbin output_json 1) || exit 1
fi
}
