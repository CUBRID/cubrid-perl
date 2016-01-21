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
$dbh -> do("drop table if EXISTS coo;") or die "drop error: $dbh->errstr";
$dbh -> do("create class coo(col1 char(20),col2 nchar(20),col3 nchar varying(20),col4 bit(8),col5 bit varying(8),col6 numeric,col7 integer,
col8 smallint,col9 monetary,col10 float,col11 double,col12 date,col13 time,col14 timestamp,col15 set,col16 multiset,col17 sequence, col18 blob );") or die "create error: $dbh->errstr";

my $sth=$dbh->prepare("insert into coo values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);") or die "prepare error: $dbh->errstr";
my $paramNumber=$sth->{NUM_OF_PARAMS};
is($paramNumber,18,"NUM_OF_PARAMS ok");
done_testing();

$sth->finish();
$dbh -> disconnect();



