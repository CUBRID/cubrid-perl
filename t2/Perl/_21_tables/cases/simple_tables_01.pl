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


$dbh->do("drop table if EXISTS staff;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS t1;") or die "drop error: $dbh->errstr";

$dbh->do("create table staff(id int, fname varchar(10) );") or die "create error: $dbh->errstr";
$dbh->do("CREATE TABLE t1(col1 INT PRIMARY KEY, col2 VARCHAR(20), col3 CHAR(1));") or die "create error: $dbh->errstr";

my @tables=$dbh->tables();
my $counter=0;
foreach my $table (@tables){
   $counter++;
}
print $counter;
#is( $counter,65,"tables ok");
done_testing();
$dbh->do("drop table if EXISTS staff;") or die "drop error: $dbh->errstr";
$dbh->do("drop table if EXISTS t1;") or die "drop error: $dbh->errstr";

$dbh->disconnect();


