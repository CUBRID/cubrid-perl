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


$dbh->do("drop table if EXISTS aoo ;") or die "drop error: $dbh->errstr";
$dbh->do("create table aoo ( a int , b int, c int );") or die "create error: $dbh->errstr";


my @primary1=$dbh->primary_key(undef,undef,'aoo');# or die $dbh->errstr . "  :primary error\n";
my $err=$dbh->errstr;
print "$err\n";
print "primary1: @primary1\n";
print @primary1 . ": Length1\n\n";
is (@primary1,0,"no pk");
done_testing();

$dbh->disconnect;


