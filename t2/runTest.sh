#!/bin/bash
set -x
cur_path=`pwd`
memoreyLeak=0
cubrid server start demodb
cubrid broker start 

rm -rf memoryLeaklog
mkdir  memoryLeaklog
rm -rf listFile
mkdir listFile
rm -rf function_result
mkdir  function_result

echo "Perl DBI Test Begin..."
#get all file name of test cases
cd ./Perl
find ./ -name "*.sh" > ./../memoryLeaklog/CUBRID_Perl.list_file

#get .sh file path
while read LIST_FILE
do
   PATH_NAME=${LIST_FILE#*./}
   PATH_NAME=${PATH_NAME%/*}
   echo $PATH_NAME >> ./../listFile/casePath.list
done < ./../memoryLeaklog/CUBRID_Perl.list_file

#run all test case
i=0
while read LIST_FILE
do
   cd $LIST_FILE
   path=`pwd`
   echo "path: $path"
   FILE_NAME=${LIST_FILE%/cases*}
   FILE_NAME=${FILE_NAME}_$i
   
   if [ memoryLeak == 1 ] then
   valgrind --leak-check=full --log-file=./../../../memoryLeaklog/$FILE_NAME.memoryleak sh *.sh > ./../../../function_result/$FILE_NAME.result 2>&1
   fi 

   cd ../..
   i=$((i+1))
done < ./../listFile/casePath.list

#get result
cd $cur_path
find ./ -name "*.result"|xargs grep "not ok" > function_result/CUBRID_Perl_finally.result
find ./ -name "*.result"|xargs grep "NOK" >> function_result/CUBRID_Perl_finally.result

#rm ./memoryLeaklog/CUBRID_Perl.list_file
cd ..

echo "Perl DBI Test End"

