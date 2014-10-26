#!/bin/sh

packagename="aria2"
version="1.17.1"
arch="tar.bz2"
download_url="http://iweb.dl.sourceforge.net/project/aria2/stable/aria2-1.17.1/"

download_aria2()
{
if
[ "$(md5sum $DOCUMENT_ROOT/../sources/$packagename-$version.$arch | awk {'print $1'})" != "86229ef8d289893934cb3af25c8fddf6" ]
then
rm -f $DOCUMENT_ROOT/../sources/$packagename-$version.$arch
curl -L "$download_url$packagename-$version.$arch" -o $DOCUMENT_ROOT/../sources/$packagename-$version.$arch 2>&1
fi
}



make_aria2()
{

cd $DOCUMENT_ROOT/../sources/
rm -rf $packagename-$version
tar jxvf $packagename-$version.$arch
cd $DOCUMENT_ROOT/../sources/$packagename-$version
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

