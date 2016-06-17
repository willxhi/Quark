#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-05 - WmX - Create this script
# 2015-11-18 - WmX - Update to use same structure as other scripts
# 2015-12-01 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
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
TESTFILE=/tmp/test`date +\%Y\%m\%d\%H\%M`.log

#check if not exists then create
echo -e "*51.3 check $TESTFILE - \t $(date)"
if ssh root@192.168.51.3 "[ ! -e $TESTFILE ]"
then
	echo -e "*51.3 create $TESTFILE - \t $(date)"	
	#ssh root@192.168.51.3 "touch $TESTFILE"
	ssh -t -t root@192.168.51.3 <<-EOSSH1
		find /tmp/*.log -mtime +5 -exec rm {} \;
		touch $TESTFILE
		logout
	EOSSH1
fi
#check if success/fail
if ssh root@192.168.51.3 "[ -w $TESTFILE ]"
then
	echo -e "*51.3 found $TESTFILE - \t $(date)"
else
	echo -e "*51.3 not found $TESTFILE - \t $(date)"
	ssh -t -t root@192.168.51.210 <<-EOSSH2
		qm stop 104
		qm unlock 104
		qm start 104
	  #echo "say hello from 51.18"
    logout
	EOSSH2
fi
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
