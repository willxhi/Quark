#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-08 - WmX - Create this script
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
echo -e "*init \t $(date)"
DAILYDIR=/mnt/daily/dbs/
MONTHLYDIR=/mnt/monthly/dbs/
THISMONTH=$(date +%Y%m)
LASTMONTH=$(date +%Y%m -d "1 month ago")
LASTMONTHDATE=$(date -d "$(date +%Y%m01) -1 day" +%d)

$_MYDIR/utils/wi_mkdir.sh $MONTHLYDIR'51.55/'$THISMONTH
$_MYDIR/utils/wi_mkdir.sh $MONTHLYDIR'51.59/'$THISMONTH

if ! $(mountpoint -q $(dirname $DAILYDIR)); then mount $(dirname $DAILYDIR); fi
if ! $(mountpoint -q $(dirname $MONTHLYDIR)); then mount $(dirname $MONTHLYDIR); fi

#if ! mountpoint -q /mnt/daily; then mount /mnt/daily; fi
#if ! mountpoint -q /mnt/monthly; then mount /mnt/monthly; fi

echo -e "$(date) \t $RWT""###***rsync-daily-51.59-"$LASTMONTH$RST
rsync -avhPW $DAILYDIR'51.59/'$LASTMONTH/ $MONTHLYDIR'51.59/'$LASTMONTH/
echo -e "$(date) \t $RWT""###***rsync-daily-51.59-"$THISMONTH$RST
rsync -avhPW $DAILYDIR'51.59/'$THISMONTH/ $MONTHLYDIR'51.59/'$THISMONTH/

echo -e "$(date) \t $RWT""###***rsync-daily-51.55-"$LASTMONTH$RST
rsync -avhPW $DAILYDIR'51.55/'$LASTMONTH/ $MONTHLYDIR'51.55/'$LASTMONTH/
echo -e "$(date) \t $RWT""###***rsync-daily-51.55-"$THISMONTH$RST
rsync -avhPW $DAILYDIR'51.55/'$THISMONTH/ $MONTHLYDIR'51.55/'$THISMONTH/


if [ `date '+%d'` -ge 28 -a `date '+%d'` -le 30 ] || [ "${1:0:10}" = "cleandaily" ]; then
    if [ "$1" = "cleandaily2" ]; then    
      echo -e "$(date) \t $RWT""###***delete-daily-$LASTMONTH between date 16-second ldotm when date 28-29 or manual"$RST
      case $LASTMONTHDATE in
        28) _REGEXSTR='.*(1[6-9]|2[0-7])\.tgz' ;;
        29) _REGEXSTR='.*(1[6-9]|2[0-8])\.tgz' ;;
        30) _REGEXSTR='.*(1[6-9]|2[0-9])\.tgz' ;;
        31) _REGEXSTR='.*(1[6-9]|2[0-9]|30)\.tgz' ;;
        *)  _REGEXSTR='.*(1[6-9]|2[0-8])\.tgz' ;;
      esac    
      echo -e "the 51.59 files :"
    	find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f
  	  find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f -delete  
      echo -e "the 51.55 files :"
      find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f
      find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f -delete
		elif [ "$1" = "cleandaily1" ]; then
			echo -e "$(date) \t $RWT""###***delete-daily-$LASTMONTH between date 01-14 when date 28-29 or manual"$RST
      _REGEXSTR='.*(0[1-9]|1[0-4])\.tgz'
      echo -e "the 51.59 files :"
    	find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f
  	  find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f -delete  
      echo -e "the 51.55 files :"
      find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f
      find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex $_REGEXSTR -type f -delete
    fi

    if [[ ! -z $(find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex ".*31\.tgz" -type f) ]]; then
        echo -e "$(date) \t $RWT""###***delete-daily-$LASTMONTH delete date 30 if there is 31"$RST
        find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex ".*30\.tgz" -type f
        find $DAILYDIR'51.59/'$LASTMONTH -regextype posix-extended -regex ".*30\.tgz" -type f -delete
    fi
    
    if [[ ! -z $(find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex ".*31\.tgz" -type f) ]]; then
        echo -e "$(date) \t $RWT""###***delete-daily-$LASTMONTH delete date 30 if there is 31"$RST
        find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex ".*30\.tgz" -type f
        find $DAILYDIR'51.55/'$LASTMONTH -regextype posix-extended -regex ".*30\.tgz" -type f -delete
    fi

    if [ -z "$1" ]; then
      echo -e "$(date) \t $RWT""###***delete-monthly-$LASTMONTH all files except date 15 and lastday when date 28-29"$RST
      echo -e "the 51.59 files :"
      find $MONTHLYDIR'51.59/'$LASTMONTH -regextype posix-extended -not -regex ".*(15|$LASTMONTHDATE)\.tgz" -type f
      find $MONTHLYDIR'51.59/'$LASTMONTH -regextype posix-extended -not -regex ".*(15|$LASTMONTHDATE)\.tgz" -type f -delete
      echo -e "the 51.55 files :"
      find $MONTHLYDIR'51.55/'$LASTMONTH -regextype posix-extended -not -regex ".*(15|$LASTMONTHDATE)\.tgz" -type f
      find $MONTHLYDIR'51.55/'$LASTMONTH -regextype posix-extended -not -regex ".*(15|$LASTMONTHDATE)\.tgz" -type f -delete
    fi
