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


my @primary1=$dbh->primary_key(undef,undef,'aoo') or die $dbh->errstr ."  primary_key error\n";
print "primary1: @primary1\n";
print @primary1 . ": Length1\n\n";
is(@primary1,1,"primary1 is ok");

my @primary2=$dbh->primary_key(undef,undef,'boo') or die $dbh->errstr ."  primary_key error\n";;
print "primary2: @primary2\n";
print @primary2 . ": Length2\n\n";
is(@primary2,2,"primary2 is ok");

my @primary3=$dbh->primary_key(undef,undef,'coo') or die $dbh->errstr ."  primary_key error\n";;
print "primary3: @primary3\n";
print @primary3 . ": Length3\n\n";
is(@primary3,1,"primary3 is ok");

my @primary4=$dbh->primary_key(undef,undef,'doo') or die $dbh->errstr ."  primary_key error\n";;
print "primary4: @primary4\n";
print @primary4 . ": Length4\n\n";
is(@primary4,2,"primary4 is ok");

my @primary5=$dbh->primary_key(undef,undef,'eoo');#  or die $dbh->errstr ."  primary_key error\n";;
print "primary5: @primary5\n";
print @primary5 . ": Length5\n\n";
is(@primary5,0,"primary5 is ok");

done_testing();
$dbh->disconnect;


