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

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

eval {$dbh=DBI->connect($data_source, $user, $pass,{RaiseError => 1, AutoCommit => 0});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

$dbh->do("drop table if EXISTS rollback_tb;") or die  $dbh->errstr ."  update error\n";
$dbh->commit or die $dbh->errstr ." :commit error\n";
 
plan tests=>2;
$dbh->do("create table rollback_tb(id int primary key);") or die "create error: $dbh->errstr";
ok($dbh->rollback, "rollback ok");
my $sth=$dbh->prepare("select * from db_class where class_name='rollback_tb' ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  update error\n";
my $rows=$sth->rows;
is($rows,0,"rollback ok");

$sth->finish();
$dbh->disconnect();

