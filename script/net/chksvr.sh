#!/bin/bash

export DISPLAY=:0.0
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -o i3)/environ )

LIST_SERVERS=$(grep -w "Host" .ssh/config | awk '{print $2}')

for i in ${LIST_SERVERS}; do
#  printf "%-10s\t" $i
#  ssh -x $i << ENDSSH
#    free
#  ENDSSH
  ssh -x -t -t $i <<ENDSSH
  mem=$( free | grep Mem )
  echo $mem
  size=$( df -lh | grep -E '^[^/]*$|[4-9][0-9]%'|grep -v Filesystem )
  echo $size
  exit
ENDSSH
done

#  echo -ne $i'\t'
#  ssh -x $i "free | grep Mem | awk '{print \$3 / \$2 * 100.0}'"
#done
#df -Ph|grep -E '^[^/]*$|[4-9][0-9]%'|grep -v Filesystem
#ssh quark "free | grep Mem | awk '{print \$3 / \$2 * 100.0}'"


#if ! [ -z "$LIST_DOMAINS" ]; then 
#  notify-send -t 1000 --icon=gtk-info GFCheck "$LIST_DOMAINS"
#else
#  notify-send -t 1000 --icon=gtk-info GFCheck "All OK"
#fi

