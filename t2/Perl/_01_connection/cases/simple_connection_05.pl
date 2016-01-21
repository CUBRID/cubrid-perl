#!perl -w
#Test error user login.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=".$port;
#print "$dsn\n";
my $user="gao";
my $pass="";
my $dbh=DBI->connect($dsn, $user,$pass,{PrintError=>0, AutoCommit=>0});

#print $dbh;

is ($dbh,undef, "Connected to database");
is ($DBI::err,-20001, "check error number");
like($DBI::errstr, qr/User "gao" is invalid/,"check error message");
done_testing();
