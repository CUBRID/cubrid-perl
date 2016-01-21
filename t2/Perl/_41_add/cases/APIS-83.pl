#!perl -w

use DBI;
use Test::More;
use DBI qw(:sql_types);
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
$dbh -> do("drop table if EXISTS atype3;") or die  $dbh->errstr ."   :drop error\n";
$dbh -> do("create table atype3(st SET, ms MULTISET, sq SEQUENCE);") or die $dbh->errstr . "  :create error\n";

my $sth=$dbh->column_info(undef,undef,'atype3','%') or die "column_info error: $dbh->errstr";

while(my $hash_ref=$sth->fetchrow_hashref()){
   print "DATA_TYPE:  $hash_ref->{DATA_TYPE}\t TYPE_NAME: $hash_ref->{TYPE_NAME}\t";
   print "TABLE_NAME: $hash_ref->{TABLE_NAME}\t";
   print "COLUMN_NAME: $hash_ref->{COLUMN_NAME}\n\n\n";
}

$sth->finish();
$dbh->disconnect();

