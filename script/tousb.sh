#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-02 - WmX - Create this script
# 2015-10-26 - WmX - Fix makedir for next month
# 2015-12-02 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
#										 Add new variable _MYPARENTDIR for use the relative path to variable BCKDIR
#										 Update to accomodate sync. file at beginning of the month
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
BCKDIR=/mnt/daily/dbs/
RMTHOST=root@192.168.51.211
RMTDIR=/w01/backup/
THISMONTH=$(date +%Y%m)
LASTMONTH=$(date +%Y%m -d "1 month ago")

$_MYDIR/utils/wi_headlog.sh $BCKDIR'55/'$THISMONTH
$_MYDIR/utils/wi_headlog.sh $BCKDIR'59/'$THISMONTH

if [ "$1" = "rsv" ] 
then
	rsv=--remove-source-files
else
	rsv= 
	echo -e "*scr51.18 \t $(date)"
	tar cvzPf $BCKDIR'51.18/log_'$(date +%Y%m%d).tgz $_MYDIR'/logs/'$(date +"%Y/%m/%d")
fi

findsyncit(){
	find $RMTDIR$1/dump/ -name '*'$2'*.tgz' -exec rsync -avhPW $rsv {} $BCKDIR$1/$2 \;
}

loopit(){
  echo -e "*rsync$1 \t $(date)"
  if [ `date '+%d'` -gt 1 -a `date '+%d'` -lt 5 ]; then findsyncit $1 $LASTMONTH; fi
  findsyncit $1 $THISMONTH
}

loopit '51.59'
loopit '51.55'

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
