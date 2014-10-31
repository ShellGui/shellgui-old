#!/bin/sh

NF_TABLES=`cat /proc/net/ip_tables_names`
NF_MODULES=`lsmod | grep "^iptable_"`
NF_MODULES_COMMON=`lsmod | grep -E "^x_tables|^nf_nat|^nf_conntrack"`
kernel_ver=`uname -r`
base_firewall_str=`cat $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf`
netzone_str=`cat $DOCUMENT_ROOT/apps/netzone/netzone.conf`
firewall_extra=`find $DOCUMENT_ROOT/apps -type f -maxdepth 2 | grep "\.fw$" | grep -E "/F[0-9][0-9]*" | awk -F "/F" {'print $2" "$1'} | sort -n | awk {'print $2"/F"$1'}` >/dev/null 2>&1

zone_rule()
{
echo "$base_firewall_str" >/tmp/1
echo "$FORM_zone" >>/tmp/1
echo "$FORM_zonename" >>/tmp/1
old_syn_flood=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zone_name"'"]["syn_flood"]'`
old_invalid_pkg=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zone_name"'"]["invalid_pkg"]'`
old_accept_dhcp_68=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zone_name"'"]["accept_dhcp_68"]'`
old_allow_ping=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zone_name"'"]["allow_ping"]'`
old_allow_ports=`echo "$base_firewall_str" | jq -r '.["'$FORM_zone'"]["'"$FORM_zone_name"'"]["allow_ports"]'`
if
[ -n "$FORM_syn_flood" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["syn_flood"] = "1"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["syn_flood"] = "0"'`
fi
if
[ -n "$FORM_invalid_pkg" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["invalid_pkg"] = "1"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["invalid_pkg"] = "0"'`
fi
if
[ -n "$FORM_accept_dhcp_68" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["accept_dhcp_68"] = "1"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["accept_dhcp_68"] = "0"'`
fi
if
[ -n "$FORM_allow_ping" ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["allow_ping"] = "1"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["allow_ping"] = "0"'`
fi
if
[ -n "$FORM_allow_ports" ] && [ $(echo "$FORM_allow_ports" | wc -l) -eq 1 ]
then
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["allow_ports"] = "'"$FORM_allow_ports"'"'`
else
base_firewall_str=`echo "$base_firewall_str" | jq '.["'$FORM_zone'"]["'$FORM_zone_name'"]["allow_ports"] = ""'`
fi
if
echo "$base_firewall_str" | jq '.' | grep -q '{'
then
echo "$base_firewall_str" > $DOCUMENT_ROOT/apps/base-firewall/base-firewall.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_base_firewall_setting_modified" \
				detail="_NOTICE_base_firewall_setting_modified_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="base-firewall" \
				dest_type="app" \
					variable="{\
					\"zonename\":\"$FORM_zone_name\", \
					\"old_syn_flood\":\"$old_syn_flood\", \
					\"old_invalid_pkg\":\"$old_invalid_pkg\", \
					\"old_accept_dhcp_68\":\"$old_accept_dhcp_68\", \
					\"old_allow_ping\":\"$old_allow_ping\", \
					\"old_allow_ports\":\"$old_allow_ports\", \
					\"new_syn_flood\":\"$FORM_syn_flood\", \
					\"new_invalid_pkg\":\"$FORM_invalid_pkg\", \
					\"new_accept_dhcp_68\":\"$FORM_accept_dhcp_68\", \
					\"new_allow_ping\":\"$FORM_allow_ping\", \
					\"new_allow_ports\":\"$FORM_allow_ports\" \
					}" >/dev/null 2>&1
(. $DOCUMENT_ROOT/apps/base-firewall/base_firewall_lib.sh >/dev/null 2>&1
firewall_restart >/dev/null 2>&1)
(echo "Save Success" | main.sbin output_json 0) || exit 0
else
(echo "Save Fail" | main.sbin output_json 1) || exit 1
fi
}

flush_n_delete()
{
    # For all tables
    for i in $NF_TABLES; do
        # Flush firewall rules.
	iptables -t $i -F;
	let ret+=$?;
        # Delete firewall chains.
	iptables -t $i -X;
	let ret+=$?;

	# Set counter to zero.
	iptables -t $i -Z;
	let ret+=$?;
    done
	[ $ret -eq 0 ] && echo success || echo failure
    echo
    return $ret
}
insmod_all_ipt_mod()
{
for i in `ls /lib/modules/$kernel_ver/kernel/net/ipv4/netfilter/ | grep -E "^iptable_" | sed 's/.ko//'`
do
modprobe ${i}
done
for i in `ls /lib/modules/$kernel_ver/kernel/net/ipv4/netfilter/ | grep -E "^ipt_|^xt" | sed 's/.ko//'`
do
modprobe ${i}
done
}
rmmod_all_ipt_mod()
{
for i in `ls /lib/modules/$kernel_ver/kernel/net/ipv4/netfilter/ | grep -E "^ipt_|^xt" | sed 's/.ko//'`
do
rmmod ${i}
done
for i in `ls /lib/modules/$kernel_ver/kernel/net/ipv4/netfilter/ | grep -E "^iptable_" | sed 's/.ko//'`
do
rmmod ${i}
done

}
clean_iptables()
{
flush_n_delete
rmmod_all_ipt_mod
insmod_all_ipt_mod
}
default_policy()
{
iptables -t nat -P PREROUTING  ACCEPT
iptables -t nat -P INPUT  ACCEPT	#2.6.32.x kernel noted above which doesn't have the INPUT chain
iptables -t nat -P OUTPUT  ACCEPT
iptables -t nat -P POSTROUTING  ACCEPT

iptables -t raw -P PREROUTING ACCEPT
iptables -t raw -P OUTPUT ACCEPT

iptables -t mangle -P PREROUTING ACCEPT
iptables -t mangle -P INPUT ACCEPT
iptables -t mangle -P FORWARD ACCEPT
iptables -t mangle -P OUTPUT ACCEPT
iptables -t mangle -P POSTROUTING ACCEPT

iptables -t filter -P INPUT ACCEPT
iptables -t filter -P FORWARD ACCEPT
iptables -t filter -P OUTPUT ACCEPT
}

add_default_chains()
{
# nat
iptables -t nat -N delegate_postrouting
iptables -t nat -N delegate_prerouting
iptables -t nat -N postrouting_rule
iptables -t nat -N prerouting_rule
# raw
iptables -t raw -N delegate_notrack
# mangle
iptables -t mangle -N fwmark
iptables -t mangle -N mssfix
# filter
iptables -t filter -N delegate_forward
iptables -t filter -N delegate_input
iptables -t filter -N delegate_output
iptables -t filter -N forwarding_rule
iptables -t filter -N input_rule
iptables -t filter -N output_rule
iptables -t filter -N reject
iptables -t filter -N syn_flood
}
add_netzone_chains()
{

for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
# nat
iptables -t nat -N postrouting_${wan_zone}_rule
iptables -t nat -N prerouting_${wan_zone}_rule
iptables -t nat -N zone_${wan_zone}_prerouting
iptables -t nat -N zone_${wan_zone}_postrouting
# raw
# mangle
# filter
iptables -t filter -N forwarding_${wan_zone}_rule
iptables -t filter -N input_${wan_zone}_rule
iptables -t filter -N output_${wan_zone}_rule
iptables -t filter -N zone_${wan_zone}_forward
iptables -t filter -N zone_${wan_zone}_input
iptables -t filter -N zone_${wan_zone}_output
iptables -t filter -N zone_${wan_zone}_dest_ACCEPT

[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -N zone_${wan_zone}_src_ACCEPT

iptables -t filter -N zone_${wan_zone}_dest_REJECT
iptables -t filter -N zone_${wan_zone}_src_REJECT
fi
done
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
# nat
iptables -t nat -N postrouting_${lan_zone}_rule
iptables -t nat -N prerouting_${lan_zone}_rule
iptables -t nat -N zone_${lan_zone}_prerouting
iptables -t nat -N zone_${lan_zone}_postrouting
# raw
# mangle
# filter
iptables -t filter -N forwarding_${lan_zone}_rule
iptables -t filter -N input_${lan_zone}_rule
iptables -t filter -N output_${lan_zone}_rule
iptables -t filter -N zone_${lan_zone}_forward
iptables -t filter -N zone_${lan_zone}_input
iptables -t filter -N zone_${lan_zone}_output
iptables -t filter -N zone_${lan_zone}_dest_ACCEPT

[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -N zone_${lan_zone}_src_ACCEPT

iptables -t filter -N zone_${lan_zone}_dest_REJECT
iptables -t filter -N zone_${lan_zone}_src_REJECT
fi
done

}

deel_chains()
{
# nat
iptables -t nat -A PREROUTING -j delegate_prerouting
iptables -t nat -A POSTROUTING -j delegate_postrouting

iptables -t nat -A delegate_postrouting -m comment --comment "user chain for postrouting" -j postrouting_rule
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
iptables -t nat -A delegate_postrouting -o br-${lan_zone} -j zone_${lan_zone}_postrouting
fi
done
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t nat -A delegate_postrouting -o ${dev} -j zone_wan_postrouting
fi
done

iptables -t nat -A delegate_prerouting -m comment --comment "user chain for prerouting" -j prerouting_rule
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
iptables -t nat -A delegate_prerouting -i br-${lan_zone} -j zone_${lan_zone}_prerouting
fi
done
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t nat -A delegate_prerouting -i ${dev} -j zone_wan_prerouting
fi
done
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_nat_zone_lan_zone_postrouting
done
iptables -t nat -A zone_${lan_zone}_postrouting -m comment --comment "user chain for postrouting" -j postrouting_${lan_zone}_rule
iptables -t nat -A zone_${lan_zone}_prerouting -m comment --comment "user chain for prerouting" -j prerouting_${lan_zone}_rule
fi
done

for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_nat_zone_wan_zone_postrouting
done
iptables -t nat -A zone_${wan_zone}_postrouting -m comment --comment "user chain for postrouting" -j postrouting_${wan_zone}_rule
iptables -t nat -A zone_${wan_zone}_postrouting -j MASQUERADE
iptables -t nat -A zone_${wan_zone}_prerouting -m comment --comment "user chain for prerouting" -j prerouting_${wan_zone}_rule
fi
done
# raw
iptables -t raw -A PREROUTING -j delegate_notrack
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_raw_extra
done
# mangle
iptables -t mangle -A PREROUTING -j fwmark
iptables -t mangle -A FORWARD -j mssfix

for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t mangle -A mssfix -o $dev -p tcp -m tcp --tcp-flags SYN,RST SYN -m comment --comment "wan (mtu_fix)" -j TCPMSS --clamp-mss-to-pmtu
fi
done
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_mangle_extra
done
# filter
iptables -t filter -A INPUT -j delegate_input
iptables -t filter -A FORWARD -j delegate_forward
iptables -t filter -A OUTPUT -j delegate_output

iptables -t filter -A delegate_forward -m comment --comment "user chain for forwarding" -j forwarding_rule
iptables -t filter -A delegate_forward -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
iptables -t filter -A delegate_forward -i br-${lan_zone} -j zone_${lan_zone}_forward
fi
done
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t filter -A delegate_forward -i ${dev} -j zone_${wan_zone}_forward
fi
done

iptables -t filter -A delegate_forward -j reject
iptables -t filter -A delegate_input -i lo -j ACCEPT

iptables -t filter -A delegate_input -m comment --comment "user chain for input" -j input_rule
iptables -t filter -A delegate_input -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# iptables -t filter -A delegate_input -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn_flood
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
iptables -t filter -A delegate_input -i br-${lan_zone} -j zone_${lan_zone}_input
fi
done
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t filter -A delegate_input -i ${dev} -j zone_${wan_zone}_input
fi
done

iptables -t filter -A delegate_output -o lo -j ACCEPT
iptables -t filter -A delegate_output -m comment --comment "user chain for output" -j output_rule
iptables -t filter -A delegate_output -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
iptables -t filter -A delegate_output -o br-${lan_zone} -j zone_${lan_zone}_output
fi
done
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
iptables -t filter -A delegate_output -o ${dev} -j zone_${wan_zone}_output
fi
done

iptables -t filter -A reject -p tcp -j REJECT --reject-with tcp-reset
iptables -t filter -A reject -j REJECT --reject-with icmp-port-unreachable

iptables -t filter -A syn_flood -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m limit --limit 25/sec --limit-burst 50 -j RETURN
iptables -t filter -A syn_flood -j DROP

# lan type
for lan_zone in `echo "$base_firewall_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]') -eq 1 ]
then
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_lan_forward
done
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_dest_ACCEPT -o br-${lan_zone} -j ACCEPT
iptables -t filter -A zone_${lan_zone}_forward -m comment --comment "user chain for forwarding" -j forwarding_${lan_zone}_rule
	for wan_dest in `echo "$base_firewall_str" | jq -r '.["forwarding"]["'${lan_zone}'"]["dest"]'`
	do
[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${lan_zone}_forward -m state --state INVALID -j DROP
iptables -t filter -A zone_${lan_zone}_forward -m comment --comment "forwarding ${lan_zone} -> ${wan_dest}" -j zone_${wan_dest}_dest_ACCEPT
	done
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_forward -m conntrack --ctstate DNAT -m comment --comment "Accept port forwards" -j ACCEPT
if
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["forward"]')" = "ACCEPT" ]
then
iptables -t filter -A zone_${lan_zone}_forward -j zone_${lan_zone}_dest_ACCEPT
else
iptables -t filter -A zone_${lan_zone}_forward -j zone_${lan_zone}_dest_REJECT
fi

[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${lan_zone}_input -m state --state INVALID -j DROP
[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["syn_flood"]') -eq 1 ] && iptables -t filter -A zone_${lan_zone}_input -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn_flood
[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["allow_ping"]') -ne 1 ] && [ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["forward"]')" = "ACCEPT" ] && iptables -t filter -A zone_${lan_zone}_input -p icmp -m icmp --icmp-type 8 -j DROP
[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["allow_ping"]') -eq 1 ] && [ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["forward"]')" != "ACCEPT" ]  && iptables -t filter -A zone_${lan_zone}_input -p icmp -m icmp --icmp-type 8 -j ACCEPT

[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || [ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["accept_dhcp_68"]') -ne 1 ] || iptables -t filter -A zone_${lan_zone}_input -p udp -m udp --dport 68 -m comment --comment Allow-DHCP-Renew -j ACCEPT
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_lan_input
done
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["allow_ports"]' | grep -oE '(([0-9]*[ ]*)|([0-9]*:[0-9]*[ ]*)){15}' | sed -e 's/[ ][ ]*/,/g' -e 's/,$//g' | while read allow_ports
do
iptables -t filter -A zone_${lan_zone}_input -p tcp -m multiport --dport ${allow_ports} -j ACCEPT
iptables -t filter -A zone_${lan_zone}_input -p udp -m multiport --dport ${allow_ports} -j ACCEPT
done
iptables -t filter -A zone_${lan_zone}_input -m comment --comment "user chain for input" -j input_lan_rule
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_input -m conntrack --ctstate DNAT -m comment --comment "Accept port redirections" -j ACCEPT
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_input -j zone_${lan_zone}_src_ACCEPT && iptables -t filter -A zone_${lan_zone}_input -j zone_${lan_zone}_src_REJECT


echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_lan_output
done
[ $(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${lan_zone}_output -m state --state INVALID -j DROP
iptables -t filter -A zone_${lan_zone}_output -m comment --comment "user chain for output" -j output_${lan_zone}_rule
if
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["output"]')" = "ACCEPT" ]
then
iptables -t filter -A zone_${lan_zone}_output -j zone_${lan_zone}_dest_ACCEPT
else
iptables -t filter -A zone_${lan_zone}_output -j zone_${lan_zone}_dest_REJECT
fi
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_src_ACCEPT -i br-${lan_zone} -j ACCEPT
[ "$(echo "$base_firewall_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${lan_zone}_src_REJECT -i br-${lan_zone} -j reject
fi
done

# wan type
for wan_zone in `echo "$base_firewall_str" | jq '.["wan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
if
[ $(echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["enable"]') -eq 1 ]
then
dev=`echo "$netzone_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["dev"]'`
# [ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${wan_zone}_dest_ACCEPT -o ${dev} -j ACCEPT
([ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["output"]')" != "ACCEPT" ] && [ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" != "ACCEPT" ] ) || iptables -t filter -A zone_${wan_zone}_dest_ACCEPT -o ${dev} -j ACCEPT
([ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["output"]')" != "ACCEPT" ] && [ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" != "ACCEPT" ] ) || iptables -t filter -A zone_${wan_zone}_dest_REJECT -o ${dev} -j reject
# iptables -t filter -A zone_${wan_zone}_dest_REJECT -o ${dev} -j reject

echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_wan_forward
done
[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${wan_zone}_forward -m state --state INVALID -j DROP
iptables -t filter -A zone_${wan_zone}_forward -m comment --comment "user chain for forwarding" -j forwarding_${wan_zone}_rule
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${wan_zone}_forward -m conntrack --ctstate DNAT -m comment --comment "Accept port forwards" -j ACCEPT
if
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" = "ACCEPT" ]
then
iptables -t filter -A zone_${wan_zone}_forward -j zone_${wan_zone}_dest_ACCEPT
else
iptables -t filter -A zone_${wan_zone}_forward -j zone_${wan_zone}_dest_REJECT
fi

[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${wan_zone}_input -m state --state INVALID -j DROP
[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["syn_flood"]') -eq 1 ] && iptables -t filter -A zone_${wan_zone}_input -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn_flood
[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["allow_ping"]') -ne 1 ] && [ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" = "ACCEPT" ] && iptables -t filter -A zone_${wan_zone}_input -p icmp -m icmp --icmp-type 8 -j DROP
[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["allow_ping"]') -eq 1 ] && [ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["forward"]')" != "ACCEPT" ]  && iptables -t filter -A zone_${wan_zone}_input -p icmp -m icmp --icmp-type 8 -j ACCEPT
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || [ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["accept_dhcp_68"]') -ne 1 ] || iptables -t filter -A zone_${wan_zone}_input -p udp -m udp --dport 68 -m comment --comment Allow-DHCP-Renew -j ACCEPT
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_wan_input
done
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["allow_ports"]' | grep -oE '(([0-9]*[ ]*)|([0-9]*:[0-9]*[ ]*)){15}' | sed -e 's/[ ][ ]*/,/g' -e 's/,$//g' | while read allow_ports
do
iptables -t filter -A zone_${wan_zone}_input -p tcp -m multiport --dport ${allow_ports} -j ACCEPT
iptables -t filter -A zone_${wan_zone}_input -p udp -m multiport --dport ${allow_ports} -j ACCEPT
done
iptables -t filter -A zone_${wan_zone}_input -m comment --comment "user chain for input" -j input_${wan_zone}_rule
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${wan_zone}_input -m conntrack --ctstate DNAT -m comment --comment "Accept port redirections" -j ACCEPT
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] && iptables -t filter -A zone_${wan_zone}_input -j zone_${wan_zone}_src_ACCEPT || iptables -t filter -A zone_${wan_zone}_input -j zone_${wan_zone}_src_REJECT
echo "$firewall_extra" | while read firewall_extra_file
do
. ${firewall_extra_file}
do_filter_zone_wan_output
done
[ $(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["invalid_pkg"]') -eq 1 ] && iptables -t filter -A zone_${wan_zone}_output -m state --state INVALID -j DROP
iptables -t filter -A zone_${wan_zone}_output -m comment --comment "user chain for output" -j output_${wan_zone}_rule
if
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["output"]')" = "ACCEPT" ]
then
iptables -t filter -A zone_${wan_zone}_output -j zone_${wan_zone}_dest_ACCEPT
else
iptables -t filter -A zone_${wan_zone}_output -j zone_${wan_zone}_dest_REJECT
fi

[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${wan_zone}_src_ACCEPT -i ${dev} -j ACCEPT
[ "$(echo "$base_firewall_str" | jq -r '.["wan_zone"]["'${wan_zone}'"]["input"]')" = "ACCEPT" ] || iptables -t filter -A zone_${wan_zone}_src_REJECT -i ${dev} -j reject

fi
done
}
make_lan_down()
{
for dev in `cat /proc/net/dev | grep  ":" | sed 's/:.*//' | grep -Po '[\w].*[\w]' | grep "^br-"`
do
ifconfig ${dev} down
brctl delbr ${dev}
done
}
make_lan_up()
{
for lan_zone in `echo "$netzone_str" | jq '.["lan_zone"] | keys' | grep -Po '[\w].*[\w]'`
do
[ `echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["enable"]'` -ne 1 ] && continue
brctl addbr br-${lan_zone}
	for dev in `echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["dev"]'`
	do
		ifconfig ${dev} down
		brctl addif br-${lan_zone} ${dev}
		ifconfig ${dev} up promisc
	done
	ifconfig br-${lan_zone} `echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["ip"]'` netmask `echo "$netzone_str" | jq -r '.["lan_zone"]["'${lan_zone}'"]["netmask"]'` up
done
}

firewall_restart()
{
make_lan_down
make_lan_up
clean_iptables
add_default_chains
add_netzone_chains
deel_chains
}
firewall_stop()
{
clean_iptables
default_policy
}
firewall_start()
{
make_lan_down
make_lan_up
default_policy
add_default_chains
add_netzone_chains
deel_chains
}
# make_lan_down
# make_lan_up
# clean_iptables
# add_default_chains
# add_netzone_chains
# deel_chains
