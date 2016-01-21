#!perl -w
#Test login without host.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=;port=".$port;
#print "$dsn\n";
my $user="dba";
my $pass="";
my $dbh=DBI->connect($dsn, $user,$pass,{PrintError=>1, AutoCommit=>0});

print $dbh;

