#!perl -w

use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;

$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name char(20));") or die "create error: $dbh->errstr";
my $insertString="insert into tbl values(1,'zhangsan'),(2,'lisi'),(3,'wangwu'),(4,'mazi');";

plan tests=>1;
my $sth=$dbh->prepare($insertString);
ok($sth->execute(),"prepare of insert succeed");

$sth->finish();
$dbh -> disconnect();




