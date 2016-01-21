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
$dbh -> do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tb (id int NOT NULL PRIMARY KEY,bgi bigint, ft float, my monetary);") or die "create error: $dbh->errstr";


my $sth=$dbh->prepare("insert into tb values(?,?,?,?);") or die "prepare error: $dbh->errstr";
#$sth->execute(1,89.9, BIT_TO_BLOB(X'000001'), CHAR_TO_CLOB('This is a Dog'),1234.56789,12345.67898934) or die "execute error: $dbh->errstr";
my $paramNumber=$sth->{NUM_OF_PARAMS};
is($paramNumber,4,"NUM_OF_PARAMS ok");
done_testing();

$sth->finish();
$dbh -> disconnect();



