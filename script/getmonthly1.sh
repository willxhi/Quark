#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-01-25 - WmX - Create this script
##
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
_MYNAME=`basename $0`
_MYRSYNC='-avhPpW -stats'
LOGDIR=$_MYDIR/logs/$(date +"%Y/%m/%d")
$_MYDIR/utils/wi_mkdir.sh $LOGDIR
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
(
c_begin_time_sec=`date +%s`
echo -e "*init   \t $(date)"

THISMONTH=$(date +"%Y/%m")
LASTMONTH=$(date +"%Y%m" -d "1 month ago")
LASTMONTHDATE=$(date -d "$(date +%Y%m01) -1 day" +%d)

BCKDIR=$_MYPARENTDIR/backup
CURBCKDIR=$BCKDIR/all/$THISMONTH
MOBIMGDIR=$_MYPARENTDIR/backup/51.191/mobile/$THISMONTH/

MGDIR1='/mnt/it/IT ACTIVITY/Manual & Guide/'
MGDIR2='/mnt/it/IT ACTIVITY/Manual Guide MIS (swf)'

DBDIR='/mnt/daily/dbs'
KVNDIR=$DBDIR/51.55/$LASTMONTH/
SYRDIR=$DBDIR/51.59/$LASTMONTH/
RECDIR=$DBDIR/51.198/$LASTMONTH/


echo $THISMONTH
echo $BCKDIR
echo $CURBCKDIR
echo $MOBIMGDIR


### 00. begin get db dump file  ###
rsync $_MYRSYNC $KVNDIR --include={ddlk,kvn}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.55
rsync $_MYRSYNC $SYRDIR --include={ddls,syr}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.59
rsync $_MYRSYNC $RECDIR --include='mysqldmp'$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.198
### 01. end get db dump file ###

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE

