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

$dbh -> do("drop table if EXISTS tdb;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (id int, a char(1), b char(2), c char(3));") or die "create error: $dbh->errstr";
warn DBI->VERSION;
warn DBD::cubrid->VERSION;


(my $ci=$dbh->column_info(undef,undef,'tdb','%'))->bind_col(4,\my $c);
my @columns=();
push @columns, $c while $ci->fetch;


warn join "\n", @columns;


$dbh->disconnect();
