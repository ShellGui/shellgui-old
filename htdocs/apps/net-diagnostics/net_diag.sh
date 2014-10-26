#!/bin/sh
case $1 in
ping)
ping -c $2 $3 2>&1
;;
traceroute)
traceroute $2 2>&1
;;
nslookup)
nslookup $2 2>&1
;;
esac