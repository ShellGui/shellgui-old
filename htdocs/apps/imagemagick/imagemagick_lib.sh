#!/bin/sh

download_imagemagick()
{
export download_json='{
"file_name":"ImageMagick-6.8.9-8.tar.bz2",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/ImageMagick-6.8.9-8.tar.bz2",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"7e96f55156d72ce59c76ec93362ec72a",
	"download_urls":{
	"imagemagick":"http://www.imagemagick.org/download/ImageMagick-6.8.9-8.tar.bz2",
	"vim":"http://ftp.vim.org/ImageMagick/ImageMagick-6.8.9-8.tar.bz2",
	"vim":"http://ftp.vim.org/pub/ImageMagick/ImageMagick-6.8.9-8.tar.bz2",
	"sunet":"http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/ImageMagick-6.8.9-8.tar.bz2"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/ImageMagick-6.8.9-8.tar.bz2 | awk {'print $1'})" != "7e96f55156d72ce59c76ec93362ec72a" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/ImageMagick-6.8.9-8.tar.bz2
# aria2c http://www.imagemagick.org/download/ImageMagick-6.8.9-8.tar.bz2 \
# http://ftp.vim.org/ImageMagick/ImageMagick-6.8.9-8.tar.bz2 \
# http://ftp.vim.org/pub/ImageMagick/ImageMagick-6.8.9-8.tar.bz2 \
# http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/ImageMagick-6.8.9-8.tar.bz2 --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}
make_imagemagick()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf ImageMagick-6.8.9-8
tar jxvf ImageMagick-6.8.9-8.tar.bz2
cd ImageMagick-6.8.9-8
./configure --prefix=/usr/local/imagemagick && make && make install || return 1

}

do_install_imagemagick()
{
touch $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_imagemagick" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_3_Make_install_ImageMagick\":\"0\",\"_PS_5_ImageMagick_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log" app="imagemagick" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="30"
download_imagemagick > $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_imagemagick" status_now="fail"
exit 1
fi

# main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_2_Make_install_ImageMagick_Dependence"
# main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="45"
# install_imagemagick_dependence > $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_3_Make_install_ImageMagick"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="60"
make_imagemagick >> $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_imagemagick" status_now="fail"
exit 1
fi

# main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_4_Config_ImageMagick"
# main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="80"
# config_imagemagick >> $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_5_ImageMagick_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_imagemagick" schedule_now="_PS_5_ImageMagick_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_imagemagick" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_imagemagick" status_now="success"

}
install_imagemagick()
{
check_imagemagick_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_imagemagick" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/imagemagick_ins_detail.log ] || do_install_imagemagick &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_imagemagick"
get_pregress_schedule_notice_detail
}
check_imagemagick_installed()
{
if
[ -x /usr/local/imagemagick/bin/convert ]
then
return 0
else
return 1
fi
}
pre_install_imagemagick()
{
echo "$_LANG_Ready_to_Install"


}