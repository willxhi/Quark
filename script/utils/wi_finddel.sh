#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-05-12 - WmX - Create this script
##
usage(){
    echo "Usage: \$1 path to search"
    echo "       \$2 pattern : .*(0[2-9]|1[0-5])\.tgz"
    echo "       \$3 mode"
    echo "		 list       : find \$1 -type f -regextype posix-extended -regex \$2"
    echo "		 listdepthx : find \$1 -maxdepth \${3:\$(expr \${#3} - 1):1} | more"
    echo "		 listnot    : find \$1 -type f -regextype posix-extended ! -regex \$2"
    echo "		 delete     : find \$1 -type f -regextype posix-extended -regex \$2 -delete"
    echo "		 trace      : echo \"1. \"\$1; echo \"2. \"\$2; echo \"3. \"\$3"
 
    exit 1
}

[[ $# -eq 0 ]] && usage

if [ "$3" = "list" ]; then	
	find $1 -type f -regextype posix-extended -regex $2
elif [ "${3:0:9}" = "listdepth" ];  then
  find $1 -maxdepth ${3:$(expr ${#3} - 1):1} -exec ls -alh {} \; | more
elif [ "$3" = "listnot" ]; then
	find $1 -type f -regextype posix-extended ! -regex $2
elif [ "$3" = "delete" ]; then
	find $1 -type f -regextype posix-extended -regex $2 -delete
elif [ "${3:0:5}" = "trace" ]; then
	echo "\$1		=  "$1
	echo "\$2		=  "$2
  echo "\$3		=  "$3
	echo "\$3:"$(expr ${#3} - 1)":1 = "${3:$(expr ${#3} - 1):1}
fi
