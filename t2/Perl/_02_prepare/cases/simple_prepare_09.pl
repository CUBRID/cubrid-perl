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
	{RaiseError => 1, AutoCommit => 1});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

eval {$dbh -> do("drop table if EXISTS color;")};
if($@){
	print "An error occurred($@) when drop an exists table! \n";
}

eval {$dbh -> do("create table color(id int, name varchar(10), color enum('red','green','orange','blue','yellow'));")};

if($@){
	print "An error occurred($@) when create a new table !\n";
}

plan tests=>11;
ok(my $sth=$dbh->prepare("insert into color (id) values(?);"), "prepare ok");
my $i=0;
while($i<10)
{
	ok($sth->execute("$i"),"prepare of insert succeed");
        $i++;
}

$sth->finish();
$dbh->disconnect();


