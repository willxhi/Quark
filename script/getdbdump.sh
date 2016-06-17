#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-09-23 - WmX - Create this script
# 2015-11-18 - WmX - Update to use same structure as other scripts
# 2015-11-30 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
#										 Add new variable _MYPARENTDIR for use the relative path to variable BCKDIR
# 2016-04-01 - WmX - Add option --no-inc-recursive to reduce memory used
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
DUMPDBDIR=/app/oracle/backups/dumps/
BCKDIR=$_MYPARENTDIR/backup
TWODAYAGOFILE=$(date +%Y%m%d -d "2 day ago")
nir=--no-inc-recursive
#51.55
echo -e "*55 \t $(date)"
$_MYDIR/utils/wi_mkdir.sh $BCKDIR/51.55/dump/
rsync -avhPW $nir -e "ssh -p 1355" root@192.168.51.55:$DUMPDBDIR $BCKDIR/51.55/dump/
ssh root@192.168.51.55 -p 1355 << EOSSH
	find $DUMPDBDIR -maxdepth 1 -mtime +7 -exec rm -rf {} \;
  rm $DUMPDBDIR'kvn'$TWODAYAGOFILE'.tgz'
  rm $DUMPDBDIR'ddlk'$TWODAYAGOFILE'.tgz'
EOSSH
#51.59
echo -e "*59 \t $(date)"
$_MYDIR/utils/wi_mkdir.sh $BCKDIR/51.59/dump/
rsync -avhPW $nir -e "ssh -p 1359" root@192.168.51.59:$DUMPDBDIR $BCKDIR/51.59/dump/
ssh root@192.168.51.59 -p 1359 << EOSSH
	find $DUMPDBDIR -maxdepth 1 -mtime +7 -exec rm -rf {} \;
  rm $DUMPDBDIR'syr'$TWODAYAGOFILE'.tgz'
  rm $DUMPDBDIR'ddls'$TWODAYAGOFILE'.tgz'
EOSSH
#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
