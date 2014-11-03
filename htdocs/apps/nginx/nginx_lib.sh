#!/bin/sh

debian_ubuntu_init()
{
cat <<'EOF' > /etc/init.d/nginx
#!/bin/sh

### BEGIN INIT INFO
# Provides:           nginx
# Required-Start:     $local_fs $remote_fs $network $syslog $named
# Required-Stop:      $local_fs $remote_fs $network $syslog $named
# Default-Start:      2 3 4 5
# Default-Stop:       0 1 6
# Short-Description:  nginx LSB init script
# Description:        nginx Linux Standards Base compliant init script.
### END INIT INFO

# -----------------------------------------------------------------------------
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# nginx Linux Standards Base compliant init script.
#
# LINK:       https://wiki.debian.org/LSBInitScripts
# IDEAS BY:   Karl Blessing <http://kbeezie.com/debian-ubuntu-nginx-init-script/>
# AUTHOR:     Richard Fussenegger <richard@fussenegger.info>
# COPYRIGHT:  Copyright (c) 2013 Richard Fussenegger
# LICENSE:    http://unlicense.org/ PD
# LINK:       http://richard.fussenegger.info/
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
#                                                                      Includes
# -----------------------------------------------------------------------------


# Load the LSB log_* functions.
. /lib/lsb/init-functions


# -----------------------------------------------------------------------------
#                                                                     Variables
# -----------------------------------------------------------------------------


# The name of the service (must be the first variable).
NAME="nginx"

# Absolute path to the executable.
#DAEMON="/usr/local/sbin/${NAME}"
DAEMON="/usr/local/nginx/sbin/${NAME}"

# Arguments that should be passed to the executable.
DAEMON_ARGS=""

# Absolute path to the PID file.
#PIDFILE="/run/${NAME}.pid"
PIDFILE="/var/run/nginx/${NAME}.pid"


# -----------------------------------------------------------------------------
#                                                                     Bootstrap
# -----------------------------------------------------------------------------


# Check return status of EVERY command
set -e

# Check if ${NAME} is a file and executable, if not assume it's not installed.
if [ ! -x ${DAEMON} ]; then
  log_failure_msg ${NAME} "not installed"
  exit 1
fi

# This script is only accessible for root (sudo).
if [ $(id -u) != 0 ]; then
  log_failure_msg "super user only!"
  exit 1
fi

# Always check if service is already running.
RUNNING=$(start-stop-daemon --start --quiet --pidfile ${PIDFILE} --exec ${DAEMON} --test && echo "false" || echo "true")


# -----------------------------------------------------------------------------
#                                                                     Functions
# -----------------------------------------------------------------------------


###
# Reloads the service.
#
# RETURN:
#   0 - successfully reloaded
#   1 - reloading failed
###
reload_service() {
  start-stop-daemon --stop --signal HUP --quiet --pidfile ${PIDFILE} --exec ${DAEMON}
}

###
# Starts the service.
#
# RETURN:
#   0 - successfully started
#   1 - starting failed
###
start_service() {
  start-stop-daemon --start --quiet --pidfile ${PIDFILE} --exec ${DAEMON} -- ${DAEMON_ARGS}
}

###
# Stops the service.
#
# RETURN:
#   0 - successfully stopped
#   1 - stopping failed
###
stop_service() {
  start-stop-daemon --stop --quiet --pidfile ${PIDFILE} --name ${NAME}
}


# -----------------------------------------------------------------------------
#                                                                  Handle Input
# -----------------------------------------------------------------------------


case ${1} in

  force-reload|reload)
    if [ ${RUNNING} = "false" ]; then
      log_failure_msg ${NAME} "not running"
    else
      log_daemon_msg ${NAME} "reloading configuration"
      reload_service || log_end_msg 1
      log_end_msg 0
    fi
  ;;

  restart)
    if [ ${RUNNING} = "false" ]; then
      log_failure_msg ${NAME} "not running"
	  start_service || log_end_msg 1
	  log_end_msg 0
    else
      log_daemon_msg ${NAME} "restarting"
      stop_service || log_end_msg 1
      sleep 0.1
      start_service || log_end_msg 1
      log_end_msg 0
    fi
  ;;

  start)
    if [ ${RUNNING} = "true" ]; then
      log_success_msg ${NAME} "already started"
    else
      log_daemon_msg ${NAME} "starting"
      start_service || log_end_msg 1
      log_end_msg 0
    fi
  ;;

  status)
    status_of_proc ${DAEMON} ${NAME} && exit 0 || exit ${?}
  ;;

  stop)
    if [ ${RUNNING} = "false" ]; then
      log_success_msg ${NAME} "already stopped"
    else
      log_daemon_msg ${NAME} "stopping"
      stop_service && log_end_msg 0 || log_end_msg 1
    fi
  ;;

  *)
    echo "Usage: ${NAME} {force-reload|reload|restart|start|status|stop}" >&2
    exit 1
  ;;

