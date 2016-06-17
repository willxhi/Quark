#!/bin/sh
main()
{
_MYDIR=$(dirname $(readlink -f $0))
_MYNAME=`basename $0`

sed -n '1,16p' $_MYDIR/wi_template.sh > $2
cat $1 >> $2
sed -n '17,24p' <$_MYDIR/wi_template.sh >>$2
}

main