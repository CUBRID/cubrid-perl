#!/bin/bash
#. $init_path/init.sh
#init test

db=enum43
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

echo "###hold_basic.pl "  >_45_holdability.result
perl hold_basic.pl $db $port $localhost >>_45_holdability.result
echo "###hold_commit_01.pl" >>_45_holdability.result
perl hold_commit_01.pl $db $port $localhost >>_45_holdability.result
echo "###hold_commit.pl" >>_45_holdability.result
perl hold_commit.pl $db $port $localhost >>_45_holdability.result
echo "###hold_commit.pl "  >>_45_holdability.result
perl hold_commit_rollback.pl $db $port $localhost >>_45_holdability.result
echo "###hold_many_select_01.pl "  >>_45_holdability.result
perl hold_many_select_01.pl $db $port $localhost >>_45_holdability.result
echo "###hold_many_select_02.pl "  >>_45_holdability.result
perl hold_many_select_02.pl $db $port $localhost >>_45_holdability.result
echo "###hold_rollback_01.pl "  >>_45_holdability.result
perl hold_rollback_01.pl $db $port $localhost >>_45_holdability.result
echo "###hold_rollback.pl "  >>_45_holdability.result
perl hold_rollback.pl $db $port $localhost >>_45_holdability.result

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
