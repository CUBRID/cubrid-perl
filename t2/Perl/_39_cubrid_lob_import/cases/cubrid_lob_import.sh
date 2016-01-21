#!/bin/bash
. $init_path/init.sh
init test

curPath=`pwd`
isdbexist=`cat ${CUBRID_DATABASES}/databases.txt | grep "^pldb\b" | wc -l`
if [ $isdbexist -ne 1 ]
then
  echo "pldb does not exist, create it..."
  cubrid createdb pldb --db-volume-size=20M   
fi
cubrid server start pldb
cubrid broker start
port=`cubrid broker status -b|grep broker1|awk '{print $4}'`
#a=`cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep IPADDR|awk '{print $1}'`
#localhost="${a#*=}"
localhost=`/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'`
echo "===============$port======="
echo "==============$localhost======"
db=pldb
echo "###start cubrid_lob_import_01.pl "  >cubrid_lob_import.result
perl cubrid_lob_import_01.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start cubrid_lob_import_02.pl "  >>cubrid_lob_import.result
perl cubrid_lob_import_02.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start cubrid_lob_import_03.pl "  >>cubrid_lob_import.result
perl cubrid_lob_import_03.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start cubrid_lob_import_04.pl " $curPath >>cubrid_lob_import.result
perl cubrid_lob_import_04.pl $db $port $localhost $curPath >>cubrid_lob_import.result
echo "###start cubrid_lob_import_05.pl " $curPath >>cubrid_lob_import.result
perl cubrid_lob_import_05.pl $db $port $localhost $curPath>>cubrid_lob_import.result
echo "###start import_1.pl " $curPath >>cubrid_lob_import.result
perl import_1.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start import_2.pl " $curPath >>cubrid_lob_import.result
perl import_2.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start import_3.pl " $curPath >>cubrid_lob_import.result
perl import_3.pl $db $port $localhost >>cubrid_lob_import.result
echo "###start import_4.pl " $curPath >>cubrid_lob_import.result
perl import_4.pl $db $port $localhost >>cubrid_lob_import.result
cubrid server stop pldb
cubrid deletedb pldb

rm t.tmp *.err *.log
finish
