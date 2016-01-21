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


$dbh->do("drop table if EXISTS aoo ;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS boo;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS coo;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS doo;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS eoo;") or die "drop error: $dbh->errstr";


$dbh->do("create table aoo ( a int primary key, b int, c int );") or die "create error: $dbh->errstr";
$dbh->do("create table boo ( a int , b int, c int, primary key(a,b));") or die "create error: $dbh->errstr";
$dbh->do("create table coo ( a int not null primary key, b int, c int );") or die "create error: $dbh->errstr";
$dbh->do("create table doo ( a int not null, b string not null, c int, primary key(a,b));") or die "create error: $dbh->errstr";
$dbh->do("create table eoo ( a int not null, b string not null, c int);") or die "create error: $dbh->errstr";


my @primary1=$dbh->primary_key(undef,undef,'aoo');
is(@primary1,1,"primary_key ok");

my @primary2=$dbh->primary_key(undef,undef,'boo');
is(@primary2,2,"primary_key ok");
my @primary3=$dbh->primary_key(undef,undef,'coo');
is(@primary3,1,"primary_key ok");
my @primary4=$dbh->primary_key(undef,undef,'doo');
is(@primary4,2,"primary_key ok");
my @primary5=$dbh->primary_key(undef,undef,'eoo');
is(@primary5,0,"primary_key ok");
done_testing();
$dbh->disconnect;


