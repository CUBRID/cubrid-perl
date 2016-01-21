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
$dbh->do('abc');
my $err1=$dbh->errstr; 
$dbh->ping;
my $err2=$dbh->errstr; 
#print "err1:$err1\n";
#print "err2:$err2\n";

plan tests=>1;
ok($err1 eq $err2, "ping ok");
$dbh->disconnect();


