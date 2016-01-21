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

my $sth= $dbh->prepare(<<"EOF");
INSERT INTO staff (lastName, depthName) VALUES(?, ?)
EOF

$sth->bind_param_array(1, [ undef, 'foo' ]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2, [ 'bar', undef]) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";

plan tests=>1;
ok($rv eq 2 ,"execute_array ok");
#print "rv value is $rv\n";
my ($lastName,$depthName) =$dbh->selectrow_array(<<"EOF");
select  lastName,  depthName from staff
EOF

print " Last:$lastName\t Depth:$depthName\n";

$sth->finish();
$dbh->disconnect();


