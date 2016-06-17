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
THISMONTH=$(date +"%Y/%m")
CURRBCKDIR=$BCKDIR/51.10/dump/$THISMONTH/jadev/
#51.10
getit(){
  RMTDIR="//192.168.51.10/"$1
  echo $RMTDIR
  if mountpoint -q /mnt/tmp; then umount /mnt/tmp; fi
  echo -e "$(date) \t *51.10"
  $_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
  echo -e "$(date) \t *mount /mnt/tmp - "$1
  mount -t cifs -o username=backup,password=Backup5110 "$RMTDIR/" /mnt/tmp
  echo -e "$(date) \t *rsync "$1
  if [ "$1" = "java developer" ]; then
    CURRBCKDIR=$BCKDIR/51.10/dump/$THISMONTH/jadev/
    $_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
    rsync -avhPW /mnt/tmp/ $CURRBCKDIR
  else
    CURRBCKDIR=$BCKDIR/51.10/dump/$THISMONTH/joint/
    $_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
    rsync -avhPW /mnt/tmp/syr$(date +%d%m%y -d "1 month ago").7z /mnt/tmp/7zipit.bat $CURRBCKDIR
  fi
  echo -e "$(date) \t *unmount /mnt/tmp - "$1
  umount /mnt/tmp
}
getit "java developer"
getit "joint developer$"
#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