esac
:

exit 0

EOF
chmod +x /etc/init.d/nginx
}

centos_init()
{
cat <<'EOF' > /etc/init.d/nginx
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemon
#
# chkconfig:   - 85 15 
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /etc/nginx/nginx.conf
# config:      /etc/sysconfig/nginx
# pidfile:     /var/run/nginx.pid
 
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0
 
nginx="/usr/local/nginx/sbin/nginx"
prog=$(basename $nginx)
 
NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"
 
[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx
 
lockfile=/var/lock/subsys/nginx
 
make_dirs() {
   # make required directories
   user=`$nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=\([^ ]*\).*/\1/g' -`
   if [ -z "`grep $user /etc/passwd`" ]; then
       useradd -M -s /bin/nologin $user
   fi
   options=`$nginx -V 2>&1 | grep 'configure arguments:'`
   for opt in $options; do
       if [ `echo $opt | grep '.*-temp-path'` ]; then
           value=`echo $opt | cut -d "=" -f 2`
           if [ ! -d "$value" ]; then
               # echo "creating" $value
               mkdir -p $value && chown -R $user $value
           fi
       fi
   done
}
 
start() {
    [ -x $nginx ] || exit 5
    [ -f $NGINX_CONF_FILE ] || exit 6
    make_dirs
    echo -n $"Starting $prog: "
    daemon $nginx -c $NGINX_CONF_FILE
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}
 
stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -QUIT
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}
 
restart() {
    configtest || return $?
    stop
    sleep 1
    start
}
 
reload() {
    configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $nginx -HUP
    RETVAL=$?
    echo
}
 
force_reload() {
    restart
}
 
configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}
 
rh_status() {
    status $prog
}
 
rh_status_q() {
    rh_status >/dev/null 2>&1
}
 
case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac
EOF
chmod +x /etc/init.d/nginx
}

