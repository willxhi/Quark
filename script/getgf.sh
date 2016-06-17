#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-01-11 - WmX - Create this script
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
DUMPSVNDIR=/home/backups/
BCKDIR=$_MYPARENTDIR/backup
#51.29
echo -e "*29 \t $(date)"
$_MYDIR/utils/wi_mkdir.sh $BCKDIR/51.29/dump/
rsync -avhPW -e "ssh -p 1308" root@192.168.51.29:$DUMPSVNDIR $BCKDIR/51.29/dump/
ssh root@192.168.51.29 << EOSSH
  rm $DUMPDBDIR'kvn'$TWODAYAGOFILE'.tgz'
  rm $DUMPDBDIR'ddlk'$TWODAYAGOFILE'.tgz'
EOSSH
#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
