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
	{RaiseError => 1});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (age int, firstName char(20), lastName char(10), income float, sex char(1)) ;") or die "create error:$dbh->errstr";

eval {$dbh->do("insert into tdb values (30,'john','poul',13000,'F'),(26,'Bobo','Li',9000,'M'),(33,'Jacky','Wang',16000,'F');")};
if($@){
        print "An error occurred($@) when insert values!\n";
}

plan tests=>1;
my $sth=$dbh->prepare("delete from tdb where age=26;");
$sth->execute or die "delete error:$dbh->errstr";
my $rows=$sth->rows;
is($rows,1,"value of rows is ok ");

$sth->finish();
