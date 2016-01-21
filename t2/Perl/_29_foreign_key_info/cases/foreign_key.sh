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

echo "###start foreign_key_01.pl "  >foreign_key.result
perl foreign_key_01.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_02.pl "  >>foreign_key.result
perl foreign_key_02.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_03.pl "  >>foreign_key.result
perl foreign_key_03.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_04.pl "  >>foreign_key.result
perl foreign_key_04.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_05.pl "  >>foreign_key.result
perl foreign_key_05.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_06.pl "  >>foreign_key.result
perl foreign_key_06.pl $db $port $localhost >>foreign_key.result
echo "###start foreign_key_07.pl "  >>foreign_key.result
perl foreign_key_07.pl $db $port $localhost >>foreign_key.result


cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
