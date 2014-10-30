#!/bin/sh

logs_path="/usr/local/nginx/logs/"
logs_repo_path="$(/root/shellcgi/bin/main.sbin where_DOCUMENT_ROOT)/apps/nginx/log_repo"
mv ${logs_path}/access.log ${logs_repo_path}/access_$(date +"%Y-%m-%d_%H:%M:%S").log 

kill -USR1 `cat /var/run/nginx/nginx.pid`