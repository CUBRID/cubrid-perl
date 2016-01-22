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
$dbh -> do("drop table if EXISTS tb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tb (id int NOT NULL PRIMARY KEY,bgi bigint, bt bit, bb blob,cb clob, ft float, my monetary, st smallint, dt date, tm time, dtt datetime, dc decimal(15,3),vc varchar(15),bv bit varying, cv character varying, db double,  mf multiset(int,char(1)), nc national character);") or die "create error: $dbh->errstr";

my @values=(undef,10,4,undef,undef,undef,
undef,19,-5,undef,undef,undef,
undef,1,-2,undef,undef,undef,
undef,0,30,undef,undef,undef,
undef,0,40,undef,undef,undef,
undef,14,6,undef,undef,undef,
2,14,6,undef,undef,undef,
undef,5,5,undef,undef,undef,
undef,10,91,undef,undef,undef,
undef,8,92,undef,undef,undef,
undef,23,93,undef,undef,undef,
3,38,2,undef,undef,undef,
undef,15,12,undef,undef,undef,
undef,1073741823,-3,undef,undef,undef,
undef,1073741823,12,undef,undef,undef,
undef,28,8,undef,undef,undef,
undef,1073741823,12,undef,undef,undef,
undef,1,12,undef,undef,undef);
my $sth=$dbh->column_info(undef,undef,'tb','%') or die "column_info error: $dbh->errstr";
my $dataType;

#http://jira.cubrid.org/browse/APIS-412
=pod
while(my $hash_ref=$sth->fetchrow_hashref()){
   is($hash_ref->{DECIMAL_DIGITS},$values[$i++],"decimal digits $i compare");
   is($hash_ref->{COLUMN_SIZE},$values[$i++],"column size $i compare");
   is($hash_ref->{SQL_DATA_TYPE},$values[$i++],"sql data type $i compare");
   is($hash_ref->{TABLE_CAT_TYPE},$values[$i++],"table cat type $i compare");
   is($hash_ref->{TABLE_SCHEM},$values[$i++],"table schem $i compare");
   is($hash_ref->{COLUMN_DEF},$values[$i++],"column def $i compare");

}
done_testing();
=cut

$sth->finish();
$dbh->disconnect();