download_nginx()
{
export download_json='{
"file_name":"nginx-1.6.2.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/nginx-1.6.2.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"d1b55031ae6e4bce37f8776b94d8b930",
	"download_urls":{
	"nginx.org":"http://nginx.org/download/nginx-1.6.2.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/nginx-1.6.2.tar.gz | awk {'print $1'})" != "d1b55031ae6e4bce37f8776b94d8b930" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/nginx-1.6.2.tar.gz
# $DOCUMENT_ROOT/../bin/aria2c http://nginx.org/download/nginx-1.6.2.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}

make_nginx()
{
eval `cat $DOCUMENT_ROOT/../tmp/nginx.config.tmp`
[ -n "$use_jemalloc" ] || jemalloc_used="--with-ld-opt=\"-ljemalloc\""
cd $DOCUMENT_ROOT/../sources/
rm -rf nginx-1.6.2
tar zxvf nginx-1.6.2.tar.gz
cd nginx-1.6.2
useradd www
[ -n "$http_header_version" ] && [ "$http_header_version" != "default" ] && sed -i "s/#define NGINX_VERSION[ ]*".*"/#define NGINX_VERSION        \"$http_header_version\"/" src/core/nginx.h
[ -n "$http_header" ] && [ "$http_header" != "default" ] && sed -i "s/#define NGINX_VER[ ]*".*"[ ]*NGINX_VERSION/#define NGINX_VER        \"$http_header\" NGINX_VERSION/" src/core/nginx.h && sed -i "s/[ ]*nginx\//    $http_header\//" conf/fastcgi.conf
./configure --user=www \
--group=www \
--prefix=/usr/local/nginx  \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--with-http_stub_status_module \
--with-http_ssl_module --with-pcre \
--with-http_realip_module \
--with-http_gzip_static_module \
--with-file-aio \
--with-ipv6 $jemalloc_used && make && make install


echo "$OS" | grep -i "centos" && centos_init && chkconfig --add nginx && chkconfig nginx on
echo "$OS" | grep -i "ubuntu" && debian_ubuntu_init && update-rc.d -f nginx defaults #remove
echo "$OS" | grep -i "debian" && debian_ubuntu_init && update-rc.d -f nginx defaults
mkdir -p /data/htdocs/www && chown www /data/htdocs/
service nginx start
}

config_nginx_default()
{
sysinfo_gen
echo "{}" | jq '.["system"] = {"user":{"username":"www","groupname":"www"},"worker_processes":"'`cat $DOCUMENT_ROOT/../tmp/sysinfo.json | jq -r '.["sysinfo"]["cpu"]["cores"]'`'","error_log":"/var/log/nginx/nginx.log","error_log_level":"crit","worker_rlimit_nofile":"65535"}' > $DOCUMENT_ROOT/apps/nginx/nginx_config.json

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`
echo "$config_str" | jq '.["events"] = {"use":"epoll","worker_connections":"65535"}' > $DOCUMENT_ROOT/apps/nginx/nginx_config.json

config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`
echo "$config_str" | jq '.["http"] = {"include":"mime.types","default_type":"application/octet-stream","charset":"utf-8","autoindex":"off","server_names_hash_bucket_size":"128","client_header_buffer_size":"32k","large_client_header_buffers":"4 32k","client_max_body_size":"8m","sendfile":"on","tcp_nopush":"on","tcp_nodelay":"on","keepalive_timeout":"60","fastcgi_connect_timeout":"300","fastcgi_send_timeout":"300","fastcgi_read_timeout":"300","fastcgi_buffer_size":"64k","fastcgi_buffers":"4 64k","fastcgi_busy_buffers_size":"128k","fastcgi_temp_file_write_size":"128k","gzip":"on","gzip_min_length":"1k","gzip_buffers":"4 16k","gzip_http_version":"1.0","gzip_comp_level":"2","gzip_types":"text/plain application/x-javascript text/css application/xml","gzip_vary":"off",}' > $DOCUMENT_ROOT/apps/nginx/nginx_config.json

}
config_vhost_default()
{
echo "{}" | jq '.["default"] = {"listen":{"ip":"","port":"80"},"server_name":"","create_time":"'"`date +%Y-%m-%d" "%H:%M:%S`"'","index":"index.html index.htm","root":"/data/htdocs/www","ssl":"off","ssl_certificate":"","ssl_certificate_key":""}' > $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json

}


generate_nginx_config()
{
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`
echo "$config_str" | jq '.' >/dev/null 2>1 || exit 1
vhost_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_vhost.json`
echo "$vhost_str" | jq '.' >/dev/null 2>1 || exit 1
cat <<EOF >/usr/local/nginx/conf/nginx.conf
user  `echo "$config_str" | jq -r '.["system"]["user"]["username"]'` `echo "$config_str" | jq -r '.["system"]["user"]["groupname"]'`;
worker_processes `echo "$config_str" | jq -r '.["system"]["worker_processes"]'`;
error_log `echo "$config_str" | jq -r '.["system"]["error_log"]'` `echo "$config_str" | jq -r '.["system"]["error_log_level"]'`;
worker_rlimit_nofile `echo "$config_str" | jq -r '.["system"]["worker_rlimit_nofile"]'`;
events
{
use `echo "$config_str" | jq -r '.["events"]["use"]'`;
worker_connections `echo "$config_str" | jq -r '.["events"]["worker_connections"]'`;
}
http
{
include `echo "$config_str" | jq -r '.["http"]["include"]'`;
default_type `echo "$config_str" | jq -r '.["http"]["default_type"]'`;
EOF

for log_file in `find $DOCUMENT_ROOT/apps/nginx/log_tpl -maxdepth 1 -type f`
do
cat ${log_file} >>/usr/local/nginx/conf/nginx.conf
echo '' >>/usr/local/nginx/conf/nginx.conf
done
charset=`echo "$config_str" | jq -r '.["http"]["charset"]'`
[ -n "$charset" ] && [ "$charset" != "null" ] && echo "charset $charset;" >>/usr/local/nginx/conf/nginx.conf
server_names_hash_bucket_size=`echo "$config_str" | jq -r '.["http"]["server_names_hash_bucket_size"]'`
[ -n "$server_names_hash_bucket_size" ] && [ "$server_names_hash_bucket_size" != "null" ] && echo "server_names_hash_bucket_size $server_names_hash_bucket_size;" >>/usr/local/nginx/conf/nginx.conf
client_header_buffer_size=`echo "$config_str" | jq -r '.["http"]["client_header_buffer_size"]'`
[ -n "$client_header_buffer_size" ] && [ "$client_header_buffer_size" != "null" ] && echo "client_header_buffer_size $client_header_buffer_size;" >>/usr/local/nginx/conf/nginx.conf
large_client_header_buffers=`echo "$config_str" | jq -r '.["http"]["large_client_header_buffers"]'`
[ -n "$large_client_header_buffers" ] && [ "$large_client_header_buffers" != "null" ] && echo "large_client_header_buffers $large_client_header_buffers;" >>/usr/local/nginx/conf/nginx.conf
client_max_body_size=`echo "$config_str" | jq -r '.["http"]["client_max_body_size"]'`
[ -n "$client_max_body_size" ] && [ "$client_max_body_size" != "null" ] && echo "client_max_body_size $client_max_body_size;" >>/usr/local/nginx/conf/nginx.conf
sendfile=`echo "$config_str" | jq -r '.["http"]["sendfile"]'`
[ -n "$sendfile" ] && [ "$sendfile" != "null" ] && echo "sendfile $sendfile;" >>/usr/local/nginx/conf/nginx.conf
autoindex=`echo "$config_str" | jq -r '.["http"]["autoindex"]'`
[ -n "$autoindex" ] && [ "$autoindex" != "null" ] && echo "autoindex $autoindex;" >>/usr/local/nginx/conf/nginx.conf
tcp_nopush=`echo "$config_str" | jq -r '.["http"]["tcp_nopush"]'`
[ -n "$tcp_nopush" ] && [ "$tcp_nopush" != "null" ] && echo "tcp_nopush $tcp_nopush;" >>/usr/local/nginx/conf/nginx.conf
tcp_nodelay=`echo "$config_str" | jq -r '.["http"]["tcp_nodelay"]'`
[ -n "$tcp_nodelay" ] && [ "$tcp_nodelay" != "null" ] && echo "tcp_nodelay $tcp_nodelay;" >>/usr/local/nginx/conf/nginx.conf
keepalive_timeout=`echo "$config_str" | jq -r '.["http"]["keepalive_timeout"]'`
[ -n "$keepalive_timeout" ] && [ "$keepalive_timeout" != "null" ] && echo "keepalive_timeout $keepalive_timeout;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_connect_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_connect_timeout"]'`
[ -n "$fastcgi_connect_timeout" ] && [ "$fastcgi_connect_timeout" != "null" ] && echo "fastcgi_connect_timeout $fastcgi_connect_timeout;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_send_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_send_timeout"]'`
[ -n "$fastcgi_send_timeout" ] && [ "$fastcgi_send_timeout" != "null" ] && echo "fastcgi_send_timeout $fastcgi_send_timeout;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_read_timeout=`echo "$config_str" | jq -r '.["http"]["fastcgi_read_timeout"]'`
[ -n "$fastcgi_read_timeout" ] && [ "$fastcgi_read_timeout" != "null" ] && echo "fastcgi_read_timeout $fastcgi_read_timeout;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_buffer_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_buffer_size"]'`
[ -n "$fastcgi_buffer_size" ] && [ "$fastcgi_buffer_size" != "null" ] && echo "fastcgi_buffer_size $fastcgi_buffer_size;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_buffers=`echo "$config_str" | jq -r '.["http"]["fastcgi_buffers"]'`
[ -n "$fastcgi_buffers" ] && [ "$fastcgi_buffers" != "null" ] && echo "fastcgi_buffers $fastcgi_buffers;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_busy_buffers_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_busy_buffers_size"]'`
[ -n "$fastcgi_busy_buffers_size" ] && [ "$fastcgi_busy_buffers_size" != "null" ] && echo "fastcgi_busy_buffers_size $fastcgi_busy_buffers_size;" >>/usr/local/nginx/conf/nginx.conf
fastcgi_temp_file_write_size=`echo "$config_str" | jq -r '.["http"]["fastcgi_temp_file_write_size"]'`
[ -n "$fastcgi_temp_file_write_size" ] && [ "$fastcgi_temp_file_write_size" != "null" ] && echo "fastcgi_temp_file_write_size $fastcgi_temp_file_write_size;" >>/usr/local/nginx/conf/nginx.conf
gzip=`echo "$config_str" | jq -r '.["http"]["gzip"]'`
[ -n "$gzip" ] && [ "$gzip" != "null" ] && echo "gzip $gzip;" >>/usr/local/nginx/conf/nginx.conf
gzip_min_length=`echo "$config_str" | jq -r '.["http"]["gzip_min_length"]'`
[ -n "$gzip_min_length" ] && [ "$gzip_min_length" != "null" ] && echo "gzip_min_length $gzip_min_length;" >>/usr/local/nginx/conf/nginx.conf
gzip_buffers=`echo "$config_str" | jq -r '.["http"]["gzip_buffers"]'`
[ -n "$gzip_buffers" ] && [ "$gzip_buffers" != "null" ] && echo "gzip_buffers $gzip_buffers;" >>/usr/local/nginx/conf/nginx.conf
gzip_http_version=`echo "$config_str" | jq -r '.["http"]["gzip_http_version"]'`
[ -n "$gzip_http_version" ] && [ "$gzip_http_version" != "null" ] && echo "gzip_http_version $gzip_http_version;" >>/usr/local/nginx/conf/nginx.conf
gzip_comp_level=`echo "$config_str" | jq -r '.["http"]["gzip_comp_level"]'`
[ -n "$gzip_comp_level" ] && [ "$gzip_comp_level" != "null" ] && echo "gzip_comp_level $gzip_comp_level;" >>/usr/local/nginx/conf/nginx.conf
gzip_types=`echo "$config_str" | jq -r '.["http"]["gzip_types"]'`
[ -n "$gzip_types" ] && [ "$gzip_types" != "null" ] && echo "gzip_types $gzip_types;" >>/usr/local/nginx/conf/nginx.conf
gzip_vary=`echo "$config_str" | jq -r '.["http"]["gzip_vary"]'`
[ -n "$gzip_vary" ] && [ "$gzip_vary" != "null" ] && echo "gzip_vary $gzip_vary;" >>/usr/local/nginx/conf/nginx.conf

