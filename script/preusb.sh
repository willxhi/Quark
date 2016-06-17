#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-02 - WmX - Create this script
# 2015-10-23 - WmX - Update logfile location
# 2015-12-01 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
#										 Add new variable _MYPARENTDIR for use the relative path to variable BCKDIR
#										 Change filename from "mousb.sh" to "preusb.sh"
#										 Change argument from "start" to "dailyon"
# 2015-12-08 - WmX - Change "tousb.sh" to "todaily.sh"
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
echo "*init \t $(date)"
if [ -z "$1" ]; then
	echo "No argument supplied - $(date)"
else
	if [ "$1" = "dailystart" ]; then
		mount /mnt/daily
		$_MYDIR/todaily.sh
	elif [ "$1" = "dailystop" ]; then
		$_MYDIR/todaily.sh rsv
		umount /mnt/daily
	elif [ "$1" = "dailyoff" ];	then
		#MNTDAILY=$(mount |grep '/mnt/daily' | awk '{print $1}')
		#udisks --unmount /dev/sdf1 && udisks --detach /dev/sdf
	  #MNTDAILY=$(grep '/mnt/daily' /etc/fstab | awk '{print $7}' | cut -c 2-9)
	  #udisks --unmount $MNTDAILY'1' && udisks --detach $MNTDAILY
    MNTDAILY=$(mount -l | grep '/mnt/daily' | awk '{print $1}' | cut -c 1-8)
		if [ -z "$MNTDAILY" ]; then
    	MNTDAILY=$(cat /etc/fstab | grep '/mnt/daily')
    	MNTDAILY=${MNTDAILY#*#}
    	MNTDAILY=$(echo $MNTDAILY | cut -c 1-8)
   	fi
    udisks --unmount $MNTDAILY'1' && udisks --detach $MNTDAILY
  elif [ "$1" = "monthlyon" ]; then
		mount /mnt/monthly
	else
		echo -e "Not a valid argument supplied - $(date)"
	fi
fi
echo "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE





















































