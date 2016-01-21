#!/bin/bash
. $init_path/init.sh
init test


echo "#################Testcase1##########"
db=i18
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

echo "###i18n_01.pl "  >i18n.result
perl i18n_01.pl $db $port $localhost >i18n_01.log
compare_result_between_files "i18n_01.log" "i18n_01.answer"
cubrid server stop $db
cubrid deletedb $db
cubrid service stop
rm -rf $db

echo "###################Testcase2############"
lang_bak=`echo $CUBRID_LANG`
export CUBRID_LANG=$CUBRID_LANG.utf8

db1=i181
cubrid server stop $db1
cubrid deletedb $db1
rm $db1
mkdir $db1
cd $db1
cubrid createdb $db1 --db-volume-size=20M
cubrid server start $db1
cubrid broker start
cd ..
perl i18n_01.pl $db1 $port $localhost >i18n_02.log
compare_result_between_files "i18n_02.log" "i18n_02.answer"

cubrid server stop $db1
cubrid service stop 
export CUBRID_LANG=$lang_bak
cd $dir
rm -rf $db1


echo "###################Testcase3############"
cp $CUBRID/conf/cubrid_locales.txt cubrid_locales.txt.bak
cp $CUBRID/conf/cubrid_locales.all.txt $CUBRID/conf/cubrid_locales.txt
make_locale.sh -t 64
export CUBRID_LANG=ko_KR
cubrid service start
db2=kr
mkdir $db2
cd $db2
cubrid createdb $db2 --db-volume-size=20M
cd ..
perl i18n_02.pl $db2 $port $localhost

cubrid server stop $db2
cubrid deletedb $db2
rm -rf $db2
cp cubrid_locales.txt.bak $CUBRID/conf/cubrid_locales.txt
make_locale.sh -t 64
export CUBRID_LANG=$lang_bak



rm t.tmp *.err *.log
finish
