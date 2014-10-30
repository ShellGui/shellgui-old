#!/bin/sh


download_aria2()
{
export download_json='{
"file_name":"aria2-1.17.1.tar.bz2",
"downloader":"curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/aria2-1.17.1.tar.bz2",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"86229ef8d289893934cb3af25c8fddf6",
	"download_urls":{
	"url_1":"http://iweb.dl.sourceforge.net/project/aria2/stable/aria2-1.17.1/aria2-1.17.1.tar.bz2",
	"url_2":"http://x.vm0.ru/wl500g-repo/sources-mirror/aria2-1.17.1.tar.bz2"
	}
}'
main.sbin download
}



make_aria2()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf $DOCUMENT_ROOT/../sources/aria2-1.17.1
tar jxvf aria2-1.17.1.tar.bz2
cd $DOCUMENT_ROOT/../sources/aria2-1.17.1
./configure --prefix=$DOCUMENT_ROOT/../ --without-sqlite3 && make && make install

}

do_install_aria2()
{
check_aria2_installed && echo "aria2 binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/aria2_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_Aria2" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_Aria2\":\"0\",\"_PS_3_Aria2_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/aria2_ins_detail.log" app="aria2" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Aria2" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_Aria2" schedule_now="_PS_1_Download_Sources"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Aria2" pregress_now="30"
download_aria2 > $DOCUMENT_ROOT/../tmp/aria2_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_Aria2" status_now="fail"
exit 1
fi
main.sbin pregress_schedule option="now" task="_PS_Install_Aria2" schedule_now="_PS_2_Make_install_Aria2"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Aria2" pregress_now="60"
make_aria2 >> $DOCUMENT_ROOT/../tmp/aria2_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_Aria2" status_now="fail"
exit 1
fi
main.sbin pregress_schedule option="now" task="_PS_Install_Aria2" schedule_now="_PS_3_Aria2_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_Aria2" schedule_now="_PS_3_Aria2_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_Aria2" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_Aria2" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="aria2_binary_need_install"
}
check_aria2_installed()
{
if
[ -x $DOCUMENT_ROOT/../bin/aria2c ]
then
return 0
else
return 1
fi
}
install_aria2()
{
check_aria2_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_Aria2" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/aria2_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/aria2_ins_detail.log ] || do_install_aria2 &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_Aria2"
get_pregress_schedule_notice_detail
}
pre_install_aria2()
{
echo "$_LANG_Ready_to_Install"
}

