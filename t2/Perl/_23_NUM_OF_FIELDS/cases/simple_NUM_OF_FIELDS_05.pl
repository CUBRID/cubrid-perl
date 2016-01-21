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
$dbh -> do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tb (id int NOT NULL PRIMARY KEY,bgi bigint);") or die "create error: $dbh->errstr";
$dbh->do("insert into tb values (1, 90.1),(2,80),(3,99.6)");

my $sth=$dbh->prepare("insert into tb values (4,50)") or die "prepare error: $dbh->errstr";
$sth->execute() or die "execute error: $dbh->errstr";
my $fieldNumber=$sth->{NUM_OF_FIELDS};

is($fieldNumber,undef,"NUM_OF_FIELDS ok");
is($sth->{NAME}->[0],undef,"NUM_OF_FIELDS ok");
is($sth->{TYPE}->[0],undef, "NUM_OF_FIELDS ok");
done_testing();


$sth->finish();
$dbh -> disconnect();



