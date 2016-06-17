#!/bin/sh
_MYFNAME=$(readlink -f $0)
_MYSNAME=`basename "$0"`
_MYONAME=${_MYSNAME%.*}
_MYENAME=${_MYSNAME#*.}
_MYDIR=$(dirname $(readlink -f $0))
echo "My fullname  is "$_MYFNAME
echo "My shortname is "$_MYSNAME
echo "My only name is "$_MYONAME
echo "My extention is "$_MYENAME
echo "My directory is "$_MYDIR
