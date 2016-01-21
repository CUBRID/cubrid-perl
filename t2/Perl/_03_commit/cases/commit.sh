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

echo "###start simple_commit_01.pl "  >commit.result
perl simple_commit_01.pl $db $port $localhost >>commit.result
echo "###start simple_commit_02.pl "  >>commit.result
perl simple_commit_02.pl $db $port $localhost >>commit.result
echo "###start simple_commit_03.pl "  >>commit.result
perl simple_commit_03.pl $db $port $localhost >>commit.result
echo "###start simple_commit_04.pl "  >>commit.result
perl simple_commit_04.pl $db $port $localhost >>commit.result
echo "###start simple_commit_05.pl "  >>commit.result
perl simple_commit_05.pl $db $port $localhost >>commit.result
echo "###start simple_commit_06.pl "  >>commit.result
perl simple_commit_06.pl $db $port $localhost >>commit.result

cubrid server start demodb
cubrid broker start
echo "###start commit_01.pl "  >>commit.result
perl commit_01.pl $port $localhost >commit_01.txt
compare_result_between_files "commit_01.txt" "commit_01.answer"
echo "###start commit_02.pl "  >>commit.result
perl commit_02.pl $port $localhost >commit_02.log
compare_result_between_files "commit_02.log" "commit_02.answer"
echo "###start commit_02.pl "  >>commit.result
perl commit_03.pl $port $localhost >commit_03.log
compare_result_between_files "commit_03.log" "commit_03.answer"


cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
finish
