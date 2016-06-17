#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-07 - WmX - Create this script
##
_MYUSER="$(id -u -n)"
echo $_MYUSER@$(hostname)"\t#$(date +"%Y-%m-%d %H:%M:%S")\t#\c"
SSHIP=`echo $SSH_CLIENT | awk '{printf $1}'`
[ -z "$SSHIP" ] && echo `hostname --ip-address` || echo $SSHIP
