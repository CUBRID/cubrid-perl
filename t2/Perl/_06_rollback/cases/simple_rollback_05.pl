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

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

eval {$dbh=DBI->connect($dsn, $user, $pass,
	{RaiseError => 1, AutoCommit => 0});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

eval {$dbh -> do("drop table if EXISTS rollback_tb;")};
if($@){
	print "An error occurred($@) when drop an exists table! \n";
}

eval {$dbh -> do("create table rollback_tb(age int,firstName char(20),lastName char(10),income float);")};
if($@){
	print "An error occurred($@) when create a new table !\n";
}

my $age=26;
my $firstName="john";
my $lastName="poul";
my $income=13000;
my $sth=$dbh->prepare("insert into rollback_tb (age,firstName,lastName,income) values (?,?,?,?);");
$sth->execute($age,$firstName,$lastName,$income) or die "execute error: $dbh->errstr";

plan tests=>3;
ok($dbh ->rollback,"rollback ok");
my $sth=$dbh->prepare("select * from db_class where class_name='rollback_tb' ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  update error\n";
my $rows=$sth->rows;
is($rows,1,"rollback ok");
$sth->finish;

$dbh -> do("drop table rollback_tb;");
my $sth=$dbh->prepare("select * from db_class where class_name='rollback_tb' ") or die $dbh->errstr ." prepare error\n";
$sth->execute or die  $dbh->errstr ."  update error\n";
my $rows=$sth->rows;
is($rows,0,"rollback ok");

$sth->finish();
$dbh -> disconnect();




