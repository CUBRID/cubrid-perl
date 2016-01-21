#!/bin/bash
. $init_path/init.sh
init test
set -x

db=db_conn_01
rm -rf $db
mkdir $db
cd $db
cubrid createdb --db-volume-size=20M $db
cubrid server start $db
cd ..

cubrid broker start
port=`cubrid broker status -b|grep broker1|awk '{print $4}'`

#get ip of this computer
#a=`cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep IPADDR|awk '{print $1}'`
#ip_add="${a#*=}"
ip_add=`/sbin/ifconfig | grep inet | grep -v 127 | awk '{print $2}' | sed 's/addr://g'|sed -n '1p'`

output_file=${case_name}.output
echo " simple_connection_01.pl*********">$output_file
perl simple_connection_01.pl $db localhost $port>>$output_file
perl simple_connection_01.pl $db $ip_add $port >>$output_file
perl simple_connection_01.pl $db 127.0.0.1 $port >>$output_file

echo " simple_connection_02.pl*********">>$output_file
perl simple_connection_02.pl >>$output_file

echo " simple_connection_03.pl*********">>$output_file
perl simple_connection_03.pl $db localhost error_port >>$output_file

echo " simple_connection_04.pl*********">>$output_file
perl simple_connection_04.pl $db $ip_add $port >>$output_file

echo " simple_connection_05.pl*********">>$output_file
perl simple_connection_05.pl $db $ip_add $port >>$output_file

echo " simple_connection_06.pl*********">>$output_file
perl simple_connection_06.pl $db $ip_add $port >>$output_file

echo " simple_connection_07.pl*********">>$output_file
perl simple_connection_07.pl $db $ip_add $port >>$output_file 2>&1

echo " simple_connection_08.pl*********">>$output_file
perl simple_connection_08.pl $db $ip_add $port >>$output_file 2>&1

echo " simple_connection_09.pl*********">>$output_file
perl simple_connection_09.pl $db $ip_add $port >>$output_file 2>&1

echo " simple_connection_10.pl*********">>$output_file
perl simple_connection_10.pl $db $ip_add $port >>$output_file 2>&1

compare_result_between_files "${output_file}" "${case_name}.answer"

cubrid server stop $db
cubrid broker stop
cubrid deletedb $db
rm -rf $db
rm $output_file
finish

