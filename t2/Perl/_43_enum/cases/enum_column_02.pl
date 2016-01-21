#!perl -w
#Test the schema of many enum is ok.
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
$dbh -> do("drop table if EXISTS enumcol;") or die "drop error: $dbh->errstr";
$dbh -> do("create table enumcol (id int, e1 enum('a','b'),e2 enum('c','d'));") or die "create error: $dbh->errstr";

my $sth=$dbh->column_info(undef,undef,'enumcol','%') or die "column_info error: $dbh->errstr";
my $dataType;
my @value=(4,"INTEGER","id",12,"ENUM('A', 'B')","e1",12,"ENUM('C', 'D')","e2");
my $i=0;
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DATA_TYPE},$value[$i++],"column_info ok");
   is($hash_ref->{TYPE_NAME},$value[$i++],"column_info ok");
   is($hash_ref->{COLUMN_NAME},$value[$i++],"column_info ok");
}

done_testing();

$sth->finish();
$dbh->disconnect();





