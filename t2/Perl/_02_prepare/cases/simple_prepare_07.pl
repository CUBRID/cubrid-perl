#!perl -w

#using NULL value

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

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int, name char(20),age int);") or die "create error: $dbh->errstr";
$dbh -> do("insert into tbl values(1,'zhangsan',30);") or die "insert error:$dbh->errstr";

plan tests=>1;
my $sth=$dbh->prepare("insert into tbl (id,name,age) values (?,?,?)") or die "select error: $dbh->errstr";
ok($sth->execute(1,undef,28),"NULL value ok");

$sth->finish();
$dbh -> disconnect();
