#!perl -w
#Test login with error password.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=".$port;
#print "$dsn\n";
my $user="dba";
my $pass="ass";
my $dbh=DBI->connect($dsn, $user,$pass,{PrintError=>1, AutoCommit=>0});

#print $dbh;

is ($dbh,undef, "Connected to database");
is ($DBI::err,-20001, "check error number");
like ($DBI::errstr,qr/Incorrect or missing password/,"check error message");
done_testing();
