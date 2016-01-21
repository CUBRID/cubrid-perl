#!/bin/bash
. $init_path/init.sh
init test

db=pldb
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
#a=`cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep IPADDR|awk '{print $1}'`
#localhost="${a#*=}"
localhost=`/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'`

echo "###start simple_scale_01.pl "  >scale.result
perl simple_scale_01.pl $db $port $localhost >>scale_01.log
compare_result_between_files "scale_01.log" "scale_01.answer"

echo "###start simple_scale_02.pl "  >>scale.result
perl simple_scale_02.pl $db $port $localhost >>scale_02.log
compare_result_between_files "scale_02.log" "scale_02.answer"

echo "###start simple_scale_03.pl "  >>scale.result
perl simple_scale_03.pl $db $port $localhost >>scale_03.log
compare_result_between_files "scale_03.log" "scale_03.answer"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
finish
