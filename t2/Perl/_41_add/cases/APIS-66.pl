#!perl -w

use DBI;
use Test::More;
use strict;

use vars qw($port $hostname);

$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";


my $dsn="dbi:cubrid:database=demodb;host=$hostname;port=$port";
my $dbh;
$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh -> do("drop table if EXISTS bit_tbl;") or die "drop error: $dbh->errstr";
$dbh -> do("CREATE TABLE bit_tbl(id int, a1 bit);") or die "create error: $dbh->errstr";

#http://jira.cubrid.org/browse/APIS-412
=pod
my $sth=$dbh->prepare("insert into bit_tbl values(?,?);") or die "prepare error: $dbh->errstr";
$sth->execute(1,"B'1'") or die $dbh->errstr .": execute error" ;
$sth->finish;
=cut

$dbh -> disconnect();



