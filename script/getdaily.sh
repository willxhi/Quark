#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-04-20 - WmX - Create this script
##
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
_MYNAME=`basename $0`
LOGDIR=$_MYDIR/logs/$(date +"%Y/%m/%d")
$_MYDIR/utils/wi_mkdir.sh $LOGDIR
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
(
#echo $_MYDIR
$_MYDIR/utils/wi_headlog.sh $LOGDIR
#date
c_begin_time_sec=`date +%s`
echo -e "*init \t $(date)"

echo -e "*start get oracle 51.55 & 51.59 \t $(date)"
$_MYDIR/getdbdump.sh
echo -e "*finish get oracle 51.55 & 51.59 \t $(date)"
echo -e "*start get mysql 51.198 \t $(date)"
$_MYDIR/getmysql.sh
echo -e "*finish get oracle 51.198 \t $(date)"
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
