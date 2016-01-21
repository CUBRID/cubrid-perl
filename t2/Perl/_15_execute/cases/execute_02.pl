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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(age int,firstName varchar(20),lastName varchar(20));") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tdb (firstName,lastName) values(?,?);") or die "prepare error: $dbh->errstr";
$sth->execute("Adams","Bill") or die "execute error: $dbh->errstr";

my @values=(1,'Jim','Bri');
my $sth2=$dbh->prepare("insert into tdb values(?,?,?);") or die "prepare error: $dbh->errstr";
my $exResult=$sth2->execute(@values) or die "execute error: $dbh->errstr";
print "exResult: $exResult\n";
is($exResult,1,"insert is ok");
$sth->finish();
$sth2->finish();
$dbh -> disconnect();

