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

my $dsn="dbi:cubrid:database=demodb;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

my $sth=$dbh->prepare("select * from db_class where is_system_class=? and class_type = ?") or die "prepare error: $dbh->errstr";
$sth->execute('YES','VCLASS') or die "execute error: $dbh->errstr";
my $paramNumber=$sth->{NUM_OF_PARAMS};
is($paramNumber,2,"NUM_OF_PARAMS ok");
done_testing;


$sth->finish();
$dbh -> disconnect();



