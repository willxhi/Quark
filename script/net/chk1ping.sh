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

pingit () { 
	if ping -c 1 -W 2 $1 > /dev/null; then
		echo "Up"
	else
		echo "Down"
	fi
}

while read p; do
  if ! [ "${p:0:1}" = "#" ]; then
    ISUP=$(pingit $p)
    if [ "$2" = "trace" ]; then echo -e $p"\t"$ISUP; fi
    if [ "$ISUP" = "Down" ]; then
      ALLDOWN="$ALLDOWN"$'\n'$(printf "%-15s\t%s\n" $p $ISUP)
    fi
  fi
done <$_MYDIR/listping.txt

if ! [ -z "$ALLDOWN" ]; then
  echo $ALLDOWN
  echo -e ${1#*_}${_MYNAME%.*}"\t"$(date)"\t#"$ALLDOWN >> $LOGDIR$(date +"/%d.%H")
else
  echo "$2""All OK"
fi

# "$1" = "desktop" then use notify on desktop
#if [ -n "$1" ] && [ "$1" = "desktop" ] ; then
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
