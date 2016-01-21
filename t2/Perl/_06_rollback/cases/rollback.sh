#!/bin/bash
#. $init_path/init.sh
#init test

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

echo "###start simple_rollback_01.pl "  >rollback.result
perl simple_rollback_01.pl $db $port $localhost >>rollback.result
echo "###start simple_rollback_02.pl "  >>rollback.result
perl simple_rollback_02.pl $db $port $localhost >>rollback.result
echo "###start simple_rollback_03.pl "  >>rollback.result
perl simple_rollback_03.pl $db $port $localhost >>rollback.result
echo "###start simple_rollback_04.pl "  >>rollback.result
perl simple_rollback_04.pl $db $port $localhost >>rollback.result
echo "###start simple_rollback_05.pl "  >>rollback.result
perl simple_rollback_05.pl $db $port $localhost >>rollback.result
echo "###start simple_rollback_06.pl "  >>rollback.result
perl simple_rollback_06.pl $db $port $localhost >>rollback.result


cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
