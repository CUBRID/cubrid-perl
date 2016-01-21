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
echo "###start simple_fetch_01.pl "  >table_info.result
perl simple_fetch_01.pl $db $port $localhost >>fetch.result
echo "###start simple_fetch_02.pl "  >table_info.result
perl simple_fetch_02.pl $db $port $localhost >>fetch.result
echo "###start simple_fetch_03.pl "  >table_info.result
perl simple_fetch_03.pl $db $port $localhost >>fetch.result
echo "###start simple_fetch_04.pl "  >table_info.result
perl simple_fetch_04.pl $db $port $localhost >>fetch.result
echo "###start fetch_01.pl "  >table_info.result
perl fetch_01.pl $db $port $localhost >>fetch_01.log
compare_result_between_files "fetch_01.log" "fetch_01.answer"
echo "###start fetch_02.pl "  >table_info.result
perl fetch_02.pl $db $port $localhost >>fetch_02.log
compare_result_between_files "fetch_02.log" "fetch_02.answer"
echo "###start fetch_03.pl "  >table_info.result
perl fetch_03.pl $db $port $localhost >>fetch_03.log
compare_result_between_files "fetch_03.log" "fetch_03.answer"
echo "###start fetch_04.pl "  >table_info.result
perl fetch_04.pl $db $port $localhost >>fetch_04.log
compare_result_between_files "fetch_04.log" "fetch_04.answer"
echo "###start fetch_05.pl "  >table_info.result
perl fetch_05.pl $db $port $localhost >>fetch_05.log
compare_result_between_files "fetch_05.log" "fetch_05.answer"
echo "###start fetch_06.pl "  >table_info.result
perl fetch_06.pl $db $port $localhost >>fetch_06.log
compare_result_between_files "fetch_06.log" "fetch_06.answer"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
#rm t.tmp *.err *.log
finish
