#!/bin/sh
OS=`cat /etc/issue | sed -n 1p | awk -F '\' {'print $1'}`
if
[ -z "$OS" ]
then
	if
	[ -f /etc/system-release ]
	then
	OS=`cat /etc/system-release | sed -n 1p`
	elif
	[ -f /etc/openwrt_release ]
	then
	eval  /etc/openwrt_release
	OS=$DISTRIB_DESCRIPTION
	else
	OS="Unknow"
	fi
fi

if
echo $OS | grep -qi "centos"
then
distribution=centos-$(echo $OS | grep -Po '[0-9].*[0-9]*' | sed -e 's/\..*//g' -e 's/$/\.x/g')
elif
echo $OS | grep -qi "debian"
then
distribution=debian-$(echo $OS | grep -Po '[0-9].*[0-9]*' | sed -e 's/\..*//g' -e 's/$/\.x/g')
elif
echo $OS | grep -qi "ubuntu"
then
distribution=ubuntu-$(echo $OS | grep -Po '[0-9].*[0-9]*' | sed -e 's/\..*//g' -e 's/$/\.x/g')
else
distribution=unknow
fi
