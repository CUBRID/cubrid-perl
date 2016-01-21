#!perl -w

#Test $rows=$dbh->do(select statement).
use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 
$db=$ARGV[0];
$port=$ARGV[2];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=localhost;port=$port";
my $dbh;
$dbh=DBI->connect($data_source, $user, $pass,{PrintError => 1, RaiseError=>0}) or warn("$DBI::errstr");
$dbh -> do("drop table if EXISTS t1;") or warn("drop error: $DBI::errstr");
$dbh -> do("create table t1(id int,a string);") or warn("create error: $DBI::errstr");


my $sel_sql="select * from t1";
my $rows=$dbh->do($sel_sql) or warn("Cannot delete all: $DBI::errstr");
print "*****rows=".$rows."\n";
is($rows,'0E0',"has deleted all");


done_testing();
$dbh -> disconnect();
