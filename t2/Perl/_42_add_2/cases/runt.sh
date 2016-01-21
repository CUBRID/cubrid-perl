#!/bin/bash

cubrid server start demodb
cubrid broker start
echo "####10connect.t#####"
perl 10connect.t

echo "####20createdrop.t#####"
perl 20createdrop.t

echo "####25simplefetch.t#####"
perl 25simplefetch.t

echo "####30insertfetch.t#####"
perl 30insertfetch.t

echo "####31insertid.t#####"
perl 31insertid.t

echo "####32insert_error.t#####"
perl 32insert_error.t

echo "####32ping.t#####"
perl 32ping.t

echo "####35limit.t#####"
perl 35limit.t

echo "####35prepare.t#####"
perl 35prepare.t

echo "####40bindparam.t#####"
perl 40bindparam.t

echo "####40columninfo.t#####"
perl 40columninfo.t

echo "####40keyinfo.t#####"
perl 40keyinfo.t

echo "####40listfields.t#####"
perl 40listfields.t

echo "####40lobs_file.t#####"
perl 40lobs_file.t

echo "####40lobs.t#####"
perl 40lobs.t

echo "####40nulls_prepare.t#####"
perl 40nulls_prepare.t

echo "####40nulls.t#####"
perl 40nulls.t


echo "####40numrows.t#####"
perl 40numrows.t

echo "####40server_prepare_error.t#####"
perl 40server_prepare_error.t

echo "####40serverprepare.t#####"
perl 40serverprepare.t

echo "####40tableinfo.t#####"
perl 40tableinfo.t

echo "####50commit.t#####"
perl 50commit.t

echo "####base_01.t#####"
perl base_01.t
