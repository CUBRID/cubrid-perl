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

echo "###start primary_key_01.pl "  >primary_key.result
perl primary_key_01.pl $db $port $localhost >>primary_key.result
echo "###start primary_key_02.pl "  >primary_key.result
perl primary_key_02.pl $db $port $localhost >>primary_key.result
echo "###start primary_key_03.pl "  >primary_key.result
perl primary_key_03.pl $db $port $localhost >>primary_key.result
echo "###start primary_key_04.pl "  >primary_key.result
perl primary_key_04.pl $db $port $localhost >>primary_key.result
echo "###start primary_key_05.pl "  >>primary_key.result
perl primary_key_05.pl $db $port $localhost >>primary_key.result
echo "###start primary1.pl "  >>primary_key.result
perl primary1.pl $db $port $localhost >>primary1.log
compare_result_between_files "primary1.log" "primary1.answer"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
finish
