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
$dbh->do("create table staff( firstName varchar(10), lastName varchar(10), depthName varchar(10) );") or die "create error: $dbh->errstr";

my $sth= $dbh->prepare("INSERT INTO staff (firstName, lastName, depthName) VALUES(?, ?, ?)");
$sth->bind_param_array(1, [ undef, 'Mary', 'Tim' ]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2, [ undef, 'Todd', 'Robinson' ]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(3, "SALES") or die "bind_param_array error: $dbh->errstr"; 
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";

plan tests=>1;
ok($rv eq 3 ,"execute_array ok");
#print "rv value is $rv\n";




$dbh->disconnect();


