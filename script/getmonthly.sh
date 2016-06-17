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

RBT=$(tput setaf 7)$(tput setab 4)$(tput bold)
RGT=$(tput setaf 7)$(tput setab 2)$(tput bold)
RST=$(tput sgr0)

THISMONTH=$(date +"%Y/%m")
LASTMONTH=$(date +"%Y%m" -d "1 month ago")
LASTMONTHDATE=$(date -d "$(date +%Y%m01) -1 day" +%d)

BCKDIR=$_MYPARENTDIR/backup
CURBCKDIR=$BCKDIR/all/$THISMONTH
MOBIMGDIR=$_MYPARENTDIR/backup/51.191/mobile/$THISMONTH/

MGRMT='//192.168.51.20/it'
MGDIR='/mnt/it/IT ACTIVITY'
MGDIR1=$MGDIR'/Manual & Guide/'
MGDIR2=$MGDIR'/Manual Guide MIS (swf)'

DBDIR='/mnt/daily/dbs'
KVNDIR=$DBDIR/51.55/$LASTMONTH/
SYRDIR=$DBDIR/51.59/$LASTMONTH/
RECDIR=$DBDIR/51.198/$LASTMONTH/

SVNDIR='/home/backups'

echo -e $RBT"$(date) \t ""### 00. begin get db dump file  ###"$RST
rsyncDB() {
	echo -e $RGT"$(date) \t""$KVNDIR"$RST
	rsync $_MYRSYNC $KVNDIR --include={ddlk,kvn}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.55
	echo -e $RGT"$(date) \t""$SYRDIR"$RST
	rsync $_MYRSYNC $SYRDIR --include={ddls,syr}$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.59
	echo -e $RGT"$(date) \t""$RECDIR"$RST
	rsync $_MYRSYNC $RECDIR --include='mysqldmp'$LASTMONTH'*'{15,$LASTMONTHDATE}'.tgz' --exclude='*' $CURBCKDIR/51.198
}

if ! $(mountpoint -q $(dirname "$DBDIR")); then 
	mount $(dirname $DBDIR)
	if ! $(mountpoint -q $(dirname "$DBDIR")); then
		rsyncDB
	fi
else
	rsyncDB
fi
echo -e $RBT"$(date) \t ""### 00. end get db dump file ###"$RST

echo -e $RBT"$(date) \t ""### 01. begin mobile image ###"$RST
rsync $_MYRSYNC $MOBIMGDIR $CURBCKDIR/mobimg
echo -e $RBT"$(date) \t ""### 01. end mobile image ###"$RST

echo -e $RBT"$(date) \t ""### 02. begin manual guide ###"$RST
rsyncMG() {
	echo -e $RGT"$(date) \t""$MGDIR1"$RST
	rsync $_MYRSYNC "$MGDIR1" $CURBCKDIR/MG
	echo -e $RGT"$(date) \t""$MGDIR2"$RST
	rsync $_MYRSYNC "$MGDIR2" $CURBCKDIR/MG
}

if ! $(mountpoint -q $(dirname "$MGDIR")); then 
	mount -t cifs $MGRMT $(dirname "$MGDIR") -o username=admin,password=pastibisaman
	if ! $(mountpoint -q $(dirname "$MGDIR")); then
		rsyncMG
	fi
else
	rsyncMG
fi
echo -e $RBT"$(date) \t ""### 02. end manual guide ###"$RST

echo -e $RBT"$(date) \t ""### 03. begin db kvn ###"$RST
rsync $_MYRSYNC $KVNDIR $CURBCKDIR/kvn
echo -e $RBT"$(date) \t ""### 03. end db kvn ###"$RST

echo -e $RBT"$(date) \t ""### 04. begin db syr ###"$RST
rsync $_MYRSYNC $SYRDIR $CURBCKDIR/kvn
echo -e $RBT"$(date) \t ""### 04. end db syr ###"$RST

echo -e $RBT"$(date) \t ""### 05. begin db rec ###"$RST
rsync $_MYRSYNC $RECDIR $CURBCKDIR/kvn
echo -e $RBT"$(date) \t ""### 05. end db rec ###"$RST

### 06. begin svn ###
rsync $_MYRSYNC -e 8" root@192.168.51.29:$DUMPSVNDIR $BCKDIR/51.29/dump/
### 06. end svn ###

### 07. begin acct ###
### 07. end acct ###

### 08. begin payroll ###
### 08. end payroll ###
du --max-depth=1 -xh $CURBCKDIR/

echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE

