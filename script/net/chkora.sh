#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2016-02-26 - WmX - Finishing this script
##
svr=${1:-'venus'}
#echo $svr
retVal=$(ssh -Tq oracle@$svr << \ENDSSH
  #. .db_profile
  case `hostname` in "venus"|"jupiter") . .db_profile; ;;  esac
  #. chkresptime2.sh
  sqlplus -s / as sysdba > timelog <<-EOF
  SET SERVEROUTPUT ON
  SET FEEDBACK OFF
  DECLARE
    tab_count NUMBER;
    t1 NUMBER;
    t2 NUMBER;
  BEGIN
    t1 := dbms_utility.get_time;
    SELECT COUNT(*) INTO tab_count
    FROM all_objects;
    t2 := dbms_utility.get_time;
    dbms_output.put_line( ((t2-t1)/100));

    SELECT COUNT(1) INTO tab_count
    FROM wi.user_session;

		dbms_output.put_line(chr(9) || tab_count);
  END;
  /
  EXIT
	EOF
  
  tmpVal=$(head -n 1 timelog)
  if [ "$tmpVal"="DECLARE" ]; then
    cat timelog
#    head -n 4 timelog | tail -n 1
  else
    echo $tmpVal
  fi
ENDSSH
)

echo $retVal
