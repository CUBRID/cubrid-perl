#!perl -w
#Test login without user.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=".$port;
#print "$dsn\n";
my $user="dba";
my $pass="";
my $dbh=DBI->connect($dsn, $pass,{PrintError=>1, AutoCommit=>0});

#print $dbh;

