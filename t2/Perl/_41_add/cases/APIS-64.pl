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
while(my $hash_ref=$sth->fetchrow_hashref()){
   print "DATA_TYPE:  $hash_ref->{DATA_TYPE}\n TYPE_NAME: $hash_ref->{TYPE_NAME}\n";
   print "TABLE_NAME: $hash_ref->{TABLE_NAME}\n";
   print "COLUMN_NAME: $hash_ref->{COLUMN_NAME}\n\n\n";
}



my @type_info =@{$dbh->type_info_all()};
my $sql_info=$type_info[0]->{DATA_TYPE};


$sth->finish();
$dbh->disconnect();





