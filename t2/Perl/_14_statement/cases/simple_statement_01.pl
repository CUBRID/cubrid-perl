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

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";

my $statement="create table tdb (t times);";
$dbh->do($statement);

plan tests=>1;
my $createResult=$dbh->err;
is($createResult,-20001, "create ok");
$dbh -> disconnect();



