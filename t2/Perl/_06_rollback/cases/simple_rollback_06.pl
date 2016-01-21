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

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($data_source, $user, $pass,{RaiseError => 1,AutoCommit =>0}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(id int);") or die "create error: $dbh->errstr";
$dbh->commit or die "commit error: $dbh->errstr";

my $insertString="insert into tdb values(1),(2),(3)";
$dbh ->do($insertString) or die "insert error: $dbh->errstr";
my $sth=$dbh->prepare("select * from tdb;") or die"prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $rows_before=$sth->rows;
print "rows value is $rows_before before rollback\n";

plan tests=>2;
ok($rows_before eq 3, "rollback ok");
$sth->finish();


$dbh->rollback();
my $sth1=$dbh->prepare("select * from tdb;") or die "prepare error: $dbh->errstr";
$sth1->execute or die "execute error: $dbh->errstr";
my $rows_after=$sth1->rows;
print "rows value is $rows_after after rollback\n";

ok($rows_after eq 0, "rollback ok");

$sth->finish();
$sth1->finish();
$dbh -> disconnect();




