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


my $sth=$dbh->prepare("SELECT 4 + '5.2'") or die "prepare error: $dbh->errstr";
$sth->execute or die "execute error: $dbh->errstr";
my $row_ref3 =$sth->fetchrow_arrayref();
my $value3=$row_ref3->[0];
#print "value: $value3\n";
ok($value3 eq  9.199999999999999e+00, "value3 ok");
ok($row_ref3->[0] eq 9.2,"value ok");
#print "row_ref3 is $row_ref3->[0]\n ";
$sth->finish();
done_testing();
$dbh->disconnect();




