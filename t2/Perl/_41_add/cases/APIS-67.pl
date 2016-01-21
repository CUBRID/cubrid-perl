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
$dbh -> do("drop table if EXISTS atype2;") or die "drop error: $dbh->errstr";
$dbh -> do("create table atype2(nm NUMERIC(9,4), it int, sit smallint, mn monetary,db double );") or die $dbh->errstr . "  :create error\n"
;

my $sth=$dbh->column_info(undef,undef,'atype2','%') or die "column_info error: $dbh->errstr";
while(my $hash_ref=$sth->fetchrow_hashref()){
   print "COLUMN_NAME: $hash_ref->{COLUMN_NAME}\n";
   print "COLUMN_SIZE: $hash_ref->{COLUMN_SIZE}\n";
   print "SQL_DATA_TYPE: $hash_ref->{SQL_DATA_TYPE}\n";
   print "DECIMAL_DIGITS: $hash_ref->{DECIMAL_DIGITS}\n";
   print "\n\n";

}








$sth->finish();
$dbh->disconnect();

