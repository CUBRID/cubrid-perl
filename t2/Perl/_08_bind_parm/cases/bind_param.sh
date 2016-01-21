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
echo "###start simple_bind_param_01.pl "  >bind_param.result
perl simple_bind_param_01.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_02.pl "  >>bind_param.result
perl simple_bind_param_02.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_03.pl "  >>bind_param.result
perl simple_bind_param_03.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_04.pl "  >>bind_param.result
perl simple_bind_param_04.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_05.pl "  >>bind_param.result
perl simple_bind_param_05.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_06.pl "  >>bind_param.result
perl simple_bind_param_06.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_07.pl "  >>bind_param.result
perl simple_bind_param_07.pl $db $port $localhost >>bind_param.result
echo "###start simple_bind_param_08.pl "  >>bind_param.result
perl simple_bind_param_08.pl $db $port $localhost >>bind_param.result

echo "###start bind_param_1.pl "  >>bind_param.result
perl bind_param_1.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_2.pl "  >>bind_param.result
perl bind_param_2.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_3.pl "  >>bind_param.result
perl bind_param_3.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_4.pl "  >>bind_param.result
perl bind_param_4.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_5.pl "  >>bind_param.result
perl bind_param_5.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_6.pl "  >>bind_param.result
perl bind_param_6.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_7.pl "  >>bind_param.result
perl bind_param_7.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_8.pl "  >>bind_param.result
perl bind_param_8.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_9.pl "  >>bind_param.result
perl bind_param_9.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_10.pl "  >>bind_param.result
perl bind_param_10.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_11.pl "  >>bind_param.result
perl bind_param_11.pl $db $port $localhost >>bind_param.result
echo "###start bind_param_12.pl "  >>bind_param.result
perl bind_param_12.pl $db $port $localhost >>bind_param.result

echo "###start simple_bind_param_inout_01.pl  "  >>bind_param.result
perl simple_bind_param_inout_01.pl $db $port $localhost >>bind_param.result

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log
#finish
