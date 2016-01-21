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
$dbh -> do("create table tdb (dt date, tm time, dtt datetime);") or die "create error: $dbh->errstr";

my $sth=$dbh->column_info(undef,undef,'tdb','%') or die "column_info error: $dbh->errstr";
my $dataType;
my @value=(91,"DATE","dt",92,"TIME","tm",93,"DATETIME","dtt");
my $i=0;
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DATA_TYPE},$value[$i++],"column_info ok");
   is($hash_ref->{TYPE_NAME},$value[$i++],"column_info ok");
   is($hash_ref->{COLUMN_NAME},$value[$i++],"column_info ok");
}

done_testing();



$sth->finish();
$dbh->disconnect();





