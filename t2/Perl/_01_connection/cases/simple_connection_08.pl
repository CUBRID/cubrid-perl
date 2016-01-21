#!perl -w
#Test login without port.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=";
#print "$dsn\n";
my $user="";
my $pass="";
my $dbh=DBI->connect($dsn, $user,$pass,{PrintError=>1, AutoCommit=>0}); 
#or die $DBI::errstr;

print "dbh:+++++++++++++++ "+$DBI::errstr;
is($dbh, undef, "failed to connect to CUBRID CAS");
done_testing();
