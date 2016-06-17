#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-02-02 - WmX - Create this script
##
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
_MYNAME=`basename $0`
LOGDIR=$_MYDIR/logs/$(date +"%Y/%m/%d")
$_MYDIR/utils/wi_mkdir.sh $LOGDIR
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
(
$_MYDIR/utils/wi_headlog.sh $LOGDIR
c_begin_time_sec=`date +%s`
echo -e "*init \t $(date)"
DUMPPROXDIR=/var/lib/vz/dump/
BCKDIR=$_MYPARENTDIR/backup
THISMONTH=$(date +"%Y/%m")
CURRBCKDIR=$BCKDIR/51.210/dump/$THISMONTH/
getit(){
  $_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
  rsync -avhPW root@192.168.51.210:$DUMPPROXDIR/$1 $CURRBCKDIR
}
getit "vzdump-qemu-104*.vma.lzo"  #104.ledypos
getit "vzdump-qemu-108*.vma.lzo"  #108.enfozone
#getit "joint developer$"
#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
