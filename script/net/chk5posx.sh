#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-18 - WmX - Create this script
# 2016-02-19 - WmX - Fixing notify icon
# 2016-02-22 - Wmx - Adding mode for desktop notification and sendmail
##
_MYNAME=`basename "$0"`
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
LOGDIR=$_MYDIR/log/$(date +"%Y%m")
$_MYPARENTDIR/utils/wi_mkdir.sh $LOGDIR "$2"

if [ $(date +"%H") -gt 17 ] && [ $(date +"%M"): != 0 ]; then
  exit
fi

retVal=$(ssh -Tq oracle@venus << \ENDSSH
. .db_profile
sqlplus -s / as sysdba > posidmlog << EOF
SET SERVEROUTPUT ON
SET FEEDBACK OFF
DECLARE
  TGLINSERT DATE;
	TGLSKRG	  DATE;
	SELISIH   NUMBER;
BEGIN
	SELECT * INTO TGLINSERT, TGLSKRG, SELISIH
  	FROM (  SELECT tglinsert, SYSDATE, (SYSDATE - tglinsert) * 24 * 60
    	        FROM mis.view_pos_today
      	  ORDER BY tglinsert DESC)
	 WHERE ROWNUM = 1;
	
   dbms_output.put_line( 'POS|' || TO_CHAR (TGLSKRG,'YYYY-MM-DD HH24:MI:SS') || '|' || TO_CHAR (TGLINSERT,'HH24:MI:SS') || '|' || ROUND(SELISIH,3) || chr(10) );

	SELECT * INTO TGLINSERT, TGLSKRG, SELISIH
  	FROM (  SELECT tglinsert, SYSDATE, (SYSDATE - tglinsert) * 24 * 60
    	        FROM mis.view_idm_today
      	  ORDER BY tglinsert DESC)
	 WHERE ROWNUM = 1;
	
   dbms_output.put_line( 'IDM|' || TO_CHAR (TGLSKRG,'YYYY-MM-DD HH24:MI:SS') || '|' || TO_CHAR (TGLINSERT,'HH24:MI:SS') || '|' || ROUND(SELISIH,3) );

END;
/
EXIT
EOF

cat posidmlog
ENDSSH
)

if [ "$2" = "trace" ]; then echo "$retVal"; fi
_IFS=$IFS;IFS=$'\n'
for i in $retVal; do 
  interval=$(echo $i | awk 'BEGIN { FS = "|" } ; { print $4 }')
  if (( $(echo "${interval} > 20" | bc) == 1 )); then
		ALLDOWN="$ALLDOWN"$'\n'$i
  fi
done
IFS=$_IFS

if ! [ -z "$ALLDOWN" ]; then
  echo $ALLDOWN
  echo -e ${1#*_}${_MYNAME%.*}"\t"$(date)"\t#"$ALLDOWN >> $LOGDIR$(date +"/%d.%H")
else
  echo "$2""All OK"
fi

# "$1" = "desktop" then use notify on desktop
if [ -n "$1" ] && [ "${1%_*}" = "desktop" ] ; then
  export DISPLAY=:0.0
  export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -o i3)/environ )

  if ! [ -z "$ALLDOWN" ]; then 
    notify-send -t 1000 --icon=dialog-warning "$2" "$ALLDOWN"
  else
    notify-send -t 1000 --icon=dialog-information "$2" "All OK"
  fi  
fi

#send mail if down 
if [ -n "$ALLDOWN" ]; then $_MYDIR/sendmail ${1#*_}${_MYNAME%.*}; fi
