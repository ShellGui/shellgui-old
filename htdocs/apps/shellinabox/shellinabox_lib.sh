#!/sibn/sh

install_shellinabox_dependence()
{
echo "Nothing to do"
}

download_shellinabox()
{
export download_json='{
"file_name":"shellinabox-2.14.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/shellinabox-2.14.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"6c63b52edcebc56ee73a108e7211d174",
	"download_urls":{
	"googlecode": "http://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz",
	"freebsd": "ftp://ftp.tw.freebsd.org/pub/ports/distfiles/shellinabox-2.14.tar.gz",
	"debian": "ftp://ftp.gr.debian.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"debian": "ftp://ftp.nz.debian.org/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"debian": "ftp://ftp.jp.debian.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"debian": "ftp://ftp.ro.debian.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"debian": "ftp://ftp.debian.hu/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"allbsd.org": "ftp://ftp.allbsd.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"cw.net": "ftp://ftp.cw.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"free.org": "ftp://ftp.free.org/mirrors/ftp.freebsd.org/ports/distfiles/shellinabox-2.14.tar.gz",
	"de.cw.net": "ftp://ftp.de.cw.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"lstn.net": "ftp://mirror.lstn.net/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"scene.org": "ftp://ftp.se.scene.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"ticklers.org": "ftp://ftp.ticklers.org/ftp.freebsd.org/ports/distfiles/shellinabox-2.14.tar.gz",
	"home.vim.org": "ftp://ftp.home.vim.org/vol/3/freebsd-core/ports/distfiles/shellinabox-2.14.tar.gz",
	"dc.aleron.net": "ftp://ftp.dc.aleron.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"techfak.net": "ftp://mirror.techfak.net/pub/mirrors/ftp.freebsd.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"freesbie.org": "ftp://ftp.gr.freesbie.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"symnds.com": "ftp://mirror.symnds.com/distributions/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"beastie.tdk.net": "ftp://ftp.beastie.tdk.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"macomnet.net": "ftp://mirror.macomnet.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"itsinternet.net": "ftp://ftp.itsinternet.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"cogentco.com": "ftp://mirror.cogentco.com/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"ee.postgresql.org": "ftp://ftp.ee.postgresql.org/pub/FreeBSD/distfiles/shellinabox-2.14.tar.gz",
	"exonetric.net": "ftp://mirror.exonetric.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"leaseweb.com": "ftp://mirror.leaseweb.com/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"wlansystems.com": "ftp://ftp.wlansystems.com/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"mirrorservice.org": "ftp://ftp.mirrorservice.org/sites/ftp.freebsd.org/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"mirrorservice.org": "ftp://ftp.mirrorservice.org/sites/distfiles.macports.org/shellinabox/shellinabox-2.14.tar.gz",
	"de.leaseweb.net": "ftp://mirror.de.leaseweb.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"de.leaseweb.net": "ftp://mirror.de.leaseweb.net/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"nl.leaseweb.net": "ftp://mirror.nl.leaseweb.net/pub/FreeBSD/ports/distfiles/shellinabox-2.14.tar.gz",
	"leaseweb.net": "ftp://mirror.nl.leaseweb.net/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"us.oneandone.net": "ftp://mirror.us.oneandone.net/bsd/freebsd/ports/distfiles/shellinabox-2.14.tar.gz",
	"us.oneandone.net": "ftp://mirror.us.oneandone.net/bsd/freebsd/ports/distfiles/shellinabox-2.14.tar.gz"
	}
}'
main.sbin download

}

make_shellinabox()
{
cd $DOCUMENT_ROOT/../sources/
rm -rf shellinabox-2.14
tar zxvf shellinabox-2.14.tar.gz

cd $DOCUMENT_ROOT/../sources/shellinabox-2.14
./configure --prefix=/usr/local/shellinabox && \
make && make install
}
config_shellinabox()
{
echo "Nothing to do"
}

do_install_shellinabox()
{
check_shellinabox_installed && echo "shellinabox binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_shellinabox" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_SHELLinabox_Dependence\":\"0\",\"_PS_3_Make_install_SHELLinabox\":\"0\",\"_PS_4_Config_SHELLinabox\":\"0\",\"_PS_5_SHELLinabox_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log" app="shellinabox" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="30"
download_shellinabox > $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_shellinabox" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_2_Make_install_SHELLinabox_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="45"
install_shellinabox_dependence > $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_3_Make_install_SHELLinabox"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="60"
make_shellinabox >> $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_shellinabox" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_4_Config_SHELLinabox"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="80"

main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_5_SHELLinabox_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_shellinabox" schedule_now="_PS_5_SHELLinabox_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_shellinabox" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_shellinabox" status_now="success"
main.sbin notice option="unmark_uniq" uniqid="shellinabox_binary_need_install" >/dev/null 2>&1
}

check_shellinabox_installed()
{
if
[ -x /usr/local/shellinabox/bin/shellinaboxd ]
then
return 0
else
return 1
fi
}
install_shellinabox()
{
check_shellinabox_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_shellinabox" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/shellinabox_ins_detail.log ] || do_install_shellinabox &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_shellinabox"
get_pregress_schedule_notice_detail
}
###########################################
pre_install_shellinabox()
{

echo "$_LANG_Ready_to_Install"
}

shellinabox_service()
{
sed -i "s/^enable=.*/enable=$FORM_shellinabox_enable/g" $DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init
$DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init >/dev/null 2>&1
if
[ $FORM_shellinabox_enable -eq 1 ]
then
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_shellinabox_service_enable" \
				detail="_NOTICE_shellinabox_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="shellinabox" \
				dest_type="app" >/dev/null 2>&1
else
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_shellinabox_service_disable" \
				detail="_NOTICE_shellinabox_service_disable" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="shellinabox" \
				dest_type="app" >/dev/null 2>&1
fi
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi
}
set_shellinaboxd_style()
{
sed -i "s/^style=.*/style=\"$FORM_shellinabox_style\"/g" $DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init
$DOCUMENT_ROOT/apps/shellinabox/S990shellinabox.init >/dev/null 2>&1
if
[ $? -eq 0 ]
then
(echo "$_LANG_Save_success" | main.sbin output_json 0) || exit 0
else
(echo "Fail" | main.sbin output_json 1) || exit 1
fi

}


