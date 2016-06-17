#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-11-02 - WmX - Create this script
# 2015-12-08 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
#										 Add new variable _MYPARENTDIR for use the relative path to variable BCKDIR
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
MOBIMGDIR=/extended/mobile/
BCKDIR=$_MYPARENTDIR/backup
THISMONTH=$(date +"%Y/%m")
CURRBCKDIR=$BCKDIR/51.191/mobile/$THISMONTH
nir=--no-inc-recursive
$_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
#51.191
echo -e "*191 \t $(date)"
if [ "$1" = "sdb" ] 
then    
    SDBDIR=/mnt/sdb/bck/img/$THISMONTH
    $_MYDIR/utils/wi_mkdir.sh $SDBDIR
    rsync -avhPW $nir $CURRBCKDIR/ $SDBDIR
else
    rsync -avhPW $nir -e 'ssh -p 5191' root@192.168.51.191:$MOBIMGDIR $CURRBCKDIR
fi
#51.191
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
