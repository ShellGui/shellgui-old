#!/bin/sh

. $DOCUMENT_ROOT/apps/home/distributions_lib.sh
sysinfo_gen()
{
echo "$OS" | grep -i "centos" && cp -R $DOCUMENT_ROOT/apps/sysinfo/centos.png $DOCUMENT_ROOT/apps/sysinfo/icon.png
echo "$OS" | grep -i "ubuntu" && cp -R $DOCUMENT_ROOT/apps/sysinfo/ubuntu.png $DOCUMENT_ROOT/apps/sysinfo/icon.png
echo "$OS" | grep -i "debian" && cp -R $DOCUMENT_ROOT/apps/sysinfo/debian.png $DOCUMENT_ROOT/apps/sysinfo/icon.png
echo "$OS" | grep -i "unknow" && cp -R $DOCUMENT_ROOT/apps/sysinfo/unknow.png $DOCUMENT_ROOT/apps/sysinfo/icon.png
cores=`grep 'processor' /proc/cpuinfo |sort |uniq |wc -l`
is_64=no
[ `grep 'lm' /proc/cpuinfo |wc -l` -gt 0 ] && is_64=yes
is_ht=no
cat /proc/cpuinfo | grep -q ht && is_ht=yes
cpu_str=`cat /proc/cpuinfo`
cpu_model=`echo "$cpu_str" | grep "^model name.:" |awk -F ":" {'print $2'} | sort -n | uniq`
cpu_Ghz=`echo "$cpu_model" | awk -F "@" {'print $NF'}`
cpu_cache=`echo "$cpu_str" | grep "^cache size" | awk -F ":" {'print $NF'} | uniq`
kernel_ver=`uname -sr`
hw_model=`uname -m`
total_mem=`expr $(sed -e '/^MemTotal: /!d; s#MemTotal: *##; s# kB##g' /proc/meminfo) \* 1024`
total_mem=`main.sbin storage_size_conver "$total_mem"`
total_swap=`expr $(sed -e '/^SwapTotal: /!d; s#SwapTotal: *##; s# kB##g' /proc/meminfo) \* 1024`
total_swap=`main.sbin storage_size_conver "$total_swap"`
disk_info=`fdisk -l |grep 'Disk' | awk -F , '{print $1}'| grep -v "identifier" | tr '\n' '#' | sed 's/#/<br\/>/g'`
tz_now=`ls -l /etc/localtime | awk {'print $NF'} | sed 's#/usr/share/zoneinfo/##g'`
echo $tz_now | grep -qE "^/" && main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_timezone_not_seted" \
				detail="_NOTICE_timezone_not_seted" \
				uniqid="timezone_not_seted" \
				time="" \
				ergen="red" \
				dest="sysinfo" \
				dest_type="app" >/dev/null 2>&1

sysinfo_data=`echo "{}" | jq '.["sysinfo"] = .["sysinfo"] + {"OS":"'"$OS"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"] = .["sysinfo"] + {"hostname":"'"$(hostname)"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"] = .["sysinfo"] + {"kernel_ver":"'"$kernel_ver"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"] = .["sysinfo"] + {"hw_model":"'"$hw_model"'"}'`

#
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"cpu_model":"'"$cpu_model"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"cores":"'"$cores"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"cpu_Ghz":"'"$cpu_Ghz"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"cpu_cache":"'"$cpu_cache"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"is_64":"'"$is_64"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["cpu"] = .["sysinfo"]["cpu"] + {"is_ht":"'"$is_ht"'"}'`
#
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["mem"] = .["sysinfo"]["mem"] + {"total_mem":"'"$total_mem"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"]["mem"] = .["sysinfo"]["mem"] + {"total_swap":"'"$total_swap"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"] = .["sysinfo"] + {"disk_info":"'"$disk_info"'"}'`
sysinfo_data=`echo "$sysinfo_data" | jq '.["sysinfo"] = .["sysinfo"] + {"tz_now":"'$tz_now'"}'`
echo "$sysinfo_data" > $DOCUMENT_ROOT/../tmp/sysinfo.json
}