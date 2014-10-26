#!/bin/sh


curl_load()
{
eval `echo $@ | sed 's/[ ][ ]*/\n/g' | grep "="`
eval `cat $DOCUMENT_ROOT/apps/curl/curl.conf`
if
[ "$proxy_mod" = "http" ]
then
[ -n "$proxy_server" ] && [ -n "$proxy_port" ] && curl_args="$curl_args --proxy $proxy_server:$proxy_port"
elif
[ "$proxy_mod" = "socks5" ]
then
[ -n "$proxy_server" ] && [ -n "$proxy_port" ] && curl_args="$curl_args --socks5 $proxy_server:$proxy_port"
fi
[ -n "$proxy_username" ] && [ -n "$proxy_password" ] && curl_args="$curl_args -u $proxy_username:$proxy_password"
[ -n "$speed_time" ] && curl_args="$curl_args --speed-time $speed_time"
[ -n "$speed_limit" ] && curl_args="$curl_args --speed-limit $speed_limit"
[ -n "$connect_timeout" ] && curl_args="$curl_args --connect-timeout $connect_timeout"
[ $no_max_time -ne 1 ] && [ -n "$max_time" ] && curl_args="$curl_args --max-time $max_time"
[ -n "$insecure" ] && curl_args="$curl_args --insecure"
}
