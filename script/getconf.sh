#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-04 - WmX - Create this script
# 2015-12-14 - WmX - Change variable THISMONTH=$(date +"%Y/%m") to THISDATE=$(date +"%Y/%m/%d")
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
CONFDIR=$_MYDIR/conf
BCKDIR=$_MYPARENTDIR/backup
THISDATE=$(date +"%Y/%m/%d")
HOST_LIST="192.168.51.18 192.168.51.29"

declare -A matrix
matrix[0,0]=192.168.51.29
matrix[0,1]=1308
matrix[1,0]=192.168.51.55
matrix[1,1]=1355
matrix[2,0]=192.168.51.56
matrix[2,1]=1356
matrix[3,0]=192.168.51.59
matrix[3,1]=1359
matrix[4,0]=192.168.51.191
matrix[4,1]=22
matrix[5,0]=192.168.51.215
matrix[5,1]=1309

for ((i=0;i<6;i++)) do
	echo "svr:"${matrix[$i,0]}" "$(date)
	CURRBCKDIR=$BCKDIR/${matrix[$i,0]:8}/conf/$THISDATE
	$_MYDIR/utils/wi_mkdir.sh $CURRBCKDIR
  rsync -avhPW --files-from=$CONFDIR/${matrix[$i,0]:8}.conf -e "ssh -p ${matrix[$i,1]}" root@${matrix[$i,0]}:/ $CURRBCKDIR
done

#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
