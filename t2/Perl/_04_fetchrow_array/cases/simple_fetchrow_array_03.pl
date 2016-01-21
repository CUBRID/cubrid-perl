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
$dbh -> do("drop table if EXISTS test_tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table test_tbl(age int,firstName char(20),lastName char(10),income float);") or die "create error: $dbh->errstr";
$dbh->do("insert into test_tbl values (26,'john','poul',13000),(26,'Bobo','Li',9000),(33,'Jacky','Wang',16000);") or die "insert: $dbh->err
str";

plan tests=>1;
my $name="joh%";
my $sth=$dbh->prepare("select firstName, lastName from test_tbl where firstName like ?;");
$sth->execute($name) or die "execute select: $dbh->errstr\n";
while(my @row =$sth->fetchrow_array()){
   my ($first,$last)=@row;
   print "Firstname: $first;   LastName: $last\n";
   my $length=@row;
   ok($length eq 2, "fetchrow_array ok");
   print "\n\n";
}

$sth->finish();
$dbh -> disconnect();

