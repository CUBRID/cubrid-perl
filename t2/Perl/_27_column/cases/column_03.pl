#!perl -w

use DBI;
use Test::More;
use DBI qw(:sql_types);
#use strict;

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
$dbh -> do("create table tdb (mn monetary, st SET, ms MULTISET, sq SEQUENCE );") or die "create error: $dbh->errstr";

my @values=(6,"MONETARY","mn",
0,"NULL","st",
0,"NULL","ms",
0,"NULL","sq");
my $sth=$dbh->column_info(undef,undef,'tdb','%') or die "column_info error: $dbh->errstr";
my $dataType;
my $i=0;
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DATA_TYPE},$values[$i++],"column_info ok");
   is($hash_ref->{TYPE_NAME},$values[$i++],"column_info ok");
   is($hash_ref->{COLUMN_NAME},$values[$i++],"column_info ok");
}

done_testing();

$sth->finish();
$dbh->disconnect();





