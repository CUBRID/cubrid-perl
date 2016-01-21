#!/bin/bash
#. $init_path/init.sh
#init test

db=other
dir=`pwd`
cubrid server stop $db
cubrid deletedb $db
rm -rf $db

mkdir $db
cd $db

cubrid createdb --db-volume-size=20M $db

cubrid server start $db
cubrid broker start
cd ..

port=`cubrid broker status -b|grep broker1|awk '{print $4}'`
localhost=`/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'`

echo "###APIS-56.pl "  >>other.result
perl APIS-56.pl $db $port $localhost >>other.result
echo "###APIS-57.pl "  >>other.result
perl APIS-57.pl $db $port $localhost >>other.result
echo "###APIS-60.pl "  >>other.result
perl APIS-60.pl $db $port $localhost >>other.result
echo "###APIS-61.pl "  >>other.result
perl APIS-61.pl $db $port $localhost >>other.result
echo "###APIS-77.pl "  >>other.result
perl APIS-77.pl $db $port $localhost >>other.result
cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
