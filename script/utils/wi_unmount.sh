#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-05-20 - WmX - Create this script
##
udisks --unmount /dev/sd"$1"1 && udisks --detach /dev/sd"$1"
