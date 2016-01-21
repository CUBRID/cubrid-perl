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


print "Database connection information \n\n";
my $database_version=$dbh->get_info(18) or die "get_info(18) error: $dbh->errstr";
my $max_select_tables = $dbh->get_info( 106 ) or die "get_info(106) error: $dbh->errstr";
print "database_version is $database_version\n";
print "max_select_tables: $max_select_tables\n";


$dbh->disconnect();

