#!/bin/bash
# Author : William Xhinar <acc4itc@gmail.com>
# Documentation Logs
# 2015-12-18 - WmX - Create this script
# 2015-12-19 - WmX - Adding curl code
# 2016-02-19 - WmX - Fixing notify icon
# 2016-02-22 - Wmx - Adding mode for desktop notification and sendmail
##
_MYNAME=`basename "$0"`
_MYDIR=$(dirname $(readlink -f $0))
_MYPARENTDIR=$(dirname "$_MYDIR")
LOGDIR=$_MYDIR/log/$(date +"%Y%m")
$_MYPARENTDIR/utils/wi_mkdir.sh $LOGDIR "$2"

curlit () { 
  http=$(curl -sL --max-time 30 -w "%{http_code} %{url_effective}\\n" $1 -o /dev/null)
  exitstatus="$?"
	case $http in
  [2]*)
		printf "%-11s %s %s\n" "OK" ${http}
    ;;
  [3]*)
		printf "%-11s %s %s\n" "REDIRECT" ${http}
    ;;
  [4]*)
    printf "%-11s %s %s\n" "DENIED" ${http}
    ;;
  [5]*)
    printf "%-11s %s %s\n" "ERROR" ${http}
    ;;
  *)
    #CURLE_SSL_CACERT
    if [ "$exitstatus" = 60 ]; then
      printf "%-11s %s %s\n" "OK" ${http}

    else
      printf "%-11s %s %s %s\n" "NORESPONSE" ${http}
    fi
    ;;
  esac
  printf " "$(grep -w $exitstatus $_MYDIR/listcurlcode.txt | cut -f 1 -d ",")
}

while read p; do
  if ! [ "${p:0:1}" = "#" ]; then
    ISUP=$(curlit $p)
    if [ "$2" = "trace" ]; then echo -e $ISUP; fi
    if ! [ "${ISUP:0:2}" = "OK" ]; then
      ISUP=`echo $ISUP | awk {'printf ("%50s\t%s\n", $3, $4)'}`
      ALLDOWN="$ALLDOWN"$'\n'$ISUP
    else
      : #echo "${ISUP:0:2}"" "$p
    fi
  fi
done <$_MYDIR/listurl.txt

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
    notify-send -t 1000 --icon=dialog--warning "$2" "$ALLDOWN"
  else
    notify-send -t 1000 --icon=dialog-information "$2" "All OK" 
  fi
fi

#send mail if down
if [ -n "$ALLDOWN" ]; then $_MYDIR/sendmail ${1#*_}${_MYNAME%.*}; fi
