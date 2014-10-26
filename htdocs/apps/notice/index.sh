#!/bin/sh

main()
{
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
p=1
notice_vars
for id in $page_list
do

echo "<tr"
uniqid=$(echo "$notice_index_str" | jq -r '.["'${id}'"]["uniqid"]')
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
	echo "<li><a href=\"?app=notice&action=notice_pages&p=$(expr ${page} - 1)\">$_LANG_Back</a></li>"
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
}


lang=`main.sbin get_client_lang`
eval `cat $DOCUMENT_ROOT/apps/$FORM_app/i18n/$lang/i18n.conf`
for i18n_file in `ls $DOCUMENT_ROOT/apps/*/i18n/$lang/i18n.conf`
do
eval `cat ${i18n_file} | grep "^_NOTICE_"`
done
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
if
[ $is_main_page = 1 ]
then
main
elif [ -n "$FORM_action" ]
then
$FORM_action
fi