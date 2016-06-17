# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-04-19 - WmX - Create this script
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
MYSQLDUMPFILE=.bck/mysqldmp$(date +"%Y%m%d")
BCKDIR=$_MYPARENTDIR/backup
#51.198
echo -e "*29 \t $(date)"
$_MYDIR/utils/wi_mkdir.sh $BCKDIR/51.29/dump/
ssh -Tq root@192.168.51.198 << EOSSH
	find .bck -maxdepth 1 -mtime +8 -exec rm -rf {} \;
	mysqldump -v -u root -pInternusa99 --all-databases > $MYSQLDUMPFILE.sql 2> $MYSQLDUMPFILE.log
  tar cvzPf $MYSQLDUMPFILE.tgz $MYSQLDUMPFILE.sql $MYSQLDUMPFILE.log
	openssl aes-256-cbc -in $MYSQLDUMPFILE.tgz -out $MYSQLDUMPFILE.tgz.enc -k CCttII
	mv -f $MYSQLDUMPFILE.tgz.enc $MYSQLDUMPFILE.tgz
	rm -f $MYSQLDUMPFILE.sql $MYSQLDUMPFILE.log
EOSSH
rsync -avhPW root@192.168.51.198:.bck/ $BCKDIR/51.198/dump/
#
echo -e "*finish \t $(date)"
c_end_time_sec=`date +%s`
v_total_execution_time_sec=`expr ${c_end_time_sec} - ${c_begin_time_sec}`
echo "Script execution time is $v_total_execution_time_sec seconds / "$(date -u -d @$v_total_execution_time_sec +%H:%M:%S)
) | tee $LOGFILE

