#!/bin/bash

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
		if [ "$ISUP" = "Down" ]; then
			ALLDOWN="$ALLDOWN"$'\n'$(printf "%15s %-4s\n" $p $ISUP)
		fi
	fi
done <~/.scr/net/pinglist.txt
notify-send -t 1000 --icon=gtk-info PingCheck "$ALLDOWN"
