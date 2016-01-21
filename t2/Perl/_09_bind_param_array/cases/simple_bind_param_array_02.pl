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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(typeid_ tinyint NOT NULL default 0, type_ varchar(50) NOT NULL, typeabr_ varchar(50) NULL);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tdb (typeid_, type_, typeabr_) values(?,?,?); ") or die "prepare error: $dbh->errstr";
$sth->bind_param_array(1,[30]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2,["aa"]) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(3,["bb"]) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv values is $rv\n";

plan tests=>1;
ok($rv eq 1,"bind_param_array ok");

$sth->finish();
$dbh -> disconnect();
