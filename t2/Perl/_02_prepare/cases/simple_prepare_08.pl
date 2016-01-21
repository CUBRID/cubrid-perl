#!perl -w

#using NULL value

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
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect err: $dbh->errstr";

plan tests=>1;
$dbh->prepare("SELECT '2002-01-01'+1;");
my $resultPrepare=$dbh->errstr;
#print "resultPrepare is $resultPrepare\n";

ok($resultPrepare,"prepare ok");

$dbh -> disconnect();
