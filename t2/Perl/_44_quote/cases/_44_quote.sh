#!/bin/bash
. $init_path/init.sh
init test

tar -zxvf _44_quote.tar.gz
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

echo "###start quote_insert_01.pl "  >_44_quote.result
perl quote_insert_01.pl $db $port $localhost >quote_insert_01.log
compare_result_between_files "quote_insert_01.log" "quote_insert_01.result"

echo "###start quote_insert_02.pl "  >>_44_quote.result
perl quote_insert_02.pl $db $port $localhost >quote_insert_02.log
compare_result_between_files "quote_insert_02.log" "quote_insert_02.result"

echo "###start quote_update_01.pl "  >>_44_quote.result
perl quote_update_01.pl $db $port $localhost >quote_update_01.log
compare_result_between_files "quote_update_01.log" "quote_update_01.result"

echo "###start quote_delete_01.pl "  >>_44_quote.result
perl quote_delete_01.pl $db $port $localhost >quote_delete_01.log
compare_result_between_files "quote_delete_01.log" "quote_delete_01.result"

echo "###start quote_prepare_01.pl "  >>_44_quote.result
perl quote_prepare_01.pl $db $port $localhost >quote_prepare_01.log
compare_result_between_files "quote_prepare_01.log" "quote_prepare_01.result"

echo "###start quote_bind_01.pl "  >>_44_quote.result
perl quote_bind_01.pl $db $port $localhost >quote_bind_01.log
compare_result_between_files "quote_bind_01.log" "quote_bind_01.result"

echo "###start testrows.pl "  >>_44_quote.result
perl testrows.pl $db $port $localhost >testrows.log
compare_result_between_files "testrows.log" "testrows.result"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log *.result *.pl
finish
