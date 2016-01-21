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
$dbh->do("create table staff(id int, fname varchar(10) );") or die "create error: $dbh->errstr";

my @id=(11,12,13,14);
my @names=("GarrettName", "ViktoriaName", "BassoName");

my $sth= $dbh->prepare("insert into staff values(?,?);") or die "prepare error: $dbh->errstr";
$sth->bind_param_array(1,\@id) or die "bind_param_array error: $dbh->errstr";
$sth->bind_param_array(2,\@names) or die "bind_param_array error: $dbh->errstr";
my $rv=$sth->execute_array(undef) or die "execute_array error: $dbh->errstr";
#print "rv value is $rv\n";

plan tests=>1;
ok($rv eq 4, "execute_array ok");

my $SQL = 'SELECT id, fname FROM staff ORDER BY fname';
for my $row (@{$dbh->selectall_arrayref($SQL)}) {
    print "Found: $row->[0] : $row->[1]\n";
}


$sth->finish();
$dbh->disconnect();


