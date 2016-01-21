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
localhost=/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'

echo "###start simple_prepare_01.pl "  >prepare.result
perl simple_prepare_01.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_02.pl "  >>prepare.result
perl simple_prepare_02.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_03.pl "  >>prepare.result
perl simple_prepare_03.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_04.pl "  >>prepare.result
perl simple_prepare_04.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_05.pl "  >>prepare.result
perl simple_prepare_05.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_06.pl "  >>prepare.result
perl simple_prepare_06.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_07.pl "  >>prepare.result
perl simple_prepare_07.pl $db $port $localhost >>prepare.result
echo "###start simple_prepare_08.pl "  >>prepare.result
perl simple_prepare_08.pl $db $port $localhost >>prepare.result


cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
