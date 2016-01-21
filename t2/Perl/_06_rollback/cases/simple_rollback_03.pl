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
$dbh=DBI->connect($data_source, $user, $pass,{RaiseError => 1,AutoCommit =>0}) or die "connect error: $dbh->errstr";
$dbh -> do("drop table if EXISTS rollback_tb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table rollback_tb(id int,name varchar(10), lastName varchar(5));") or die "create error: $dbh->errstr";
my $insertString="insert into rollback_tb values(1,'name1','last1'),(2,'name2','last2'),(3,'name3','last3'),(4,'name4','last4')";
$dbh->do($insertString) or die  $dbh->errstr ." :insert error\n";
$dbh->commit or die "commit error: $dbh->errstr";

my $upStr="update rollback_tb set id =5 where id=4;";
$dbh->do($upStr) or die"upStr error:$dbh->errstr";

plan tests=>2;
ok($dbh ->rollback(),"rollback ok");
my $sth=$dbh->prepare("select * from rollback_tb where id=5 ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  update error\n";
my $rows=$sth->rows;
is($rows,0,"rollback ok");

$sth->finish;
$dbh -> disconnect();




