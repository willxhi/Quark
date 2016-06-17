#!/bin/sh
LOGDIR=/mnt/backup/svr/logs/$(date +"%Y/%m/%d")
_MYDIR=$(dirname $(readlink -f $0))
_MYNAME=`basename $0`
. $_MYDIR/wi_mkdir.sh $LOGDIR
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
(
. $_MYDIR/wi_headlog.sh $LOGDIR
date
c_begin_time_sec=`date +%s`
echo "*init \t $(date)"
#begin script trace
#
#variable
#
#begin script content
#end script content
#
#end script trace
echo "*done \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
