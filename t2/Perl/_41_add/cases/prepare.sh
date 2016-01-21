#!/bin/bash
#. $init_path/init.sh
#init test

cubrid server start demodb
cubrid broker start

echo "APIS-62.pl"
perl  APIS-62.pl demodb 33022 10.34.64.212
echo "APIS-64.pl"
perl APIS-64.pl demodb 33022 10.34.64.212
echo "APIS-65.pl"
perl APIS-65.pl demodb 33022 10.34.64.212
echo "APIS-66.pl"
perl APIS-66.pl 33022 10.34.64.212
echo "APIS-67.pl"
perl APIS-67.pl demodb 33022 10.34.64.212
echo "APIS-68.pl"
perl APIS-68.pl demodb 33022 10.34.64.212
echo "APIS-69.pl"
perl APIS-69.pl demodb 33022 10.34.64.212
echo "APIS-70.pl"
perl APIS-70.pl demodb 33022 10.34.64.212
echo "APIS-71.pl"
perl APIS-71.pl demodb 33022 10.34.64.212
echo "APIS-73.pl"
perl APIS-73.pl demodb 33022 10.34.64.212
echo "APIS-76.pl"
perl APIS-76.pl demodb 33022 10.34.64.212
echo "APIS-78.pl"
perl APIS-78.pl demodb 33022 10.34.64.212
echo "APIS-80.pl"
perl APIS-80.pl demodb 33022 10.34.64.212
echo "APIS-81.pl"
perl APIS-81.pl demodb 33022 10.34.64.212
echo "APIS-82.pl"
perl APIS-82.pl demodb 33022 10.34.64.212
echo "APIS-83.pl"
perl APIS-83.pl demodb 33022 10.34.64.212
echo "APIS-84.pl"
perl APIS-84.pl demodb 33022 10.34.64.212
echo "APIS-85.pl"
perl APIS-85.pl demodb 33022 10.34.64.212
echo "APIS-86.pl"
perl APIS-86.pl demodb 33022 10.34.64.212
echo "bind_1.pl"
perl bind_1.pl demodb 33022 10.34.64.212
echo "commit_test.pl"
perl commit_test.pl demodb 33022 10.34.64.212
echo "drivers_1.pl"
perl drivers_1.pl demodb 33022 10.34.64.212
echo "drivers_2.pl"
perl drivers_2.pl demodb 33022 10.34.64.212
echo "err_bind_param_13.pl"
perl err_bind_param_13.pl demodb 33022 10.34.64.212
echo "err.pl"
perl err.pl demodb 33022 10.34.64.212
echo "test.pl"
perl test.pl demodb 33022 10.34.64.212


cubrid server stop demodb
cubrid broker stop

rm t.tmp *.err *.log
#finish
