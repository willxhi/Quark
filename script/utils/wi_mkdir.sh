#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-02 - WmX - Create this script
##
if [ -z "$1" ] 
then
  echo "No argument supplied - $(date)"
else
  if [ ! -d "$1" ]; then
    echo "*create $1 \t $(date)";
    mkdir -p $1; 
  else
    if [ "$2" = "trace" ]; then
      echo "*already exists $1 \t $(date)";
    fi
  fi 
fi

