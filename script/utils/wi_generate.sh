#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-07 - William Xhinar - Create this script
##
usage ()
{
  echo 'Usage : wi_generate.sh $1 $2'
  echo '\t$1 = new script content to copy to template'
  echo '\t$2 = new file generated with template and content' 
  exit
}

main ()
{

sed -n '1,16p' $_MYDIR/wi_template.sh > $2
cat $1 >> $2
sed -n '17,24p' <$_MYDIR/wi_template.sh >>$2
}

_MYDIR=$(dirname $(readlink -f $0))
_MYNAME=`basename $0`

LOGDIR=/mnt/backup/svr/logs/$(date +"%Y/%m/%d")
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
echo $LOGFILE
(
[ "$#" -ne 2 ] && ( usage && exit 1 ) || main $1 $2
) | tee $LOGFILE
