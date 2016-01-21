#!/bin/bash
. $init_path/init.sh
init test

tar -zxvf _43_enum.tar.gz
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

echo "###start enum_prepare_01.pl "  >_43_enum.result
perl enum_prepare_01.pl $db $port $localhost >enum_prepare_01.log
compare_result_between_files "enum_prepare_01.log" "enum_prepare_01.result"

echo "###start enum_prepare_02.pl "  >>_43_enum.result
perl enum_prepare_02.pl $db $port $localhost >enum_rprepare_02.log
compare_result_between_files "enum_prepare_02.log" "enum_prepare_02.result"

echo "###start enum_prepare_03.pl "  >>_43_enum.result
perl enum_prepare_03.pl $db $port $localhost >enum_prepare_03.log
compare_result_between_files "enum_prepare_03.log" "enum_prepare_03.result"

echo "###start enum_prepare_04.pl "  >>_43_enum.result
perl enum_prepare_04.pl $db $port $localhost >enum_prepare_04.log
compare_result_between_files "enum_prepare_04.log" "enum_prepare_04.result"

echo "###start enum_prepare_05.pl "  >>_43_enum.result
perl enum_prepare_05.pl $db $port $localhost >enum_prepare_05.log
compare_result_between_files "enum_prepare_05.log" "enum_prepare_05.result"

echo "###start enum_prepare_06.pl "  >>_43_enum.result
perl enum_prepare_06.pl $db $port $localhost >enum_prepare_06.log
compare_result_between_files "enum_prepare_06.log" "enum_prepare_06.result"

echo "###start enum_bind_param_01.pl "  >>_43_enum.result
perl enum_bind_param_01.pl $db $port $localhost >enum_bind_param_01.log
compare_result_between_files "enum_bind_param_01.log" "enum_bind_param_01.result"

echo "###start enum_bind_param_02.pl "  >>_43_enum.result
perl enum_bind_param_02.pl $db $port $localhost >enum_bind_param_02.log
compare_result_between_files "enum_bind_param_02.log" "enum_bind_param_02.result"

echo "###start enum_bind_param_03.pl "  >>_43_enum.result
perl enum_bind_param_03.pl $db $port $localhost >enum_bind_param_03.log
compare_result_between_files "enum_bind_param_03.log" "enum_bind_param_03.result"

echo "###start enum_bind_param_04.pl "  >>_43_enum.result
perl enum_bind_param_04.pl $db $port $localhost >enum_bind_param_04.log
compare_result_between_files "enum_bind_param_04.log" "enum_bind_param_04.result"

echo "###start enum_execute_01.pl "  >>_43_enum.result
perl enum_execute_01.pl $db $port $localhost >enum_execute_01.log
compare_result_between_files "enum_execute_01.log" "enum_execute_01.result"

echo "###start enum_execute_02.pl "  >>_43_enum.result
perl enum_execute_02.pl $db $port $localhost >enum_execute_02.log
compare_result_between_files "enum_execute_02.log" "enum_execute_02.result"

echo "###start enum_execute_03.pl "  >>_43_enum.result
perl enum_execute_03.pl $db $port $localhost >enum_execute_03.log
compare_result_between_files "enum_execute_03.log" "enum_execute_03.result"

echo "###start enum_execute_04.pl "  >>_43_enum.result
perl enum_execute_04.pl $db $port $localhost >enum_execute_04.log
compare_result_between_files "enum_execute_04.log" "enum_execute_04.result"

echo "###start enum_execute_05.pl "  >>_43_enum.result
perl enum_execute_05.pl $db $port $localhost >enum_execute_05.log
compare_result_between_files "enum_execute_05.log" "enum_execute_05.result"

echo "###start enum_column_01.pl "  >>_43_enum.result
perl enum_column_01.pl $db $port $localhost >enum_column_01.log
compare_result_between_files "enum_column_01.log" "enum_column_01.result"

echo "###start enum_column_02.pl "  >>_43_enum.result
perl enum_column_02.pl $db $port $localhost >enum_column_02.log
compare_result_between_files "enum_column_02.log" "enum_column_02.result"

echo "###enum_delete_01.pl" >>_43_enum.result
perl enum_delete_01.pl $db $port $localhost >enum_delete_01.log
compare_result_between_files "enum_delete_01.log" "enum_delete_01.result"

echo "###enum_scale_01.pl" >>_43_enum.result
perl enum_scale_01.pl $db $port $localhost >enum_scale_01.log
compare_result_between_files "enum_scale_01.log" "enum_scale_01.result"

echo "###testnumber.pl" >>_43_enum.result
perl testnumber.pl $db $port $localhost >testnumber.log
compare_result_between_files "testnumber.log" "testnumber.result"

cubrid server stop $db
cubrid broker stop

cubrid deletedb $db
cd $dir

rm -rf $db
rm t.tmp *.err *.log *.pl *.result
#finish
