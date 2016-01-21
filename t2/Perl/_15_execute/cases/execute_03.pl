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
$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb(age int,firstName varchar(20),lastName varchar(20));") or die "create error: $dbh->errstr";

my @values=(1,'Jim','Bri');
my $sth2=$dbh->prepare("insert into tdb values(?,?,?);") or die "prepare error: $dbh->errstr";
$sth2->execute(@values) or die "execute error: $dbh->errstr";
$dbh->{PrintError}=1;
$dbh->{RaiseError}=0;
my $sth=$dbh->prepare("select * from tdb where age=?;") or die "prepare error: $dbh->errstr";
my $exResult=$sth->execute("Adams");# or die "execute error: $dbh->errstr";
like($DBI::errstr,qr/Domain \"integer\" is not compatible with domain/,"no data");
done_testing();
$sth->finish();
$sth2->finish();
$dbh -> disconnect();

