#!perl -w
#Test can login by no user.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my %atrr=(
    PrintError=>1,
    RaiseError=>0,
);

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=".$port;
#print "$dsn\n";
my $user="dba";
my $pass="";
my $dbh=DBI->connect($dsn, $user, $pass, \%atrr) ;

#print $dbh;

#is($dbh,undef, "Connected to database");
#is($DBI::err, -20030, "check error number");
#like($DBI::errstr, qr/CCI Error : Invalid url string/, "check error message");

done_testing();
