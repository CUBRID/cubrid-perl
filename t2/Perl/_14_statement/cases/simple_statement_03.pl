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



plan tests=>11;
#####NUMERIC######
$dbh->do("create table tdb (num NUMERIC(4));") or die "drop error: $dbh->errstr"; 
my $statement1="insert into tdb values(12345.6789);";
$dbh->do($statement1);
my $insertResult1=$dbh->errstr;
ok($insertResult1,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(num NUMERIC(4,4));") or die "drop error: $dbh->errstr";
my $statement2="insert into tdb values(-0.123456789);";
$dbh->do($statement2);
my $insertResult2=$dbh->errstr;
ok(!$insertResult2,"insert ok");

#####bigint#####
$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(bg bigint);") or die "drop error: $dbh->errstr";
my $statement3="insert into tdb values(89.1);";
$dbh->do($statement3);
my $insertResult3=$dbh->errstr;
ok(!$insertResult3,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(bg bigint);") or die "drop error: $dbh->errstr";
my $statement4="insert into tdb values(89.1);";
$dbh->do($statement4);
my $insertResult4=$dbh->errstr;
ok(!$insertResult4,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(bg bigint);") or die "drop error: $dbh->errstr";
my $statement5="insert into tdb values(9223372036854775809);";
$dbh->do($statement5);
my $insertResult5=$dbh->errstr;
ok($insertResult5,"insert ok");






#####float#####

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(ft float(5));") or die "drop error: $dbh->errstr";
my $statement6="insert into tdb values(1234.56789);";
$dbh->do($statement6);
my $insertResult6=$dbh->errstr;
ok(!$insertResult6,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(ft float(10));") or die "drop error: $dbh->errstr";
my $statement7="insert into tdb values(12345678.9);";
$dbh->do($statement7);
my $insertResult7=$dbh->errstr;
ok(!$insertResult7,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(ft float);") or die "drop error: $dbh->errstr";
my $statement8="insert into tdb values( -3.402823468E+38 );";
$dbh->do($statement8);
my $insertResult8=$dbh->errstr;
ok($insertResult8,"insert ok");

#####double#####
$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(db double);") or die "drop error: $dbh->errstr";
my $statement9="insert into tdb values(  1234.56789  );";
$dbh->do($statement9);
my $insertResult9=$dbh->errstr;
ok(!$insertResult9,"insert ok");

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(db double);") or die "drop error: $dbh->errstr";
my $statement10="insert into tdb values('a');";
$dbh->do($statement10);
my $insertResult10=$dbh->errstr;
ok($insertResult10,"insert ok");

#####monetary#####
$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh->do("create table tdb(mn monetary);") or die "drop error: $dbh->errstr";
my $statement11="insert into tdb values(123456789);";
$dbh->do($statement11);
my $insertResult11=$dbh->errstr;
ok(!$insertResult11,"insert ok");




$dbh -> disconnect();



