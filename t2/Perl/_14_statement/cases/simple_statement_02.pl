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
$dbh->do("create table tdb (t date);") or die "drop error: $dbh->errstr"; 

my $statement="insert into tdb values(DATE '0000-10-31' );";
$dbh->do($statement);
my $insertResult=$dbh->errstr;

plan tests=>1;
ok( $insertResult ,"insert ok");

$dbh -> disconnect();



