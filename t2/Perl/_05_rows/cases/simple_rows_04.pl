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
$dbh -> do("drop table if EXISTS tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tbl(id int);") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into tbl values(?);");
my $i=0;
while($i<100000)
{
	$sth->execute("$i") or die "insert error: $dbh->errstr";
        $i++;
}

my $sth=$dbh->prepare("select * from tbl");
$sth->execute or die "select error: $dbh->errstr";
my $rv =$sth->rows;
print "Number of rows is $rv \n";

plan tests=>1;
ok ($rv eq 100000,"rows of select ok");

$sth->finish();
$dbh->disconnect();


