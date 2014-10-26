#!/bin/sh
# DEBUG=1
# export DEBUG
# eval `proccgi.cgi $* 2> /tmp/proccgi.log`
# eval `proccgi.cgi $*`
eval "`proccgi $*`"

[ -z "$FORM_app" ] && export FORM_app=home
main.sbin go_app
