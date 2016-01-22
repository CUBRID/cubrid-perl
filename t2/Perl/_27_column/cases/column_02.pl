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
$dbh -> do("create table tdb (c char, vc varchar(5), bt bit, bv BIT VARYING, nm numeric, dc decimal(5,2), it int, sint smallint, rl real, db double, dt date, tm time, tms timestamp, bi bigint, dtt datetime);") or die "create error: $dbh->errstr";

my @values=(1,"CHAR(1)","c",
12,"VARCHAR(5)","vc",
-2,"BIT(1)","bt",
-3,"BIT VARYING(1073741823)","bv",
2,"NUMERIC(15,0)","nm",
2,"NUMERIC(5,2)","dc",
4,"INTEGER","it",
5,"SHORT","sint",
6,"FLOAT","rl",
8,"DOUBLE","db",
91,"DATE","dt",
92,"TIME","tm",
93,"TIMESTAMP","tms",
-5,"BIGINT","bi",
93,"DATETIME","dtt");
my $i=0;
my $sth=$dbh->column_info(undef,undef,'tdb','%') or die "column_info error: $dbh->errstr";
my $dataType;

#http://jira.cubrid.org/browse/APIS-412
=pod
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DATA_TYPE},$values[$i++],"data type $i compare");
   is($hash_ref->{TYPE_NAME},$values[$i++],"type name $i compare");
   is($hash_ref->{COLUMN_NAME},$values[$i++],"column name $i compare");
}

done_testing();
=cut



$sth->finish();
$dbh->disconnect();





