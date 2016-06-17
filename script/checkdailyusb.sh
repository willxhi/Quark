#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-28 - WmX - Create this script
##
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
_MYNAME=`basename $0`
LOGDIR=$_MYDIR/logs/$(date +"%Y/%m/%d")
$_MYDIR/utils/wi_mkdir.sh $LOGDIR
LOGFILE=$LOGDIR/"$_MYNAME"_`date +\%Y\%m\%d\%H\%M`_wi.trc
(
$_MYDIR/utils/wi_headlog.sh $LOGDIR
RWT=$(tput setaf 1)$(tput setab 7)
RST=$(tput setaf 7)$(tput setab 0)
#RST=$(tput sgr 0)

c_begin_time_sec=`date +%s`
echo -e "*init   \t $(date)"
BCKDIR=/mnt/daily/dbs/
THISMONTH=$(date +%Y%m)
LASTMONTH=$(date +%Y%m -d "1 month ago")

loopit(){
  if [ $(date +%d) = "01" ]; then
    BCKDIRTHISMONTH=$BCKDIR$4'/'$LASTMONTH/$5
    FILE0=$BCKDIRTHISMONTH$(date -d "$(date +%Y%m01) -$((1+$1)) day" +%Y%m%d).tgz;echo $FILE0
    FILE1=$BCKDIRTHISMONTH$(date -d "$(date +%Y%m01) -$((1+$2)) day" +%Y%m%d).tgz;echo $FILE1
    FILE2=$BCKDIRTHISMONTH$(date -d "$(date +%Y%m01) -$((1+$3)) day" +%Y%m%d).tgz;echo $FILE2
  else
    BCKDIRTHISMONTH=$BCKDIR$4'/'$THISMONTH/$5
    FILE0=$BCKDIRTHISMONTH$(($(date +%Y%m%d)-$1)).tgz
    FILE1=$BCKDIRTHISMONTH$(($(date +%Y%m%d)-$2)).tgz
    FILE2=$BCKDIRTHISMONTH$(($(date +%Y%m%d)-$3)).tgz
  fi
  SIZEFILE0=$(stat -c%s $FILE0)
  SIZEFILE1=$(stat -c%s $FILE1)
  SIZEFILE2=$(stat -c%s $FILE2)
 
  echo -e "$(date) \t $RWT""###***compare size-daily-"$4
  echo -e "-"$FILE0" - "$FILE1$RST
  DIFF1=$((($SIZEFILE0-$SIZEFILE1)/1024/1024))
  echo $DIFF1
  echo -e "$(date) \t $RWT""###***compare size-daily-"$4
  echo -e "-"$FILE1" - "$FILE2$RST
  DIFF2=$((($SIZEFILE1-$SIZEFILE2)/1024/1024))
  echo $DIFF2
}

loopit ${1-1} ${2-2} ${3-3} '51.59' 'syr'
loopit ${1-1} ${2-2} ${3-3} '51.55' 'kvn'

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
