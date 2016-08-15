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

BR=$(for i in $(seq 1 80); do printf "-"; done)
FR=$(tput setaf 7); BL=$(tput bold)
RBT=$FR$(tput setab 4)$BL 
RGT=$FR$(tput setab 2)$BL
RRT=$FR$(tput setab 1)$BL
ROT=$FR$(tput setab 3)$BL
RST=$(tput sgr0)
BR=$ROT$BR$RST


THISMONTH=$(date +"%Y/%m")
LASTMONTH=$(date +"%Y%m" -d "1 month ago")
LASTMONTHDATE=$(date -d "$(date +%Y%m01) -1 day" +%d)

BCKDIR=$_MYPARENTDIR/backup
CURBCKDIR=$BCKDIR/all/$LASTMONTH

while read p; do mkdir -p $CURBCKDIR/$p; done<$_MYDIR/list/bckdirprefix.txt

if [ -z "$1" -o "$1" = "1" ]; then
	DBDIR='/mnt/daily/dbs'
	KVNDIR=$DBDIR/51.55/$LASTMONTH/
	SYRDIR=$DBDIR/51.59/$LASTMONTH/
	RECDIR=$DBDIR/51.198/$LASTMONTH/

	echo -e $RBT"$(date) \t ""### 01. begin get db dump file  ###"$RST
	rsyncDB() {
		echo -e $RGT"$(date) \t""$KVNDIR"$RST
		rsync $_MYRSYNC $KVNDIR --include={ddlk,kvn}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/KVN
		echo -e $RGT"$(date) \t""$SYRDIR"$RST
		rsync $_MYRSYNC $SYRDIR --include={ddls,syr}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/SYR
		echo -e $RGT"$(date) \t""$RECDIR"$RST
		rsync $_MYRSYNC $RECDIR --include='mysqldmp'$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/REC
	}
	
	if ! $(mountpoint -q $(dirname "$DBDIR")); then 
		mount $(dirname $DBDIR)
		if $(mountpoint -q $(dirname "$DBDIR")); then
			rsyncDB
		fi
	else
		rsyncDB
	fi
	echo -e $RBT"$(date) \t ""### 01. end get db dump file ###"$RST

	umount $(dirname $DBDIR)
fi

echo -e $BR

if [ -z "$1" -o "$1" = "2" ]; then
	echo -e $RBT"$(date) \t ""### 02. begin mobile image ###"$RST
	MOBIMGDIR=$_MYPARENTDIR/backup/51.191/mobile/$THISMONTH/
	rsync $_MYRSYNC $MOBIMGDIR $CURBCKDIR/IMG
	echo -e $RBT"$(date) \t ""### 02. end mobile image ###"$RST
fi

if [ -z "$1" -o "$1" = "3" ]; then
	MGRMT='//192.168.51.20/it'
	MGDIR='/mnt/it/IT ACTIVITY'
	MGDIR1=$MGDIR'/Manual & Guide/'
	MGDIR2=$MGDIR'/Manual Guide MIS (swf)'

	echo -e $RBT"$(date) \t ""### 03. begin manual guide ###"$RST
	rsyncMG() {
		echo -e $RGT"$(date) \t""$MGDIR1"$RST
		rsync $_MYRSYNC "$MGDIR1" $CURBCKDIR/MG
		echo -e $RGT"$(date) \t""$MGDIR2"$RST
		rsync $_MYRSYNC "$MGDIR2" $CURBCKDIR/MG
	}
	
	if ! $(mountpoint -q $(dirname "$MGDIR")); then 
		mount -t cifs $MGRMT $(dirname "$MGDIR") -o username=admin,password=pastibisaman
		if $(mountpoint -q $(dirname "$MGDIR")); then
			rsyncMG
		fi
	else
		rsyncMG
	fi
	umount $(dirname "$MGDIR")
	echo -e $RBT"$(date) \t ""### 03. end manual guide ###"$RST
fi

echo -e $BR

if [ -z "$1" -o "$1" = "4" ]; then
	SVNDIR=$_MYPARENTDIR"/backup/51.29/dump/"$(date +"%y_%m_" -d "1 month ago")"28"

	echo -e $RBT"$(date) \t ""### 04. begin svn ###"$RST
	rsync $_MYRSYNC $SVNDIR $CURBCKDIR/SVN
	echo -e $RBT"$(date) \t ""### 04. end svn ###"$RST
fi

echo -e $BR

if [ -z "$1" -o "$1" = "5" ]; then
	HRRMT='//192.168.51.5/ITC-ITSOFT$'
	HRDIR='/mnt/hr/bck'

	echo -e $RBT"$(date) \t ""### 05. begin pyr ###"$RST
	rsyncPYR() {
	  echo -e $RGT"$(date) \t""$HRDIR"$RST
		rsync $_MYRSYNC "$HRDIR" $CURBCKDIR/HR
	}
	
	if ! $(mountpoint -q $(dirname "$HRDIR")); then 
	  mount -t cifs $HRRMT $(dirname "$HRDIR") -o username=administrator,password=Internusa55
	  if $(mountpoint -q $(dirname "$HRDIR")); then
			rsyncPYR		
		fi
	else
		rsyncPYR
	fi
	umount  $(dirname "$HRDIR")
	echo -e $RBT"$(date) \t ""### 05. end pyr ###"$RST
fi

echo -e $BR
	
if [ -z "$1" -o "$1" = "6" ]; then
	ACTRMT='//192.168.51.5/PROGRAM'
	ACTDIR='/mnt/act/bck'

	echo -e $RBT"$(date) \t ""### 06. begin act ###"$RST
	rsyncACT() {
	  echo -e $RGT"$(date) \t""$ACTDIR"$RST
	  rsync $_MYRSYNC "$ACTDIR" $CURBCKDIR/ACT
	}
	
	if ! $(mountpoint -q $(dirname "$ACTDIR")); then 
	  mount -t cifs $ACTRMT $(dirname "$ACTDIR") -o username=administrator,password=Internusa55
	  if $(mountpoint -q $(dirname "$ACTDIR")); then
	    rsyncACT
	  fi
	else
	  rsyncACT
	fi
	umount $(dirname "$ACTDIR")
	echo -e $RBT"$(date) \t ""### 06. begin act ###"$RST
fi

if [ -z "$1" -o "$1" = "7" ]; then
	JAVRMT='//192.168.51.10/java developer'
	JAVDIR='/mnt/jav'

	echo -e $RBT"$(date) \t ""### 07. begin jav ###"$RST
	rsyncJAV() {
	  echo -e $RGT"$(date) \t""$JAVDIR"$RST
		rsync $_MYRSYNC "$JAVDIR" $CURBCKDIR/JV
	}
	
	if ! $(mountpoint -q "$JAVDIR"); then 
	  mount -t cifs "$JAVRMT" "$JAVDIR" -o username=administrator,password=4SUPERitc0199
	  if $(mountpoint -q "$JAVDIR"); then
			rsyncJAV		
		fi
	else
		rsyncJAV
	fi
	umount  "$JAVDIR"
	echo -e $RBT"$(date) \t ""### 05. end jav ###"$RST
fi

echo -e $BR

echo -e $RRT
du --max-depth=1 -xh $CURBCKDIR/ | sort -rh
echo -e $RST

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE
