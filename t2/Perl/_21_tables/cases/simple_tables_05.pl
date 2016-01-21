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

my @tables=$dbh->tables(undef,undef,'%','VIEWaaaaaaaa'); 
is(@tables,0,"tables ok");
done_testing();




$dbh->disconnect();