elif [ `date '+%d'` -ge 01 -a `date '+%d'` -le 09 ] || [ "${1:0:12}" = "cleanmonthly" ]; then
	LASTTWOMONTH=$(date +%Y%m -d "2 month ago")
	LASTTWOMONTHDATE=$(date -d "$(date +%Y%m01 -d "1 month ago") -1 day" +%d)
	echo -e "$(date) \t $RWT""###***delete-monthly-$LASTTWOMONTH all files except date 15 and lastday when date 28-29"$RST
  echo -e "the 51.59 files :"
	find $MONTHLYDIR'51.59/'$LASTTWOMONTH -regextype posix-extended -not -regex ".*(15|$LASTTWOMONTHDATE)\.tgz" -type f
	find $MONTHLYDIR'51.59/'$LASTTWOMONTH -regextype posix-extended -not -regex ".*(15|$LASTTWOMONTHDATE)\.tgz" -type f -delete
	echo -e "the 51.55 files :"
	find $MONTHLYDIR'51.55/'$LASTTWOMONTH -regextype posix-extended -not -regex ".*(15|$LASTTWOMONTHDATE)\.tgz" -type f
	find $MONTHLYDIR'51.55/'$LASTTWOMONTH -regextype posix-extended -not -regex ".*(15|$LASTTWOMONTHDATE)\.tgz" -type f -delete
fi

if [[ $(date +%m) != '01' ]]
then
    echo -e "$(date) \t $RWT""###***delete-daily-"$((THISMONTH-2))
    echo -e "the 51.59 files :"
    find /mnt/daily/dbs/51.59 -mindepth 1  -type d | awk -F '/' ' $6<'$((THISMONTH-2))
    find /mnt/daily/dbs/51.59 -mindepth 1  -type d | awk -F '/' ' $6<'$((THISMONTH-2)) | xargs rm -rf

    find /mnt/daily/dbs/51.55 -mindepth 1  -type d | awk -F '/' ' $6<'$((THISMONTH-2))
    find /mnt/daily/dbs/51.55 -mindepth 1  -type d | awk -F '/' ' $6<'$((THISMONTH-2)) | xargs rm -rf

else
    find /mnt/daily/dbs/51.59 -mindepth 1  -type d | awk -F '/' ' $6<'$((LASTMONTH-2))
    find /mnt/daily/dbs/51.59 -mindepth 1  -type d | awk -F '/' ' $6<'$((LASTMONTH-2)) | xargs rm -rf

    find /mnt/daily/dbs/51.55 -mindepth 1  -type d | awk -F '/' ' $6<'$((LASTMONTH-2))
    find /mnt/daily/dbs/51.55 -mindepth 1  -type d | awk -F '/' ' $6<'$((LASTMONTH-2)) | xargs rm -rf
fi

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
