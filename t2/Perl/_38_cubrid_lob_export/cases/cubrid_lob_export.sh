#!/bin/bash
. $init_path/init.sh
init test
set -x

tar -zxvf answer.tar.gz
curPath=`pwd`
db=pldb
cubrid server stop $db
cubrid deletedb $db
rm -rf $db
mkdir $db
cd $db
cubrid createdb --db-volume-size=20M $db
cubrid server start $db
cubrid broker start

port=`cubrid broker status -b|grep broker1|awk '{print $4}'`
#a=`cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep IPADDR|awk '{print $1}'`
#localhost="${a#*=}"
localhost=`/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'`

cd $curPath
echo "###start simple_cubrid_lob_export_01.pl ">>cubrid_lob_export.result
perl cubrid_lob_export_01.pl $db $port $localhost 
compare_result_between_files "export1.txt" "export1.answer"
compare_result_between_files "$curPath/$db/export2.txt" "export2.answer"

echo "###start simple_cubrid_lob_export_02.pl ">>cubrid_lob_export.result
perl cubrid_lob_export_02.pl $db $port $localhost
for((i=1;i<6;i++));
do
 compare_result_between_files "export_$i.txt" "export_$i.answer"
done
:<<EOF
echo "###start simple_cubrid_lob_export_03.pl "  >>cubrid_lob_export.result
perl cubrid_lob_export_03.pl $db $port $localhost >>cubrid_lob_export.result
compare_result_between_files "export1B.txt" "export1B.answer"
compare_result_between_files "$curPath/$db/export2B.jpg" "export2B.answer"
compare_result_between_files "$curPath/$db/export3B.jpg" "export3B.answer"
EOF
echo "###start simple_cubrid_lob_export_04.pl "  >>cubrid_lob_export.result
perl cubrid_lob_export_04.pl $db $port $localhost >>cubrid_lob_export.result
compare_result_between_files "exportB4.txt" "exportB4.answer"

echo "###start export_1.pl "  >>cubrid_lob_export.result
perl export_1.pl $db $port $localhost >export_1_pl.txt
re_result_between_files "export_1_pl.txt" "export_1_pl.answer"

:<<EOF1
echo "###start export_2.pl "  >>cubrid_lob_export.result
perl export_2.pl $db $port $localhost >export_2_pl.txt
re_result_between_files "export_2_pl.txt" "export_2_pl.answer"
EOF1

rm t.tmp *.err *.log
cubrid server stop $db
cubrid deletedb $db
rm -rf $db
rm -rf *.answer *.txt
finish
