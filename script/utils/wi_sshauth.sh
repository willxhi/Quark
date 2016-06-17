#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-01-18 - WmX - Create this script
##
#$1=port $2=user $3=ip addr
#cat .ssh/id_rsa.pub | ssh -p 22 root@192.168.51.55 'cat >> .ssh/authorized_keys'

usage(){
    echo "Usage: \$1 port"
    echo "       \$2 user"
    echo "       \$3 ip address"
    exit 1
}
[[ $# -eq 0 ]] && usage
cat .ssh/id_rsa.pub | ssh -p $1 $2@$3 'cat >> .ssh/authorized_keys'