for vhost in `echo "$vhost_str"  | jq '. | keys' | grep -Po '[\w].*[\w]'`
do
ip=`echo "$vhost_str"  | jq -r '.["'${vhost}'"]["listen"]["ip"]'`
[ -n "$ip" ] && [ "$ip" != "null" ] && ip="$ip:" || ip=""
cat <<EOF >>/usr/local/nginx/conf/nginx.conf
server
{
listen $ip`echo "$vhost_str"  | jq -r '.["'${vhost}'"]["listen"]["port"]'`;
EOF
server_name=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["server_name"]'`
[ -n "$server_name" ] && [ "$server_name" != "null" ] && echo "server_name $server_name;" >>/usr/local/nginx/conf/nginx.conf
index=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["index"]'`
[ -n "$index" ] && [ "$index" != "null" ] && echo "index $index;" >>/usr/local/nginx/conf/nginx.conf
root=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["root"]'`
[ -n "$root" ] && [ "$root" != "null" ] && echo "root $root;" >>/usr/local/nginx/conf/nginx.conf

disabled_option=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["disabled_option"]'`
[ -n "$disabled_option" ] && [ "$disabled_option" != "null" ] && echo "$disabled_option;" >>/usr/local/nginx/conf/nginx.conf && echo '}' >>/usr/local/nginx/conf/nginx.conf  && continue

ssl=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["ssl"]'`
[ -n "$ssl" ] && [ "$ssl" != "null" ] && [ "$ssl" != "off" ] && echo "ssl $ssl;" >>/usr/local/nginx/conf/nginx.conf
ssl_certificate=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["ssl_certificate"]'`
[ -n "$ssl_certificate" ] && [ "$ssl_certificate" != "null" ] && echo "ssl_certificate $ssl_certificate;" >>/usr/local/nginx/conf/nginx.conf
ssl_certificate_key=`echo "$vhost_str" | jq -r '.["'${vhost}'"]["ssl_certificate_key"]'`
[ -n "$ssl_certificate_key" ] && [ "$ssl_certificate_key" != "null" ] && echo "ssl_certificate_key $ssl_certificate_key;" >>/usr/local/nginx/conf/nginx.conf
[ -f $DOCUMENT_ROOT/apps/nginx/extra_config/${vhost}.config ] && echo '' >>/usr/local/nginx/conf/nginx.conf &&\
cat $DOCUMENT_ROOT/apps/nginx/extra_config/${vhost}.config >>/usr/local/nginx/conf/nginx.conf &&\
echo '' >>/usr/local/nginx/conf/nginx.conf 
echo '}' >>/usr/local/nginx/conf/nginx.conf 
done
echo '}' >>/usr/local/nginx/conf/nginx.conf
service nginx reload > /dev/null 2>&1 &
}
pre_install_nginx()
{
echo "$_LANG_Ready_to_Install"

eval `cat $DOCUMENT_ROOT/../tmp/nginx.config.tmp`
cat <<'EOF'
<script>
$(function(){
  $('#pre_nginx_install_config').on('submit', function(e){
    e.preventDefault();
    var data = "app=nginx&"+$(this).serialize();
    var url = 'index.cgi';
    Ha.common.ajax(url, 'json', data, 'post', 'ajax-proxy');
  });
});
</script>
EOF
cat <<EOF
<form id="pre_nginx_install_config">
<table class="table">
<tr>
<td>
Use jemalloc
</td>
<td>
<input type="checkbox" selected="" name="use_jemalloc" value="1" `[ -n "$use_jemalloc" ] && echo checked`>
</td>
</tr>
<tr>
<td>
$_LANG_Datadir
</td>
<td>
<input type="text" class="form-control" name="datadir" placeholder="/data/htdocs" value="`[ -n "$datadir" ] && echo "$datadir" || echo "/data/htdocs"`">
</td>
</tr>
<tr>
<td>
$_LANG_http_header
</td>
<td>
<input type="text" class="form-control" name="http_header" placeholder="nginx" value="`[ -n "$http_header" ] && echo "$http_header" || echo "default"`">
</td>
</tr>
<tr>
<td>
$_LANG_header_version
</td>
<td>
<input type="text" class="form-control" name="http_header_version" placeholder="1.0.0" value="`[ -n "$http_header_version" ] && echo "$http_header_version" || echo "default"`">
</td>
</tr>
<tr>
<td>
$_LANG_Option
</td>
<td>
<input type="hidden" name="action" value="pre_nginx_install_config">
<button type="submit" class="btn btn-info">$_LANG_Save</button>
</td>
</tr>

</table>
</form>
EOF

}
pre_nginx_install_config()
{
echo "$FORM_datadir" | grep -q "^/" || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "$FORM_datadir" | main.sbin regx_str ispath || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
echo "datadir=$FORM_datadir" > $DOCUMENT_ROOT/../tmp/nginx.config.tmp
echo "use_jemalloc=$FORM_use_jemalloc" >> $DOCUMENT_ROOT/../tmp/nginx.config.tmp
if
[ -n "$FORM_http_header" ] && echo "$FORM_http_header" | grep -q ' '
then
(echo "$_LANG_http_header $_LANG_Cant_with_blank" | main.sbin output_json 1) || exit 1
fi
echo "http_header=$FORM_http_header" >> $DOCUMENT_ROOT/../tmp/nginx.config.tmp
if
[ -n "$FORM_http_header_version" ] && echo "$FORM_http_header_version" | grep -q ' '
then
(echo "$_LANG_header_version $_LANG_Cant_with_blank" | main.sbin output_json 1) || exit 1
fi
echo "http_header_version=$FORM_http_header_version" >> $DOCUMENT_ROOT/../tmp/nginx.config.tmp

(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
check_nginx_installed()
{
if
[ -x /usr/local/nginx/sbin/nginx ]
then
return 0
else
return 1
fi
}
install_nginx()
{
check_nginx_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_nginx" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log ] || do_install_nginx &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_nginx"
get_pregress_schedule_notice_detail
}
do_install_nginx()
{
check_nginx_installed && echo "nginx binary installed" && exit 1
pid_80=`netstat -tlnp | grep ":80[ ]*" | awk {'print $NF'} | sed 's/\/.*//'`
old_service=`netstat -tlnp | grep ":80[ ]*" | awk {'print $NF'} | sed 's/.*\///'`
[ -n "$pid_80" ] && kill -9 $pid_80
echo "$OS" | grep -iq "centos" && chkconfig --add $old_service && chkconfig $old_service off 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f $old_service remove 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f $old_service remove 2>&1
touch $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_nginx" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_Nginx_Dependence\":\"0\",\"_PS_3_Make_install_Nginx\":\"0\",\"_PS_4_Config_Nginx\":\"0\",\"_PS_5_Nginx_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/nginx_ins_detail.log" app="nginx" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="30"
download_nginx > $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_nginx" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_2_Make_install_Nginx_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="45"
# install_nginx_dependence > $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_3_Make_install_Nginx"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="60"
make_nginx >> $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log 2>&1

if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_nginx" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_4_Config_Nginx"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="80"
config_nginx >> $DOCUMENT_ROOT/../tmp/nginx_ins_detail.log 2>&1
mkdir /var/log/nginx/
useradd www
chown www /var/log/nginx/
cp -R $DOCUMENT_ROOT/apps/nginx/rewrite /usr/local/nginx/conf
main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_5_Nginx_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_nginx" schedule_now="_PS_5_Nginx_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_nginx" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_nginx" status_now="success"

}
config_nginx()
{
echo "$OS" | grep -i "centos" && centos_init && chkconfig --add nginx && chkconfig nginx on
echo "$OS" | grep -i "ubuntu" && debian_ubuntu_init && update-rc.d -f nginx defaults #remove
echo "$OS" | grep -i "debian" && debian_ubuntu_init && update-rc.d -f nginx defaults
config_nginx_default
config_vhost_default
generate_nginx_config
}
nginx_service()
{
if
[ "$FORM_nginx_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add nginx && chkconfig nginx on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f nginx defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f nginx defaults >/dev/null 2>&1
service nginx start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_service_enable" \
				detail="_NOTICE_nginx_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="nginx" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add nginx && chkconfig nginx off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f nginx remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f nginx remove >/dev/null 2>&1
service nginx stop >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_nginx_service_disable" \
				detail="_NOTICE_nginx_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="nginx" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}
nginx_access_log()
{
echo "<label>/usr/local/nginx/logs/access.log</label>"
echo "<pre>"
tail -n 200 /usr/local/nginx/logs/access.log
echo "</pre>"

}
nginx_error_log()
{
config_str=`cat $DOCUMENT_ROOT/apps/nginx/nginx_config.json`
echo "<label>$(echo "$config_str" | jq -r '.["system"]["error_log"]')</label>"
echo "<pre>"
tail -n 200 $(echo "$config_str" | jq -r '.["system"]["error_log"]')
echo "</pre>"

}

. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh


