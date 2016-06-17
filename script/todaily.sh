#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-10-02 - WmX - Create this script
# 2015-10-26 - WmX - Fix makedir for next month
# 2015-12-02 - WmX - Fix path location for LOGDIR if script change path, now using $_MYDIR
#										 Add new variable _MYPARENTDIR for use the relative path to variable BCKDIR
#										 Update to accomodate sync. file at beginning of the month
# 2016-01-05 - WmX - Fix if mount folder not mounted, then syncit to other folder
# 2016-04-01 - WmX - Add option --no-inc-recursive to reduce memory used
# 2016-04-19 - WmX - Add backup 51.198 (mysql)
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
BCKDIR=/mnt/daily/dbs/
BCKDIRBCK=/mnt/dbsd/
RMTDIR=/w01/backup/
THISMONTH=$(date +%Y%m)
LASTMONTH=$(date +%Y%m -d "1 month ago")
nir=--no-inc-recursive

if ! $(mountpoint -q $(dirname $BCKDIR)); then 
  mount $(dirname $BCKDIR)
  if ! $(mountpoint -q $(dirname $BCKDIR)); then
    $_MYDIR/utils/wi_mkdir.sh $BCKDIRBCK
    BCKDIR=$BCKDIRBCK
  fi
fi

$_MYDIR/utils/wi_mkdir.sh $BCKDIR'51.55/'$THISMONTH
$_MYDIR/utils/wi_mkdir.sh $BCKDIR'51.59/'$THISMONTH
$_MYDIR/utils/wi_mkdir.sh $BCKDIR'51.198/'$THISMONTH

if [ "$1" = "rsv" ]; then
	rsv=--remove-source-files
else
	echo -e "*scr51.18 \t $(date)"
	tar cvzPf $BCKDIR'51.18/log_'$(date +%Y%m%d).tgz $_MYDIR'/logs/'$(date +"%Y/%m/%d")
fi

findsyncit(){
  if [ "$3" = "dbsd" ]; then
    #/mnt/dbsd/51.55/201601/
    if ! $(mountpoint -q $(dirname $BCKDIR)); then
      echo "mount $BCKDIR  not available"
      exit
    else
			echo "x1 "$1" - "$2" - "$BCKDIRBCK$1" - "$BCKDIR$1/$2" - "$rsv
      find $BCKDIRBCK/$1/$2/ -name '*'$2'*.tgz' -exec rsync -avhPW $nir $rsv {} $BCKDIR$1/$2 \;
    fi
    #rm -rf $BCKDIRBCK;
	elif [ "$3" = "dbsdoff" ]; then
		find $BCKDIRBCK/$1/$2 -name '*'$2'*.tgz' -mtime +3 -delete
  fi
  echo "x2 "$1" - "$2" - "$RMTDIR$1" - "$BCKDIR$1/$2" - "$rsv
	find $RMTDIR$1/dump/ -name '*'$2'*.tgz' -exec rsync -avhPW $nir $rsv {} $BCKDIR$1/$2 \;
}

loopit(){
  echo -e "*rsync$1 \t $(date)"
  echo `date '+%d'`
  if [ `date '+%d'` -ge 1 -a `date '+%d'` -lt 5 ] || [ "${2##*rsv}" = "lastmonth" ] ; then 
    findsyncit $1 $LASTMONTH $2
  fi
  findsyncit $1 $THISMONTH $2
}

#loopit '51.59' dbsd
loopit '51.59' $1
loopit '51.55' $1
loopit '51.198' $1

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
