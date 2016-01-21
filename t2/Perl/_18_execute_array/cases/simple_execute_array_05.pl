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
$dbh->do("drop table if EXISTS staff;") or die "drop error: $dbh->errstr";
$dbh->do("create table staff(id varchar(10), fname varchar(10) );") or die "create error: $dbh->errstr";
$dbh->do("insert into staff values(1,'GarrettName'),(2,'ViktoriaName'),(3,'BassoName'),(4,'Jing') ;") or die "inser error: $dbh->errstr";

my $sth1=$dbh->prepare("select * from staff;") or die "prepare error: $dbh->errstr";
$sth1->execute or die "execute error: $dbh->errstr";
my $ref=$sth1->fetchall_arrayref() or die "fetchall_arrayref error: $dbh->errstr";

my $sth2= $dbh->prepare("insert into staff values(?,?);") or die "prepare error: $dbh->errstr";
$sth2->bind_param_array(1,$ref->[0]) or die "bind_param_array error: $dbh->errstr";
$sth2->bind_param_array(2,$ref->[1]) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth2->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";

plan tests=>1;
ok($rv eq 2, "execute_array ok");


$sth1->finish();
$sth2->finish();
$dbh->disconnect();


