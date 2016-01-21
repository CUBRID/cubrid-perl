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
print $data_source."\n";
my $dbh;

eval {$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1, AutoCommit => 1});};

if($@)
{
   print "An error occurred ($@), continuing \n";
}

eval {$dbh -> do("drop table if EXISTS tbl;")};

if($@){
	print "An error occurred($@) when drop an exists table! \n";
}

eval {$dbh -> do("create table tbl(id int);")};

if($@){
	print "An error occurred($@) when create a new table !\n";
}

my $insertString="insert into tbl values(1),(2),(3),(4)";
$dbh->do($insertString) or die "sql $insertString error: $dbh->errstr";

ok(my $sth=$dbh->prepare("select * from tbl order by 1;"),"select prepare");
$sth->execute;
my $i=1;
while(my $arry=$sth->fetchrow_arrayref()){
 is($arry->[0],$i,'data right');
 $i++;
}
$sth->finish();
done_testing();
$dbh -> disconnect();
