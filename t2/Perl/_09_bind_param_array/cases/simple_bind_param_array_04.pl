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
$dbh -> do("create table tdb(id int, name char(20));") or die "create error: $dbh->errstr";
$dbh -> do("insert into tdb values(1,'Johny'),(2,'lisi'),(3,'wangwu'),(4,'mazi');") or die "insert error:$dbh->errstr";

my @names=('aaa%','bbb%','Jo%');
my $sth=$dbh->prepare("update tdb set id=id+1 where name LIKE ?;") or die "select error: $dbh->errstr";
$sth->bind_param_array(1,\@names) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array( { ArrayTupleStatus => \my @tuple_status } ) or die "execute_array error: $dbh->errstr";
#print "rv values is $rv\n";

plan tests=>1;
ok($rv eq 3, "bind_param_array ok" );
$sth->finish();
$dbh -> disconnect();
