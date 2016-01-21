#!perl -w
#Test login without any user.
use DBI;
use Test::More;
use strict;

my $db=$ARGV[0];
my $host=$ARGV[1];
my $port=$ARGV[2];

my $dsn="dbi:cubrid:database=".$db.";host=".$host.";port=".$port;
#print "$dsn\n";
my $user="";
my $pass="";
my $dbh=DBI->connect($dsn, $user,$pass,{PrintError=>1, AutoCommit=>0});

#print $dbh;

ok defined $dbh, "Connected to database";
is ($DBI::err,undef, "check error number");
ok ($dbh->disconnect(), "disconnect ok");
done_testing();
