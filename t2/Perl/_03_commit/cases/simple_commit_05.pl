#!perl -w

use DBI;
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

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1, AutoCommit => 0}) or die "connect error: $dbh->errstr";

$dbh -> do("drop table if EXISTS test_tbl;") or die "drop error: $dbh->errstr";

$dbh -> do("create table test_tbl(age int,firstName char(20),lastName char(10),income float);") or die "create error: $dbh->errstr";

my $age=26;
my $firstName="john";
my $lastName="poul";
my $income=13000;
my $sth=$dbh->prepare("insert into test_tbl (age,firstName,lastName,income) values (?,?,?,?);");
$sth->execute($age,$firstName,$lastName,$income) or die "execute error: $dbh->errstr";

plan tests=>1;
ok($dbh ->commit(),"commit ok");

$sth->finish();
$dbh -> disconnect();




