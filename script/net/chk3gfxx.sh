#!/bin/sh
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-21 - WmX - Create this script
# 2016-02-19 - WmX - Fixing notify icon
# 2016-02-22 - Wmx - Adding mode for desktop notification and sendmail
##
_MYNAME=`basename "$0"`
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
LOGDIR=$_MYDIR/log/$(date +"%Y%m")
$_MYPARENTDIR/utils/wi_mkdir.sh $LOGDIR "$2"

while read p; do
  if ! [ "${p:0:1}" = "#" ]; then
    if [ "$2" = "trace" ]; then
      if [ "$p" = "roshan.itcfinance.com" ]; then
        LIST_DOMAINS=$( ssh -Tq $p </dev/null "export AS_JAVA=/usr/java/jdk1.8.0_25;/opt/glassfish4/glassfish/bin/asadmin list-domains | grep -v 'Command list-domains'" )
      else
        LIST_DOMAINS=$( ssh -Tq $p </dev/null "/usr/share/glassfish3/glassfish/bin/asadmin list-domains | grep -v 'Command list-domains'" )
      fi
    else
      if [ "$p" = "roshan.itcfinance.com" ]; then
        LIST_DOMAINS=$( ssh -Tq $p </dev/null "export AS_JAVA=/usr/java/jdk1.8.0_25;/opt/glassfish4/glassfish/bin/asadmin list-domains | grep -v 'Command list-domains' | grep 'not running'" )
      else
        LIST_DOMAINS=$( ssh -Tq $p </dev/null "/usr/share/glassfish3/glassfish/bin/asadmin list-domains | grep -v 'Command list-domains' | grep 'not running' | grep -v 'dashboard'" )
      fi
    fi
    
    if ! [ -z "$LIST_DOMAINS" ]; then
      ALLDOWN="$ALLDOWN"$'\n\n'$(printf "%s\n%s\n" $p "$LIST_DOMAINS")
    fi
  fi
done < $_MYDIR/listgf.txt  

if ! [ -z "$ALLDOWN" ]; then
  echo "$ALLDOWN"
	echo -e ${1#*_}${_MYNAME%.*}"\t"$(date)"\t#"$ALLDOWN >> $LOGDIR$(date +"/%d.%H")
else
  echo "$2""All OK"
fi

# "$1" = "desktop" then notify on desktop
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
