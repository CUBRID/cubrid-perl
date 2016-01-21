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

eval {$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1, AutoCommit => 0});};

if($@)
{
   print "An error occurred ($@), continuing \n";
}

eval {$dbh -> do("drop table if EXISTS tbl;")};

if($@){
	print "An error occurred($@) when drop an exists table! \n";
}

eval {$dbh -> do("create table tbl(id int primary key,name char(20),lastName char(20));")};

if($@){
	print "An error occurred($@) when create a new table !\n";
}

$dbh->commit or die $dbh->errstr ." :commit error\n";

my $insertString="insert into tbl values(1,'name1','lastName1'),(2,'name2','lastName2'),(3,'name3','lastName3'),(4,'name4','lastName4')";
$dbh ->do($insertString) or die "insert error: $dbh->errstr";

plan tests=>2;
ok($dbh ->rollback,"rollback ok");
my $sth=$dbh->prepare("select * from tbl ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  update error\n";
my $rows=$sth->rows;
is($rows,0,"rollback ok");

$sth->finish();
$dbh -> disconnect();




