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
$dbh -> do("create table tdb(age int,firstName varchar(20),lastName varchar(20),dt date);") or die "create error: $dbh->errstr";

$dbh->{PrintError}=1;
$dbh->{RaiseError}=0;
my $sth=$dbh->prepare("insert into tdb (firstName,lastName) values(?);") or die "prepare error: $dbh->errstr";
$sth->execute("Adams,Bill");# or warn "execute error: $DBI::errstr";
#like($DBI::errstr,qr/"CUBRID DBMS Error : \(-494\) Semantic: before"/,"error msg compare");
$sth->finish();
$dbh -> disconnect();

