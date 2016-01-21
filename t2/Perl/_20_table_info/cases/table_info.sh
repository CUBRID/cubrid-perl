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
echo "###start simple_table_info_01.pl "  >table_info.result
perl simple_table_info_01.pl $db $port $localhost >>table_info.result
echo "###start simple_table_info_02.pl "  >>table_info.result
perl simple_table_info_02.pl $db $port $localhost >>table_info.result
echo "###start simple_table_info_03.pl "  >>table_info.result
perl simple_table_info_03.pl $db $port $localhost >>table_info.result
echo "###start simple_table_info_04.pl "  >>table_info.result
perl simple_table_info_04.pl $db $port $localhost >>table_info.result
echo "###start simple_table_info_05.pl "  >>table_info.result
perl simple_table_info_05.pl $db $port $localhost >>table_info.result
echo "###start table_info_01.pl "  >>table_info.result
perl table_info_01.pl $db $port $localhost >table_info_01.log
compare_result_between_files "table_info_01.log" "table_info_01.answer"
echo "###start table_info_2.pl "  >>table_info.result
perl table_info_2.pl $db $port $localhost >table_info_2.log 2>&1
compare_result_between_files "table_info_2.log" "table_info_2.answer"
echo "###start table_info_3.pl "  >>table_info.result
perl table_info_3.pl $db $port $localhost >table_info_3.log 2>&1
compare_result_between_files "table_info_3.log" "table_info_3.answer"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
finish
