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
$dbh -> do("drop table if EXISTS x3;") or die "drop error: $dbh->errstr";
$dbh->do("create table x3 (dt date);") or die "create error: $dbh->errstr";
$dbh->commit or die "commit error: $dbh->errstr";

$dbh->do("insert into x3 values (DATE '2008-10-31');") or die "insert error: $dbh->errstr";
$dbh->do("insert into x3 values (DATE '10/31');") or die "insert error: $dbh->errstr";

plan tests=>2;

my $sth=$dbh->prepare("select * from x3;") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $rows_before=$sth->rows;
#print "value of rows is $rows_before \n";
ok($rows_before eq 2,"rollback ok");

$sth->finish();
$dbh->rollback();


my $sth=$dbh->prepare("select * from x3;") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $rows_after=$sth->rows;
#print "value of rows is $rows_after after rollback \n";
ok($rows_after eq 0, "rollback ok");

$sth->finish;
$dbh->disconnect();
