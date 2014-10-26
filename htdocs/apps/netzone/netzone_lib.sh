#!/bin/sh

# yum install bridge-utils tunctl -y
# apt-get install uml-utilities
# brctl addbr br0
# ifconfig eth0 0.0.0.0
# brctl addif br0 eth0
# ifconfig br0 192.168.1.120 netmask 255.255.255.0 up
# route add -net 192.168.1.0 netmask 255.255.255.0 br0
# route add default gw 192.168.1.1 br0
# tunctl -b -u john
# ifconfig tap0 up
# brctl addif br0 tap0

stop()
{
for brif in `brctl show | grep -v "bridge name" | awk '{print $1}'`
do
brctl delbr ${brif}
done
}

do_save_zone()
{
# [ -n "$FORM_zonename" ] || (echo "zonename can not be empty" | main.sbin output_json 1) || exit 1
[ "$FORM_zone" = "lan_zone" ] || [ -n "$FORM_dev" ] || (echo "dev can not be empty" | main.sbin output_json 1) || exit 1

netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
old_enable=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["enable"]'`
old_dev=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["dev"]'`
old_forward=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"]'`
old_input=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"]'`
old_output=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"]'`
old_ip=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["ip"]'`
old_netmask=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["netmask"]'`

netzone_str=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["dev"] = "'"$FORM_dev"'"'`
netzone_str=`echo "$netzone_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["enable"] = "'"$FORM_enable"'"'`

if
[ "$FORM_forward" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "REJECT"'`
fi
if
[ "$FORM_input" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "REJECT"'`
fi
if
[ "$FORM_output" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "REJECT"'`
fi
if
[ "$FORM_zone" = "lan_zone" ]
then
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["ip"] = "'"$FORM_ip"'"'`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["netmask"] = "'"$FORM_netmask"'"'`
fi

if
echo "$netzone_str" | jq '.' >/dev/null 2>&1 && echo "$base_firewall_str" | jq '.' >/dev/null 2>&1
then
echo "$netzone_str" > $DOCUMENT_ROOT/apps/netzone/netzone.conf
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_netzone_zone_setting_modified" \
				detail="_NOTICE_netzone_zone_setting_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="netzone" \
				dest_type="app" \
					variable="{\
					\"zonename\":\"$FORM_zonename\", \
					\"old_enable\":\"$old_enable\", \
					\"old_dev\":\"$old_dev\", \
					\"old_forward\":\"$old_forward\", \
					\"old_input\":\"$old_input\", \
					\"old_output\":\"$old_output\", \
					\"old_ip\":\"$old_ip\", \
					\"old_netmask\":\"$old_netmask\", \
					\"new_enable\":\"$FORM_enable\", \
					\"new_dev\":\"$FORM_dev\", \
					\"new_forward\":\"$FORM_forward\", \
					\"new_input\":\"$FORM_input\", \
					\"new_output\":\"$FORM_output\", \
					\"new_ip\":\"$FORM_ip\", \
					\"new_netmask\":\"$FORM_netmask\" \
					}" >/dev/null 2>&1
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Save Success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
add_zone_wan_new()
{
[ "$FORM_zone" = "lan_zone" ] || [ -n "$FORM_dev" ] || (echo "dev can not be empty" | main.sbin output_json 1) || exit 1
[ -n "$FORM_zonename" ] && FORM_zonename="wan_$FORM_zonename"
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["dev"] = "'"$FORM_dev"'"'`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["enable"] = "'"$FORM_enable"'"'`

if
[ "$FORM_forward" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "REJECT"'`
fi
if
[ "$FORM_input" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "REJECT"'`
fi
if
[ "$FORM_output" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "REJECT"'`
fi
if
[ "$FORM_zone" = "lan_zone" ]
then
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["ip"] = "'"$FORM_ip"'"'`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["netmask"] = "'"$FORM_netmask"'"'`
fi

if
echo "$netzone_str" | jq '.' >/dev/null 2>&1 && echo "$base_firewall_str" | jq '.' >/dev/null 2>&1
then
echo "$netzone_str" > $DOCUMENT_ROOT/apps/netzone/netzone.conf
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Save Success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
add_zone_lan_new()
{
[ "$FORM_zone" = "lan_zone" ] || [ -n "$FORM_dev" ] || (echo "dev can not be empty" | main.sbin output_json 1) || exit 1
[ -n "$FORM_zonename" ] && FORM_zonename="lan_$FORM_zonename"
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["dev"] = "'"$FORM_dev"'"'`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["enable"] = "'"$FORM_enable"'"'`

if
[ "$FORM_forward" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["forward"] = "REJECT"'`
fi
if
[ "$FORM_input" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["input"] = "REJECT"'`
fi
if
[ "$FORM_output" = "ACCEPT" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "ACCEPT"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["output"] = "REJECT"'`
fi
if
[ "$FORM_zone" = "lan_zone" ]
then
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["ip"] = "'"$FORM_ip"'"'`
netzone_str=`echo "$netzone_str" | jq '.["'$FORM_zone'"]["'"$FORM_zonename"'"]["netmask"] = "'"$FORM_netmask"'"'`
fi

if
echo "$netzone_str" | jq '.' >/dev/null 2>&1 && echo "$base_firewall_str" | jq '.' >/dev/null 2>&1
then
echo "$netzone_str" > $DOCUMENT_ROOT/apps/netzone/netzone.conf
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Save Success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
del_netzone()
{
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
if
echo "$FORM_zonename" | grep -qE '^wan_'
then
netzone_str=`echo "$netzone_str" | jq 'del(.["wan_zone"]["'$FORM_zonename'"])'`
base_firewall_str=`echo "$base_firewall_str" | jq 'del(.["wan_zone"]["'$FORM_zonename'"])'`
echo "$netzone_str" > $DOCUMENT_ROOT/apps/netzone/netzone.conf
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
(echo "Del Success" | main.sbin output_json 0) || exit 0
elif
echo "$FORM_zonename" | grep -qE '^lan_'
then
netzone_str=`echo "$netzone_str" | jq 'del(.["lan_zone"]["'$FORM_zonename'"])'`
base_firewall_str=`echo "$base_firewall_str" | jq 'del(.["lan_zone"]["'$FORM_zonename'"])'`
base_firewall_str=`echo "$base_firewall_str" | jq 'del(.["forwarding"]["'$FORM_zonename'"])'`
echo "$netzone_str" > $DOCUMENT_ROOT/apps/netzone/netzone.conf
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Del Success" | main.sbin output_json 0) || exit 0
else
(echo "Zone name no exsit" | main.sbin output_json 1) || exit 1
fi

}
lan_2_wan()
{
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
wan_dest=`env | grep "^FORM_wan_zone_" | awk -F "=" {'print $2'} | tr '\n' ' '`
base_firewall_str=`echo "$base_firewall_str" | jq '.["forwarding"]["'$FORM_lan_zone'"] = {"dest":"'"$wan_dest"'"}'`
if
echo "$base_firewall_str" | jq '.' >/dev/null 2>&1
then
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Save success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}
