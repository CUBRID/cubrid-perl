#!perl -w

use DBI;
use Test::More;
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
$dbh->do("drop table if EXISTS ss;") or die "drop error: $dbh->errstr";
$dbh->do("CREATE TABLE ss (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, text VARCHAR(32));") or die "create error: $dbh->errstr";

my $id=$dbh->last_insert_id(undef,undef,ss,undef);# or die "last error: $dbh->errstr";

plan tests=>1;
ok(! $id, "last_insert_id ok");
$dbh->disconnect();


